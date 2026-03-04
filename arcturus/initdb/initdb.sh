#!/bin/bash
# import-sql-ordered.sh - Importa file SQL con LOCKFILE per resume
# Skippa file già importati (*.sql.lock)

set -euo pipefail

SQL_DIR="${1:-.}"
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="arcturus_user"
MYSQL_PASS="arcturus_pw"
MYSQL_DB="arcturus"

# Check pv
command -v pv &> /dev/null || { echo "❌ Installa pv: sudo apt install pv"; exit 1; }

# Check dir
[ -d "$SQL_DIR" ] || { echo "❌ $SQL_DIR non trovata"; exit 1; }

cd "$SQL_DIR"

echo "🚀 Import SQL ordinato con RESUME: $SQL_DIR"
echo "📊 DB: $MYSQL_DB@$MYSQL_HOST:$MYSQL_PORT"

# Lista file ordinati
SQL_FILES=($(ls -1 [0-9][0-9]-*.sql 2>/dev/null | sort -V))

[ ${#SQL_FILES[@]} -eq 0 ] && { echo "ℹ️ Nessun [NN]-*.sql"; exit 0; }

echo "📋 File trovati (${#SQL_FILES[@]}):"
printf '  %s\n' "${SQL_FILES[@]}"

# Statistiche
total_files=${#SQL_FILES[@]}
total_size=0
skipped=0
imported=0

for sql_file in "${SQL_FILES[@]}"; do
    size=$(wc -c < "$sql_file")
    total_size=$((total_size + size))
    
    lock_file="${sql_file}.lock"
    [ -f "$lock_file" ] && skipped=$((skipped + 1))
done

echo "📈 Totale: $(numfmt --to=iec-i --suffix=B $total_size)"
echo "⏭️  Skip previsto: $skipped/$total_files"
echo "▶️  Inizio import..."
skipped=0
# Esecuzione
for sql_file in "${SQL_FILES[@]}"; do
    lock_file="${sql_file}.lock"
    
    if [ -f "$lock_file" ]; then
        echo "⏭️  [$((skipped + imported + 1))/$total_files] $sql_file (SKIP - lock: $(stat -c %y "$lock_file" 2>/dev/null || echo 'N/A')}"
        skipped=$((skipped + 1))
        continue
    fi
    
    echo ""
    echo "🔄 [$((skipped + imported + 1))/$total_files] $sql_file"
    
    # Esegui con pv + mysql
    if pv --progress --size "$(wc -c < "$sql_file")" "$sql_file" | \
       mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB"; then
        
        # Crea lockfile ATOMICO con timestamp
        echo "$(date -Iseconds) - OK" > "$lock_file" || {
            echo "⚠️  Lockfile fallito ma import OK"
        }
        echo "✅ $sql_file importato ✓ lock: $lock_file"
        imported=$((imported + 1))
    else
        echo "❌ ERRORE $sql_file"
        exit 1
    fi
done

echo ""
echo "🎉 COMPLETATO!"
echo "📊 $imported importati, $skipped saltati, $total_files totali"
echo "🔍 Lockfiles: ls *.lock"
echo "📋 Verifica: mysql -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e 'SHOW TABLES;'"
