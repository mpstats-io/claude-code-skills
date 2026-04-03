#!/bin/bash
# wb-category.sh — Get products in a Wildberries category
# Usage: ./wb-category.sh <category_path> [d1] [d2] [limit] [fbs]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <category_path> [d1] [d2] [limit] [fbs]"
  echo "  category_path — e.g. 'Электроника/Смартфоны и телефоны/Планшеты'"
  echo "  d1            — start date YYYY-MM-DD (default: 30 days ago)"
  echo "  d2            — end date YYYY-MM-DD (default: today)"
  echo "  limit         — max results, 1-5000 (default: 100)"
  echo "  fbs           — include FBS: 0 or 1 (default: 0)"
  echo ""
  echo "Response: {total, data:[{id,name,brand,seller,sales,revenue,final_price,...}]}"
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
D1="${2:-$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d)}"
D2="${3:-$(date +%Y-%m-%d)}"
LIMIT="${4:-100}"
FBS="${5:-0}"

ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$CATEGORY_PATH'))" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent('$CATEGORY_PATH'))" 2>/dev/null || \
  printf '%s' "$CATEGORY_PATH" | sed 's/ /%20/g; s|/|%2F|g')

curl -s --location --request POST \
  "https://mpstats.io/api/analytics/v1/wb/category/items?d1=${D1}&d2=${D2}&path=${ENCODED_PATH}&fbs=${FBS}" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json' \
  --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}"
