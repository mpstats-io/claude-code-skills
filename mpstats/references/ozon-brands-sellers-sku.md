# Ozon — Brands, Sellers & SKU Analytics

All endpoints under base URL: `https://mpstats.io/api/analytics/v1/oz/`

---

## Brands

### POST brand/items
Get products for an Ozon brand.

**Query params:**
| Param   | Type   | Required | Description |
|---------|--------|----------|-------------|
| `d1`    | string | yes      | Start date `YYYY-MM-DD` |
| `d2`    | string | yes      | End date `YYYY-MM-DD` |
| `path`  | string | yes      | Brand name (URL-encoded) |
| `fbs`   | int    | no       | Include FBS (1 = yes) |

**Body:** See `pagination-filter-sort.md`

---

### GET brand/list
Get list of brands.

**Query params:** pagination, filter, sort

---

### GET brand/info
Get brand info.

---

### POST brand/categories
Get category breakdown for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/sellers
Get sellers for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/by_date
Get brand metrics by day.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/price_segmentation
Get price segmentation for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/trends
Get trend data for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/keywords
Get keyword data for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/niches
Get niche breakdown for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/geography
Get geography data for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST brand/compare
Compare two periods for an Ozon brand.

**Query params:** `d1`, `d2`, `path`, `fbs`
**Body:** pagination/filter/sort model

---

## Sellers

### POST seller/items
Get products for an Ozon seller.

**Query params:**
| Param       | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `d1`        | string | yes      | Start date |
| `d2`        | string | yes      | End date |
| `path`      | string | yes      | Seller identifier (seller_id or seller name) |
| `fbs`       | int    | no       | Include FBS |

**Body:** See `pagination-filter-sort.md`

---

### POST seller/list
Get list of sellers.

**Query params:** pagination, filter, sort

---

### GET seller/{id}
Get seller info by ID.

---

### POST seller/categories
Get category breakdown for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/brands
Get brands for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/by_date
Get seller metrics by day.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/price_segmentation
Get price segmentation for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/trends
Get trend data for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/keywords
Get keyword data for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/niches
Get niche breakdown for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/geography
Get geography data for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

**Body:** pagination/filter/sort model

---

### POST seller/compare
Compare two periods for an Ozon seller.

**Query params:** `d1`, `d2`, `path`, `fbs`
**Body:** pagination/filter/sort model

---

## SKU-Level Analytics

### GET items/{id}/sales
Get sales and stock history for an Ozon SKU by warehouse.

**Query params:** `d1`, `d2`, `fbs`

---

### GET items/{id}/full
Get detailed product information.

---

### GET items/{id}/by_day
Get intra-day balances/sales snapshots for a specific date.

**Query params:** `date`

---

### GET items/{id}/balance
Get stock by warehouse/region for a specific date.

**Query params:** `date`, optional `fbs`

---

### GET items/{id}/categories
Get category positions history for a date range.

**Query params:** `d1`, `d2`

---

### GET items/{id}/keywords
Get keyword positions history for a date range.

**Query params:** `d1`, `d2`

---

### GET items/{id}/by_period
Get period statistics for a product.

**Query params:** `d1`, `d2`

---

### GET items/{id}/search_stats
Get search position, visibility and traffic stats.

**Query params:** `d1`, `d2`

---

### GET items/{id}/stores
Get store-level data for a product.

---

### GET items/{id}/comments
Get product comments.

---

### GET items/{id}/comments/ai_recommendations
Get AI-generated recommendations based on product comments.

---

### GET items/{id}/versions
Get product version history.

---

### GET items/{id}/versions/{hash}
Get specific product version.

---

### GET items/{id}/versions/compare
Compare two product versions.

---

Use script wrappers:
- `scripts/ozon/ozon-brand.sh`
- `scripts/ozon/ozon-seller.sh`
- `scripts/ozon/ozon-sku.sh`
- `scripts/ozon/ozon-compare.sh`
- `scripts/request.sh` (for any method not covered by dedicated wrappers)
