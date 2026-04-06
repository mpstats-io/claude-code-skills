#!/bin/bash
# ozon-category.sh — Get products or stats for an Ozon category
# Usage: ./ozon-category.sh <category_path> [report] [d1] [d2] [limit] [fbs]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <category_path> [report] [d1] [d2] [limit] [fbs]"
  echo "  category_path — e.g. 'Автотовары/Автоаксессуары и принадлежности'"
  echo "  report        — products (default), subcategories, brands, sellers, by_date, price_segmentation, trends, keywords, niches"
  echo "  d1            — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2            — end date YYYY-MM-DD (default: today)"
  echo "  limit         — max results for products report, 1-5000 (default: 100)"
  echo "  fbs           — include FBS: 0 or 1 (default: 0)"
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

CATEGORY_PATH="$1"
REPORT="${2:-products}"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"
LIMIT="${5:-100}"
FBS="${6:-0}"

ENCODED_PATH=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$CATEGORY_PATH" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$CATEGORY_PATH" 2>/dev/null || \
  printf '%s' "$CATEGORY_PATH" | sed 's/ /%20/g; s|/|%2F|g')

BASE_URL="https://mpstats.io/api/analytics/v1/oz/category"

# Map old report names to new endpoint paths
case "$REPORT" in
  products)      ENDPOINT="items" ;;
  subcategories) ENDPOINT="categories" ;;
  *)             ENDPOINT="$REPORT" ;;
esac

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "${BASE_URL}/${ENDPOINT}?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  curl -s --location --request POST \
    "${BASE_URL}/${ENDPOINT}?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data '{}'
fi
