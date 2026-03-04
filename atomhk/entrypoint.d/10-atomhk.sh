#!/bin/sh
# /var/www/html/init-artisan.sh - Script INIZIALIZZAZIONE dentro container AtomHK
# Path corretto: /var/www/html

set -e

LOCKFILE="/var/www/html/storage/.artisan-init.lock"
APP_DIR="/var/www/html"
MAX_WAIT=60

cd "$APP_DIR"

echo "🚀 Inizializzazione Laravel/AtomHK (container: $HOSTNAME)"

# Check lockfile
if [ -f "$LOCKFILE" ]; then
  echo "✅ Lockfile trovato: skip inizializzazione"
  echo "🧹 Clear cache..."
  php artisan config:clear --silent 2>/dev/null || true
  php artisan route:clear --silent 2>/dev/null || true
  echo "✅ Pronto (skip init)"
  exit 0
fi

echo "🔄 Lockfile non trovato: inizializzazione..."

# Attesa MySQL dal container
# echo "⏳ Attesa MySQL ($MAX_WAIT s max)..."
# counter=0
# while [ $counter -lt $MAX_WAIT ]; do
#   if php artisan db:show --no-ansi 2>/dev/null | grep -q "Tables: "; then
#     echo "✅ MySQL pronto!"
#     break
#   fi
#   sleep 1
#   counter=$((counter + 1))
# done

# [ $counter -eq $MAX_WAIT ] && { echo "❌ Timeout MySQL!"; exit 1; }

# Esecuzione artisan
echo "🔧 Comandi artisan..."

php artisan key:generate --force --ansi || echo "⚠️ APP_KEY già ok"

echo "📊 Migrazione..."
php artisan migrate:fresh --seed --force --ansi || echo "⚠️ Migrate già eseguito"

echo "🔗 Storage..."
php artisan storage:link --force --silent || echo "⚠️ Storage già linkato"

echo "⚙️ Cache..."
php artisan config:cache --ansi
php artisan route:cache --ansi

# Crea lockfile ATOMICO
(
  echo "Inizializzato: $(date)" > "$LOCKFILE"
  echo "Container: $HOSTNAME" >> "$LOCKFILE"
  echo "Working dir: $APP_DIR" >> "$LOCKFILE"
) 9>"$LOCKFILE.lock"

echo "🎉 ✅ Inizializzazione COMPLETATA! Lockfile: $LOCKFILE"
