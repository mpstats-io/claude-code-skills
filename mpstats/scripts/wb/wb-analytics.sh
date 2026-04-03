#!/bin/bash
# wb-analytics.sh — AI forecasts and seasonality for category/subject
# Usage: ./wb-analytics.sh <entity> <report> <path_or_subject_id> [period]

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ "$1" = "--help" ]; then
  echo "Usage: $0 <entity> <report> <path_or_subject_id> [period]"
  echo "  entity              — category | subject"
  echo "  report              — forecast/daily | forecast/trend | season_effects/annual | season_effects/weekly"
  echo "  path_or_subject_id  — category path or subject id"
  echo "  period              — optional: month12|month3 (trend), day|week|month (annual)"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

load_config
TOKEN="${MPSTATS_TOKEN}"

ENTITY="$1"
REPORT="$2"
PATH_VALUE="$3"
PERIOD="$4"

if [ "$ENTITY" != "category" ] && [ "$ENTITY" != "subject" ]; then
  echo "entity must be category or subject" >&2
  exit 1
fi

ENCODED_PATH=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$PATH_VALUE" 2>/dev/null || \
  node -e "process.stdout.write(encodeURIComponent(process.argv[1]))" "$PATH_VALUE" 2>/dev/null || \
  printf '%s' "$PATH_VALUE" | sed 's/ /%20/g; s|/|%2F|g')

URL="https://mpstats.io/api/analytics/v1/wb/${ENTITY}/${REPORT}?path=${ENCODED_PATH}"
if [ -n "$PERIOD" ]; then
  URL="${URL}&period=${PERIOD}"
fi

curl -s --location --request GET "$URL" \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
