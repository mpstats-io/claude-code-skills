#!/bin/bash
# ym-category.sh — Get products or stats for a Yandex Market category
# Usage: ./ym-category.sh <category_path> [report] [d1] [d2] [limit] [fbs]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <category_path> [report] [d1] [d2] [limit] [fbs]"
  echo "  category_path — YM category path, e.g. 'Электроника/Смартфоны'"
  echo "  report        — products (default), categories, brands, sellers, by_date, price_segmentation"
  echo "  d1            — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2            — end date YYYY-MM-DD (default: today)"
  echo "  limit         — max results for products report, 1-5000 (default: 100)"
  echo "  fbs           — include FBS: 0 or 1 (default: 0)"
  echo ""
  echo "  Note: YM does not have a rubricator endpoint. Use known category paths."
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

ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$CATEGORY_PATH'))" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent('$CATEGORY_PATH'))" 2>/dev/null || \
  printf '%s' "$CATEGORY_PATH" | sed 's/ /%20/g; s|/|%2F|g')

if [ "$REPORT" = "products" ]; then
  curl -s --location --request POST \
    "https://mpstats.io/api/ym/get/category?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
else
  # categories sub-report uses different endpoint name
  ENDPOINT="$REPORT"
  if [ "$REPORT" = "subcategories" ]; then
    ENDPOINT="categories"
  fi
  curl -s --location --request GET \
    "https://mpstats.io/api/ym/get/category/${ENDPOINT}?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
fi
