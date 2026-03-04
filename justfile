default:
  @just --list

# Install all easily
start:
  docker compose -f compose.yaml up

start-traefik:
  docker compose -f compose.yaml -f compose.traefik.yaml up

stop:
  docker compose -f compose.yaml -f compose.traefik.yaml down

mknet:
  docker network create nitro
  docker network create traefik

base-assets:
  git clone https://git.mc8051.de/nitro/arcturus-morningstar-default-swf-pack.git assets/swf/ && \
  git clone https://git.mc8051.de/nitro/default-assets.git assets/assets/ && \
  wget -O room.nitro.zip https://git.mc8051.de/attachments/e948e603-d0ea-4948-b313-e8290a1c4bc9 && \
  unzip -o room.nitro.zip -d assets/assets/bundled/generic && \
  docker compose up db -d

get-assets:
  rm -rf assets/swf/gordon/PRODUCTION && \
  habbo-downloader --output ./assets/swf --domain com --command badgeparts && \
  habbo-downloader --output ./assets/swf --domain com --command badges && \
  habbo-downloader --output ./assets/swf --domain com --command clothes && \
  habbo-downloader --output ./assets/swf --domain com --command effects && \
  habbo-downloader --output ./assets/swf --domain com --command furnitures && \
  habbo-downloader --output ./assets/swf --domain com --command gamedata && \
  habbo-downloader --output ./assets/swf --domain com --command gordon && \
  habbo-downloader --output ./assets/swf --domain com --command hotelview && \
  habbo-downloader --output ./assets/swf --domain com --command icons && \
  habbo-downloader --output ./assets/swf --domain com --command mp3 && \
  habbo-downloader --output ./assets/swf --domain com --command pets && \
  habbo-downloader --output ./assets/swf --domain com --command promo && \
  cp -n assets/swf/dcr/hof_furni/icons/* assets/swf/dcr/hof_furni && \
  mv assets/swf/gordon/*PRODUCTION* assets/swf/gordon/PRODUCTION

build-assets:
  docker compose -f compose.assets.yaml up
  python3 ./assets/check_figuremap.py

check-assets:
  python3 ./assets/check_figuremap.py

fix-assets:
  python3 ./assets/fix_figuremap.py

merge-items:
  cd assets/ && \
  python3 ./merge_items.py && \
  python3 ./badge_name_update.py -f && \
  cd ..

update-translations:
  cd ./assets/translation && \
  python3 FurnitureDataTranslator.py && \
  python3 SQLGenerator.py && \
  python3 external_text.py --domain com && \
  bash initdb.sh
  cd ../..

init-emu-db:
  cd arcturus/initdb && \
  bash initdb.sh && \
  cd ../..

init-cms-db:
  docker compose exec cms php artisan migrate --seed && \
  echo "Complete setup on web ui then run just init-cms-db-2"

init-cms-db-2:
  cd atomcms/initdb && \
  bash initdb.sh && \
  cd ../..

clean-cms-cache:
  docker compose exec cms php artisan cache:clear
  docker compose exec cms php artisan route:clear

backup-db:
  docker compose exec backup backup-now

backup-files:
  7z a -mx=9 nitro-$(date -d "today" +"%Y%m%d_%H%M").7z ./ '-x!db/data' '-x!.git/' '-x!logs/' '-x!cache/'