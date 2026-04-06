#!/bin/bash
# ozon-brand.sh — Get products or analytics for an Ozon brand
# Usage: ./ozon-brand.sh <brand_name> [report] [d1] [d2] [limit] [fbs] [newsmode]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <brand_name> [report] [d1] [d2] [limit] [fbs] [newsmode]"
  echo "  brand_name — brand name (maps to query param path), e.g. 'Samsung'"
  echo "  report     — products (default), categories, sellers, by_date, price_segmentation, trends, keywords, niches, geography"
  echo "  d1     — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2     — end date YYYY-MM-DD (default: today)"
  echo "  limit  — max results for products report, 1-5000 (default: 100)"
  echo "  fbs    — include FBS: 0 or 1 (default: 0)"
  echo "  newsmode — only new products for last N days: 7|14|30 (optional)"
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
NEWSMODE="$7"

ENCODED_BRAND=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$BRAND" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$BRAND" 2>/dev/null || \
  printf '%s' "$BRAND" | sed 's/ /%20/g')

BASE_URL="https://mpstats.io/api/analytics/v1/oz/brand"

QUERY="d1=${D1}&d2=${D2}&path=${ENCODED_BRAND}&fbs=${FBS}"
if [ -n "$NEWSMODE" ]; then
  QUERY="${QUERY}&newsmode=${NEWSMODE}"
fi

# Map report name to endpoint
case "$REPORT" in
  products) ENDPOINT="items" ;;
  *)        ENDPOINT="$REPORT" ;;
esac

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "${BASE_URL}/${ENDPOINT}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
elif [ "$REPORT" = "geography" ]; then
  GEO_DATE="${D1:0:7}"
  curl -s --location --request GET \
    "${BASE_URL}/${ENDPOINT}?path=${ENCODED_BRAND}&date=${GEO_DATE}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
else
  curl -s --location --request POST \
    "${BASE_URL}/${ENDPOINT}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data '{}'
fi
