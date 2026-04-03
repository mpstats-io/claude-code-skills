#!/bin/bash
# wb-promotion-analysis.sh — DEPRECATED: Promotion analysis endpoint removed in analytics/v1 API
# This script is kept for backward compatibility but the endpoint no longer exists.
# Usage: ./wb-promotion-analysis.sh <subject_id> [fbs]

echo '{"error":"DEPRECATED: The promotion-analysis endpoint has been removed from the new analytics/v1 API. This script is no longer functional."}' >&2
exit 1
