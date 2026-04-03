#!/bin/bash
# wb-similar.sh — Similar/identical/in_similar families for SKU or URL
# Usage: ./wb-similar.sh <family> <path_value> [report] [d1] [d2] [limit] [fbs]

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <family> <path_value> [report] [d1] [d2] [limit] [fbs]"
  echo "  family     — identical | identical_wb | similar | in_similar"
  echo "  path_value — SKU or product URL"
  echo "  report     — products (default), categories, brands, sellers, price_segmentation, trends, by_date, keywords, warehouses, compare"
  echo "  d1         — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2         — end date YYYY-MM-DD (default: today)"
  echo "  limit      — max rows for products report (POST), 1-5000 (default: 100)"
  echo "  fbs        — include FBS: 0 or 1 (default: 0)"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

FAMILY="$1"
PATH_VALUE="$2"
REPORT="${3:-products}"
D1="${4:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${5:-$(date +%Y-%m-%d)}"
LIMIT="${6:-100}"
FBS="${7:-0}"

if [ "$FAMILY" != "identical" ] && [ "$FAMILY" != "identical_wb" ] && [ "$FAMILY" != "similar" ] && [ "$FAMILY" != "in_similar" ]; then
  echo "family must be one of: identical | identical_wb | similar | in_similar" >&2
  exit 1
fi

ENCODED_PATH=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$PATH_VALUE" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$PATH_VALUE" 2>/dev/null || \
  printf '%s' "$PATH_VALUE" | sed 's/ /%20/g; s|/|%2F|g')

BASE_URL="https://mpstats.io/api/analytics/v1/wb/${FAMILY}"
QUERY="d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}"

# Map report to API path
case "$REPORT" in
  products) API_SUFFIX="items" ;;
  *) API_SUFFIX="$REPORT" ;;
esac

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "$BASE_URL/${API_SUFFIX}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  curl -s --location --request POST \
    "$BASE_URL/${API_SUFFIX}?${QUERY}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
fi
