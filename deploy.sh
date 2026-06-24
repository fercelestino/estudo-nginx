#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker/docker-compose.yml"

# Pass ENV through to build.sh (defaults to dev if not set).
# Usage: ./deploy.sh            → dev
#        ENV=prod ./deploy.sh   → prod
ENV="${ENV:-dev}" "$SCRIPT_DIR/build.sh"

docker compose -f "$COMPOSE_FILE" up -d --build --force-recreate
