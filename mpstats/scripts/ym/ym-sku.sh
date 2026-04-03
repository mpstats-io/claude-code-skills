#!/bin/bash
# ym-sku.sh — Get sales and stock history for a Yandex Market item
# Usage: ./ym-sku.sh <id> [d1] [d2]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <id> [d1] [d2]"
  echo "  id — Yandex Market item ID (numeric), e.g. 12345678"
  echo "  d1 — start date YYYY-MM-DD (optional)"
  echo "  d2 — end date YYYY-MM-DD (optional)"
  echo ""
  echo "  Returns sales and stock history for the item."
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

ITEM_ID="$1"
D1="$2"
D2="$3"
QUERY=""

if [ -n "$D1" ]; then
  QUERY="d1=${D1}"
fi
if [ -n "$D2" ]; then
  if [ -n "$QUERY" ]; then
    QUERY="${QUERY}&"
  fi
  QUERY="${QUERY}d2=${D2}"
fi

URL="https://mpstats.io/api/ym/get/item/${ITEM_ID}/sales"
if [ -n "$QUERY" ]; then
  URL="${URL}?${QUERY}"
fi

curl -s --location --request GET \
  "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
