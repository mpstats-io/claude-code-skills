#!/bin/bash
# ym-seller.sh — Get products or analytics for a Yandex Market seller
# Usage: ./ym-seller.sh <seller_name> [report] [d1] [d2] [limit]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <seller_name> [report] [d1] [d2] [limit]"
  echo "  seller_name — YM seller name (path), e.g. 'Эльдорадо'"
  echo "  report      — products (default), categories, brands, by_date, price_segmentation"
  echo "  d1          — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2          — end date YYYY-MM-DD (default: today)"
  echo "  limit       — max results for products report, 1-5000 (default: 100)"
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

SELLER_NAME="$1"
REPORT="${2:-products}"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"
LIMIT="${5:-100}"

ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$SELLER_NAME'))" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent('$SELLER_NAME'))" 2>/dev/null || \
  printf '%s' "$SELLER_NAME" | sed 's/ /%20/g')

QUERY="d1=${D1}&d2=${D2}&path=${ENCODED_PATH}"

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "https://mpstats.io/api/ym/get/seller?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  curl -s --location --request GET \
    "https://mpstats.io/api/ym/get/seller/${REPORT}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
fi
