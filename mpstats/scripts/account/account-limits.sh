#!/bin/bash
# account-limits.sh — Check MPSTATS API usage and remaining quota
# Usage: ./account-limits.sh

if [ "$1" = "--help" ]; then
  echo "Usage: $0"
  echo "  Checks remaining API call quota for your MPSTATS account."
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

curl -s --location --request GET 'https://mpstats.io/api/user/report_api_limit' \
  --header "X-Mpstats-TOKEN: $TOKEN" \
  --header 'Content-Type: application/json'
