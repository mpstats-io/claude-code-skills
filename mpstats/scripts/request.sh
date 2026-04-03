#!/bin/bash
# request.sh — Universal MPSTATS API request runner
# Usage: ./request.sh <METHOD> <path> [query] [body_json]

METHOD="$1"
PATH_REL="$2"
QUERY="$3"
BODY_JSON="$4"

if [ -z "$METHOD" ] || [ -z "$PATH_REL" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <METHOD> <path> [query] [body_json]"
  echo "  METHOD    — GET or POST"
  echo "  path      — API path relative to marketplace base URL"
  echo "              WB paths (auto-routed to analytics/v1/wb/): category/list, brand/items, items/{id}/full, etc."
  echo "              Ozon paths: ozon/... (routed to https://mpstats.io/api/ozon/...)"
  echo "              YM paths: ym/... (routed to https://mpstats.io/api/ym/...)"
  echo "              Legacy WB paths (wb/get/...): auto-redirected to analytics/v1/wb/ equivalents"
  echo "  query     — optional raw query, e.g. d1=2024-01-01&d2=2024-01-31&path=70"
  echo "  body_json — optional JSON body for POST"
  echo ""
  echo "Examples:"
  echo "  $0 GET category/list"
  echo "  $0 POST subject/by_date 'path=70&d1=2024-01-01&d2=2024-01-31&groupBy=day'"
  echo "  $0 POST subject/items 'path=70&d1=2024-01-01&d2=2024-01-31' '{\"startRow\":0,\"endRow\":100,\"filterModel\":{},\"sortModel\":[]}'"
  echo "  $0 GET ozon/get/categories"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

METHOD_UPPER=$(printf '%s' "$METHOD" | tr '[:lower:]' '[:upper:]')

# Route to correct base URL based on path prefix
if [[ "$PATH_REL" == ozon/* ]] || [[ "$PATH_REL" == ym/* ]] || [[ "$PATH_REL" == account/* ]]; then
  # Ozon, YM, and account paths use the old base
  URL="https://mpstats.io/api/${PATH_REL}"
elif [[ "$PATH_REL" == wb/get/* ]]; then
  # Legacy WB paths — strip wb/get/ prefix and route to new base
  STRIPPED="${PATH_REL#wb/get/}"
  URL="https://mpstats.io/api/analytics/v1/wb/${STRIPPED}"
elif [[ "$PATH_REL" == analytics/v1/wb/* ]]; then
  # Already fully qualified analytics path
  URL="https://mpstats.io/api/${PATH_REL}"
else
  # Default: treat as WB analytics/v1 path
  URL="https://mpstats.io/api/analytics/v1/wb/${PATH_REL}"
fi

if [ -n "$QUERY" ]; then
  URL="${URL}?${QUERY}"
fi

if [ "$METHOD_UPPER" = "GET" ]; then
  curl -s --location --request GET "$URL" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json'
elif [ "$METHOD_UPPER" = "POST" ]; then
  PAYLOAD="${BODY_JSON:-{\"startRow\":0,\"endRow\":100,\"filterModel\":{},\"sortModel\":[{\"colId\":\"revenue\",\"sort\":\"desc\"}]}}"
  curl -s --location --request POST "$URL" \
    --header "X-Mpstats-TOKEN: $TOKEN" \
    --header 'Content-Type: application/json' \
    --data "$PAYLOAD"
else
  echo "Unsupported METHOD: $METHOD. Use GET or POST." >&2
  exit 1
fi
