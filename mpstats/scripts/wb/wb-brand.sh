#!/bin/bash
# wb-brand.sh — Get products or analytics for a Wildberries brand
# Usage: ./wb-brand.sh <brand> [report] [d1] [d2] [limit] [fbs]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <brand> [report] [d1] [d2] [limit] [fbs]"
  echo "  brand  — brand name, e.g. 'Nike' (sent as API param: path)"
  echo "  report — products (default), categories, sellers, trends, by_date, price_segmentation, subjects, keywords"
  echo "  d1     — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2     — end date YYYY-MM-DD (default: today)"
  echo "  limit  — max results for products report, 1-5000 (default: 100)"
  echo "  fbs    — include FBS: 0 or 1 (default: 0)"
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

BRAND="$1"
REPORT="${2:-products}"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"
LIMIT="${5:-100}"
FBS="${6:-0}"

ENCODED_BRAND=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$BRAND'))" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent('$BRAND'))" 2>/dev/null || \
  printf '%s' "$BRAND" | sed 's/ /%20/g')

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "https://mpstats.io/api/analytics/v1/wb/brand/items?d1=${D1}&d2=${D2}&path=${ENCODED_BRAND}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  curl -s --location --request POST \
    "https://mpstats.io/api/analytics/v1/wb/brand/${REPORT}?d1=${D1}&d2=${D2}&path=${ENCODED_BRAND}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
fi
