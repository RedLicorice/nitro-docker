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
  cd ../..