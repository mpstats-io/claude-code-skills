# Wildberries — Brands & Sellers Analytics

All endpoints: `GET` or `POST` to `https://mpstats.io/api/analytics/v1/wb/<path>`

---

## Brands

### POST brand/items
Get products for a brand.

**Query params:**
| Param  | Type   | Required | Description |
|--------|--------|----------|-------------|
| `d1`   | string | yes      | Start date `YYYY-MM-DD` |
| `d2`   | string | yes      | End date `YYYY-MM-DD` |
| `path` | string | yes      | Brand name (URL-encoded) |
| `fbs`  | int    | no       | Include FBS (1 = yes) |

**Body:** See `pagination-filter-sort.md`

**Response:** Same product fields as `category/items` (see `wb-categories.md`)

---

### GET brand/list
Search brands by name.

**Query params:** brand search query

---

### GET brand/info
Get brand info.

**Query params:** brand identifier

---

### POST brand/categories
Get category breakdown for a brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST brand/sellers
Get sellers for a brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST brand/trends
Get trend data for a brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST brand/by_date
Get brand metrics aggregated by day.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST brand/warehouses
Get stock breakdown by warehouse for a brand.

**Query params:** `d1`, `d2`, `path`

---

### POST brand/price_segmentation
Get price segmentation for a brand.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST brand/compare
Compare two periods for a brand.

**Query params:** `d1`, `d2`, `path`, `fbs`
**Body:** pagination/filter/sort model

---

### POST brand/subjects
Get subjects (product types/items) for a brand.

**Query params:** `d1`, `d2`, `path`

---

### POST brand/keywords
Get keywords for a brand.

**Query params:** `d1`, `d2`, `path`

---

### POST brand/feedback/comments
Get feedback comments for a brand.

### GET brand/feedback/comments/stats
Get feedback comment stats for a brand.

### GET brand/feedback/comments/graph
Get feedback comments graph for a brand.

---

## Sellers

### POST seller/items
Get products for a seller.

**Query params:**
| Param       | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `d1`        | string | yes      | Start date |
| `d2`        | string | yes      | End date |
| `path` | int  | yes      | Seller (supplier) ID |
| `fbs`       | int    | no       | Include FBS |

**Body:** See `pagination-filter-sort.md`

**Response:** Same product fields as `category/items`

---

### GET seller/list
Search sellers.

### GET seller/{id}
Get seller info by ID.

---

### POST seller/categories
Get category breakdown for a seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST seller/brands
Get brands for a seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST seller/trends
Get trend data for a seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST seller/by_date
Get seller metrics by day.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST seller/warehouses
Get stock breakdown by warehouse for a seller.

**Query params:** `d1`, `d2`, `path`

---

### POST seller/price_segmentation
Get price segmentation for a seller.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

### POST seller/compare
Compare two periods for a seller.

**Query params:** `d1`, `d2`, `path`, `fbs`
**Body:** pagination/filter/sort model

---

### POST seller/subjects
Get subjects (product types) for a seller.

**Query params:** `d1`, `d2`, `path`

---

### POST seller/keywords
Get keywords for a seller.

**Query params:** `d1`, `d2`, `path`

---

Use script wrappers:
- `scripts/wb/wb-brand.sh`
- `scripts/wb/wb-seller.sh`
- `scripts/wb/wb-compare.sh`
- `scripts/wb/wb-warehouses.sh`
- `scripts/request.sh` (for any method not covered by dedicated wrappers)
