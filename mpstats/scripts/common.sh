#!/bin/bash
# Common functions for MPSTATS scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$SCRIPT_DIR/../config" ]]; then
  SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [[ -d "$SCRIPT_DIR/../../config" ]]; then
  SKILL_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
  SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

CONFIG_FILE="$SKILL_ROOT/config/.env"

load_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    while IFS='=' read -r key value; do
      # Skip comments and empty lines
      [[ "$key" =~ ^[[:space:]]*# ]] && continue
      [[ -z "$key" ]] && continue
      # Strip surrounding whitespace and quotes
      key=$(printf '%s' "$key" | xargs)
      value=$(printf '%s' "$value" | sed 's/^["'\''"]//;s/["'\''"]$//')
      export "$key=$value"
    done < "$CONFIG_FILE"
  fi

  if [[ -z "${MPSTATS_TOKEN:-}" ]]; then
    echo '{"error":"MPSTATS_TOKEN not set. Configure config/.env or export MPSTATS_TOKEN."}' >&2
    echo "See: mpstats/config/README.md" >&2
    exit 1
  fi
}
