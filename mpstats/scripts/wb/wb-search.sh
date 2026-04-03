#!/bin/bash
# wb-search.sh — Get WB niche/subject list for research (subjects selection)
# Usage: ./wb-search.sh [date]

if [ "$1" = "--help" ]; then
  echo "Usage: $0 [date]"
  echo "  date — single date YYYY-MM-DD (default: today)"
  echo ""
  echo "  Returns list of WB subjects/niches available for analysis."
  echo "  Use subject IDs from this list with wb-subject.sh"
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

DATE="${1:-$(date +%Y-%m-%d)}"

curl -s --location --request POST \
  "https://mpstats.io/api/analytics/v1/wb/subject/list?date=${DATE}" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
