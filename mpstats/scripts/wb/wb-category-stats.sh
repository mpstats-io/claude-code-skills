#!/bin/bash
# wb-category-stats.sh — Get subcategory/brand/seller breakdown or trends for a WB category
# Usage: ./wb-category-stats.sh <category_path> <report> [d1] [d2] [fbs]

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <category_path> <report> [d1] [d2] [fbs]"
  echo "  category_path — e.g. 'Электроника/Смартфоны и телефоны'"
  echo "  report        — one of: subcategories, brands, sellers, trends, by_date, price_segmentation"
  echo "  d1            — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2            — end date YYYY-MM-DD (default: today)"
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
REPORT="$2"
D1="${3:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${4:-$(date +%Y-%m-%d)}"
FBS="${5:-0}"

# Map old report name to new API path
case "$REPORT" in
  subcategories) API_PATH="categories" ;;
  *) API_PATH="$REPORT" ;;
esac

ENCODED_PATH=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$CATEGORY_PATH" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$CATEGORY_PATH" 2>/dev/null || \
  printf '%s' "$CATEGORY_PATH" | sed 's/ /%20/g; s|/|%2F|g')

curl -s --location --request POST \
  "https://mpstats.io/api/analytics/v1/wb/category/${API_PATH}?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
