#!/bin/bash
# wb-sku.sh — Get analytics for a specific Wildberries SKU
# Usage: ./wb-sku.sh <sku> <report> [d1] [d2] [fbs]

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <sku> <report> [d1] [d2] [fbs]"
  echo "  sku     — WB product ID (numeric), e.g. 152490541"
  echo "  report  — one of:"
  echo "             info"
  echo "             full"
  echo "             sales            (alias for full)"
  echo "             by_period"
  echo "             balance_by_day   (alias for by_period)"
  echo "             balance_stores"
  echo "             balance_by_region (alias for balance_stores)"
  echo "             balance_sizes"
  echo "             balance_by_size  (alias for balance_sizes)"
  echo "             balance_stores_and_sizes"
  echo "             balance_colors"
  echo "             sales_stores"
  echo "             sales_by_region  (alias for sales_stores)"
  echo "             sales_sizes"
  echo "             sales_by_size    (alias for sales_sizes)"
  echo "             sales_heatmap"
  echo "             stores"
  echo "             search_stats"
  echo "             keywords"
  echo "             keywords_hourly"
  echo "             comments"
  echo "             faq"
  echo "             photos_history"
  echo "  d1      — start date YYYY-MM-DD (optional)"
  echo "  d2      — end date YYYY-MM-DD (optional)"
  echo "  fbs     — include FBS: 0 or 1 (optional)"
  echo ""
  echo "Examples:"
  echo "  $0 152490541 sales 2026-03-01 2026-03-31"
  echo "  $0 152490541 full"
  echo "  $0 152490541 keywords 2026-03-01 2026-03-31"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

SKU="$1"
REPORT="$2"
D1="$3"
D2="$4"
FBS="$5"

BASE_URL="https://mpstats.io/api/analytics/v1/wb/items/${SKU}"
URL=""
QUERY=""
HTTP_METHOD="GET"

append_query() {
  if [ -n "$2" ]; then
    if [ -z "$1" ]; then
      printf '%s' "$2"
    else
      printf '%s&%s' "$1" "$2"
    fi
  else
    printf '%s' "$1"
  fi
}

case "$REPORT" in
  info)
    URL="$BASE_URL"
    ;;
  full|sales)
    URL="$BASE_URL/full"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  by_period|balance_by_day)
    URL="$BASE_URL/by_period"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  balance_stores|balance_by_region)
    URL="$BASE_URL/balance/stores"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  balance_sizes|balance_by_size)
    URL="$BASE_URL/balance/sizes"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  balance_stores_and_sizes)
    URL="$BASE_URL/balance/stores_and_sizes"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  balance_colors)
    URL="$BASE_URL/balance/colors"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  sales_stores|sales_by_region)
    URL="$BASE_URL/sales/stores"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  sales_sizes|sales_by_size)
    URL="$BASE_URL/sales/sizes"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  sales_heatmap)
    URL="$BASE_URL/sales/heatmap"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  stores)
    URL="$BASE_URL/stores"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  search_stats)
    URL="$BASE_URL/search_stats"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  keywords)
    URL="$BASE_URL/keywords"
    HTTP_METHOD="POST"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  keywords_hourly)
    URL="$BASE_URL/keywords/hourly"
    HTTP_METHOD="POST"
    [ -n "$D1" ] && QUERY=$(append_query "$QUERY" "d1=${D1}")
    [ -n "$D2" ] && QUERY=$(append_query "$QUERY" "d2=${D2}")
    ;;
  comments)
    URL="$BASE_URL/comments"
    ;;
  faq)
    URL="$BASE_URL/faq"
    ;;
  photos_history)
    URL="$BASE_URL/photos_history"
    ;;
  *)
    echo "Unsupported report: $REPORT" >&2
    exit 1
    ;;
esac

if [ -n "$QUERY" ]; then
  URL="${URL}?${QUERY}"
fi

curl -s --location --request "$HTTP_METHOD" "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
