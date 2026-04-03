# MPSTATS Coverage Status

This file tracks script coverage against endpoints documented in `references/*.md`.

## Short answer

Yes: all documented methods are now invocable via scripts.

## How coverage is implemented

1. Dedicated wrappers for major families:
- Account: `scripts/account/account-limits.sh`
- Wildberries: `scripts/wb/*.sh` including subject/similar/analytics/compare/warehouses (promotion-analysis removed in v2 API)
- Ozon: `scripts/ozon/*.sh` including compare
- Yandex Market: `scripts/ym/*.sh` including compare

2. Universal fallback for any endpoint:
- `scripts/request.sh <METHOD> <path> [query] [body_json]`
- This guarantees access even when a dedicated wrapper is not the preferred route.

## Notes

- References remain the source-of-truth for exact endpoint contracts.
- Dedicated wrappers are optimized for common analytical flows.
- Use `scripts/README.md` for "what script to run and when".
- WB `subject/geography` is available in `scripts/wb/wb-subject.sh` via the new analytics/v1 API.
- WB `wb-promotion-analysis.sh` is deprecated — the endpoint was removed from the analytics/v1 API.
- All WB scripts now use the `https://mpstats.io/api/analytics/v1/wb/` base URL.
- Many WB endpoints changed from GET to POST in the v2 migration.
