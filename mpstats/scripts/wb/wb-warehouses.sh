#!/bin/bash
# wb-warehouses.sh — Warehouse breakdown for brand or seller
# Usage: ./wb-warehouses.sh <kind> <id_or_name> [d1] [d2]

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <kind> <id_or_name> [d1] [d2]"
  echo "  kind       — brand | seller"
  echo "  id_or_name — brand name (for brand) or supplier_id (for seller)"
  echo "  d1         — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2         — end date YYYY-MM-DD (default: today)"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

KIND="$1"
VALUE="$2"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"

if [ "$KIND" = "brand" ]; then
  ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$VALUE" 2>/dev/null || \
    node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$VALUE" 2>/dev/null || \
    printf '%s' "$VALUE" | sed 's/ /%20/g')
  URL="https://mpstats.io/api/analytics/v1/wb/brand/warehouses?d1=${D1}&d2=${D2}&path=${ENCODED}"
elif [ "$KIND" = "seller" ]; then
  URL="https://mpstats.io/api/analytics/v1/wb/seller/warehouses?d1=${D1}&d2=${D2}&path=${VALUE}"
else
  echo "kind must be brand or seller" >&2
  exit 1
fi

curl -s --location --request POST "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
