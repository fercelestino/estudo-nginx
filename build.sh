#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/docker/apisix/src/apisix.jsonnet"
DIST_DIR="$SCRIPT_DIR/docker/apisix/dist"
OUT="$DIST_DIR/apisix.yaml"

# ENV selects which envs/<name>.env file to load. Default: dev.
# Usage: ./build.sh            → uses envs/dev.env
#        ENV=prod ./build.sh   → uses envs/prod.env
ENV="${ENV:-dev}"
ENV_FILE="$SCRIPT_DIR/envs/${ENV}.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE" >&2
  exit 1
fi

# Export vars from the env file so they are available below.
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

if ! command -v jsonnet &>/dev/null; then
  echo "ERROR: jsonnet is not installed. See README.md for installation instructions." >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
jsonnet --string "$SRC" -o "$OUT" \
  --ext-str CONTROLLER_SERVER="${CONTROLLER_SERVER}" \
  --ext-str VECTORHUB_SERVER="${VECTORHUB_SERVER}" \
  --ext-str API_SERVER="${API_SERVER}" \
  --ext-str VICTORIAPRO_SERVER="${VICTORIAPRO_SERVER}" \
  --ext-str REDIS_HOST="${REDIS_HOST}" \
  --ext-str REDIS_PORT="${REDIS_PORT}" \
  --ext-str REDIS_PASSWORD="${REDIS_PASSWORD}" \
  --ext-str OTEL_ENDPOINT="${OTEL_ENDPOINT}"

echo '#END' >> "$OUT"
echo "Built: $OUT (ENV=${ENV})"
