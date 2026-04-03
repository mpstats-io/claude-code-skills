#!/bin/bash
# ym-brand.sh — Get products or analytics for a Yandex Market brand
# Usage: ./ym-brand.sh <brand_name> [report] [d1] [d2] [limit]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <brand_name> [report] [d1] [d2] [limit]"
  echo "  brand_name — YM brand name (path), e.g. 'Samsung'"
  echo "  report     — products (default), categories, sellers, by_date, price_segmentation"
  echo "  d1         — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2         — end date YYYY-MM-DD (default: today)"
  echo "  limit      — max results for products report, 1-5000 (default: 100)"
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

BRAND_NAME="$1"
REPORT="${2:-products}"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"
LIMIT="${5:-100}"

ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$BRAND_NAME'))" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent('$BRAND_NAME'))" 2>/dev/null || \
  printf '%s' "$BRAND_NAME" | sed 's/ /%20/g')

QUERY="d1=${D1}&d2=${D2}&path=${ENCODED_PATH}"

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "https://mpstats.io/api/ym/get/brand?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  curl -s --location --request GET \
    "https://mpstats.io/api/ym/get/brand/${REPORT}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
fi
