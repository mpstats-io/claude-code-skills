#!/bin/bash
# ym-compare.sh — Compare two periods for category/brand/seller
# Usage: ./ym-compare.sh <scope> <value> <d11> <d12> <d21> <d22> [d1] [d2] [fbs] [limit]

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <scope> <value> <d11> <d12> <d21> <d22> [d1] [d2] [fbs] [limit]"
  echo "  scope — category | brand | seller"
  echo "  value — category path, brand name, seller name"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

SCOPE="$1"
VALUE="$2"
D11="$3"
D12="$4"
D21="$5"
D22="$6"
D1="${7:-$D11}"
D2="${8:-$D22}"
FBS="${9:-0}"
LIMIT="${10:-100}"

BASE_URL="https://mpstats.io/api/ym/get"
QUERY="d1=${D1}&d2=${D2}&fbs=${FBS}"

case "$SCOPE" in
  category)
    ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$VALUE" 2>/dev/null || node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$VALUE" 2>/dev/null || printf '%s' "$VALUE" | sed 's/ /%20/g; s|/|%2F|g')
    URL="$BASE_URL/category/compare?${QUERY}&path=${ENCODED}"
    ;;
  brand)
    ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$VALUE" 2>/dev/null || node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$VALUE" 2>/dev/null || printf '%s' "$VALUE" | sed 's/ /%20/g')
    URL="$BASE_URL/brand/compare?${QUERY}&path=${ENCODED}"
    ;;
  seller)
    ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$VALUE" 2>/dev/null || node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$VALUE" 2>/dev/null || printf '%s' "$VALUE" | sed 's/ /%20/g')
    URL="$BASE_URL/seller/compare?${QUERY}&path=${ENCODED}"
    ;;
  *)
    echo "scope must be one of: category | brand | seller" >&2
    exit 1
    ;;
esac

curl -s --location --request POST "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json' \
  --data "{\"startRow\":0,\"endRow\":${LIMIT},\"filterModel\":{},\"sortModel\":[],\"d11\":\"${D11}\",\"d12\":\"${D12}\",\"d21\":\"${D21}\",\"d22\":\"${D22}\"}"
