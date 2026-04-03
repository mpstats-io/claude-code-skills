#!/bin/bash
# ozon-sku.sh — Ozon SKU-level endpoints
# Usage: ./ozon-sku.sh <sku> [report] [d1] [d2] [fbs] [d]

if [ -z "$1" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <sku> [report] [d1] [d2] [fbs] [d]"
  echo "  sku    — Ozon product ID (numeric), e.g. 1252420260"
  echo "  report — sales (default), by_day, balance, categories, keywords, full, by_period, search_stats, stores, comments"
  echo "  d1     — start date YYYY-MM-DD (for sales/categories/keywords/by_period/search_stats)"
  echo "  d2     — end date YYYY-MM-DD (for sales/categories/keywords/by_period/search_stats)"
  echo "  fbs    — include FBS: 0 or 1 (for sales/balance)"
  echo "  d      — point date YYYY-MM-DD (required for by_day/balance)"
  echo ""
  echo "Examples:"
  echo "  $0 1252420260 sales 2023-12-12 2023-12-25"
  echo "  $0 1252420260 by_day '' '' '' 2023-12-26"
  echo "  $0 1252420260 balance '' '' 1 2023-12-26"
  echo "  $0 1252420260 categories 2023-12-19 2023-12-26"
  echo "  $0 1252420260 full"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

SKU="$1"
REPORT="${2:-sales}"
D1="$3"
D2="$4"
FBS="$5"
POINT_DATE="$6"

BASE_URL="https://mpstats.io/api/analytics/v1/oz/items/${SKU}"
URL=""
QUERY=""

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
  sales|categories|keywords|by_period|search_stats)
    URL="${BASE_URL}/${REPORT}"
    QUERY=$(append_query "$QUERY" "d1=${D1}")
    QUERY=$(append_query "$QUERY" "d2=${D2}")
    if [ "$REPORT" = "sales" ]; then
      QUERY=$(append_query "$QUERY" "fbs=${FBS}")
    fi
    ;;
  by_day|balance)
    URL="${BASE_URL}/${REPORT}"
    QUERY=$(append_query "$QUERY" "date=${POINT_DATE}")
    if [ "$REPORT" = "balance" ]; then
      QUERY=$(append_query "$QUERY" "fbs=${FBS}")
    fi
    ;;
  full|stores|comments)
    URL="${BASE_URL}/${REPORT}"
    ;;
  *)
    echo "Unsupported report: $REPORT" >&2
    exit 1
    ;;
esac

if [ -n "$QUERY" ]; then
  URL="${URL}?${QUERY}"
fi

curl -s --location --request GET "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
