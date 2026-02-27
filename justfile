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