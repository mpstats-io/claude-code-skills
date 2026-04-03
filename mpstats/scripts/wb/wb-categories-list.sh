#!/bin/bash
# wb-categories-list.sh — Get full WB category tree (rubricator)
# Usage: ./wb-categories-list.sh

if [ "$1" = "--help" ]; then
  echo "Usage: $0"
  echo "  Returns the full Wildberries category tree."
  echo "  Each item: {url, name, path}"
  echo ""
  echo "Environment:"
  echo "  MPSTATS_TOKEN — API token (or set in config/.env)"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

curl -s --location --request POST 'https://mpstats.io/api/analytics/v1/wb/category/list' \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{}'
