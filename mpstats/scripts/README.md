# MPSTATS Scripts

Scripts are grouped by domain:

- `scripts/account/` — account and quota checks
- `scripts/wb/` — Wildberries endpoints
- `scripts/ozon/` — Ozon endpoints
- `scripts/ym/` — Yandex Market endpoints
- `scripts/request.sh` — universal raw request for any MPSTATS API method

## Account

| Script | Purpose | When to use |
|---|---|---|
| `account/account-limits.sh` | API quota usage and remaining calls | Before heavy runs and when troubleshooting 429 |

## Wildberries

| Script | Purpose | When to use |
|---|---|---|
| `wb/wb-categories-list.sh` | Full WB rubricator | Need category tree / path discovery |
| `wb/wb-category.sh` | Category product list (`POST category/items`) | Product-level analysis in a WB category |
| `wb/wb-category-stats.sh` | Category aggregate reports (`subcategories`, `brands`, `sellers`, `trends`, `by_date`, `price_segmentation`) | Market structure, trend, and segmentation views |
| `wb/wb-brand.sh` | Brand products and aggregate reports | Brand-level analytics |
| `wb/wb-seller.sh` | Seller products and aggregate reports | Seller-level analytics |
| `wb/wb-sku.sh` | SKU-level reports via `items/{id}/{report}` | Item info/sales/stocks/keywords/comments/FAQ |
| `wb/wb-search.sh` | Subjects/niches list (`POST subject/list`) | Niche discovery and subject lookup |
| `wb/wb-subject.sh` | Subject-level methods (`subject/*`) | Subject analytics by subject id |
| `wb/wb-similar.sh` | Similar families (`identical`, `identical_wb`, `similar`, `in_similar`) | Similar product analysis for SKU/url |
| `wb/wb-analytics.sh` | Forecast and season effects | AI forecasts and seasonality |
| `wb/wb-promotion-analysis.sh` | DEPRECATED — endpoint removed in v2 API | N/A |
| `wb/wb-warehouses.sh` | Warehouse breakdown (`brand/warehouses`, `seller/warehouses`) | Stock distribution by warehouse |
| `wb/wb-compare.sh` | Period compare endpoints for category/brand/seller/subject | Two-period performance comparison |

## Ozon

| Script | Purpose | When to use |
|---|---|---|
| `ozon/ozon-categories-list.sh` | Full Ozon rubricator | Need Ozon category tree |
| `ozon/ozon-category.sh` | Category products and aggregate reports | Ozon category analytics |
| `ozon/ozon-brand.sh` | Brand products and aggregate reports (`categories`, `sellers`, `by_date`, `price_segmentation`) | Ozon brand analytics |
| `ozon/ozon-seller.sh` | Seller products and aggregate reports (`categories`, `brands`, `by_date`, `price_segmentation`) | Ozon seller analytics by seller id or seller name |
| `ozon/ozon-sku.sh` | SKU-level reports (`sales`, `balance_by_day`, `balance_by_region`, `by_category`, `by_keywords`) | Ozon item-level history, stock, category/keyword positions |
| `ozon/ozon-compare.sh` | Ozon compare endpoints for brand/seller/category | Two-period comparison |

## Yandex Market

| Script | Purpose | When to use |
|---|---|---|
| `ym/ym-category.sh` | Category products and aggregate reports | YM category analytics |
| `ym/ym-brand.sh` | Brand products and aggregate reports | YM brand analytics |
| `ym/ym-seller.sh` | Seller products and aggregate reports | YM seller analytics |
| `ym/ym-sku.sh` | Item sales history with optional date range | YM item-level history |
| `ym/ym-compare.sh` | YM compare endpoints for brand/seller/category | Two-period comparison |

## Universal

| Script | Purpose | When to use |
|---|---|---|
| `request.sh` | Raw API call to any path with GET/POST | Endpoint not covered by dedicated script or quick prototyping |
