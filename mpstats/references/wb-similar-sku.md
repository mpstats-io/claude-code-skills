# Wildberries — Similar Products & SKU Analytics

All endpoints: `GET` or `POST` to `https://mpstats.io/api/analytics/v1/wb/<path>`

---

## Similar Products (AI-based)

### POST identical/items
Get AI-similar products for a given product.

**Query params:** `d1`, `d2`, SKU identifier, `fbs`
**Body:** pagination/filter/sort model

### POST identical/categories
Get categories for AI-similar products.

### POST identical/brands
Get brands for AI-similar products.

### POST identical/sellers
Get sellers for AI-similar products.

### POST identical/price_segmentation
Get price segmentation for AI-similar products.

### POST identical/trends
Get trends for AI-similar products.

### POST identical/by_date
Get by-date data for AI-similar products.

### POST identical/keywords
Get keywords for AI-similar products.

### POST identical/warehouses
Get warehouse data for AI-similar products.

### POST identical/compare
Compare periods for AI-similar products.

---

## Similar Products (WB AI-based)

### POST identical_wb/items
Get WB AI-similar products for a given product.

**Query params:** `d1`, `d2`, SKU identifier, `fbs`
**Body:** pagination/filter/sort model

### POST identical_wb/categories
Get categories for WB AI-similar products.

### POST identical_wb/brands
Get brands for WB AI-similar products.

### POST identical_wb/sellers
Get sellers for WB AI-similar products.

### POST identical_wb/price_segmentation
Get price segmentation for WB AI-similar products.

### POST identical_wb/trends
Get trends for WB AI-similar products.

### POST identical_wb/by_date
Get by-date data for WB AI-similar products.

### POST identical_wb/keywords
Get keywords for WB AI-similar products.

### POST identical_wb/warehouses
Get warehouse data for WB AI-similar products.

### POST identical_wb/compare
Compare periods for WB AI-similar products.

---

## Similar Products (WB-based)

### POST similar/items
Get WB-similar products for a given product.

**Query params:** `d1`, `d2`, SKU identifier, `fbs`
**Body:** pagination/filter/sort model

### POST similar/categories
Get categories for WB-similar products.

### POST similar/brands
Get brands for WB-similar products.

### POST similar/sellers
Get sellers for WB-similar products.

### POST similar/price_segmentation
Get price segmentation for WB-similar products.

### POST similar/trends
Get trends for WB-similar products.

### POST similar/by_date
Get by-date data for WB-similar products.

### POST similar/keywords
Get keywords for WB-similar products.

### POST similar/warehouses
Get warehouse data for WB-similar products.

### POST similar/compare
Compare periods for WB-similar products.

---

## In Similar Products (reverse)

### POST in_similar/items
Get products where the given product appears as "similar".

**Query params:** `d1`, `d2`, SKU identifier, `fbs`
**Body:** pagination/filter/sort model

### POST in_similar/categories
Get categories where the given product appears as similar.

### POST in_similar/brands
Get brands where the given product appears as similar.

### POST in_similar/sellers
Get sellers where the given product appears as similar.

### POST in_similar/price_segmentation
Get price segmentation for in-similar products.

### POST in_similar/trends
Get trends for in-similar products.

### POST in_similar/by_date
Get by-date data for in-similar products.

### POST in_similar/keywords
Get keywords for in-similar products.

### POST in_similar/warehouses
Get warehouse data for in-similar products.

### POST in_similar/compare
Compare periods for in-similar products.

---

## SKU-Level Analytics

All endpoints use `{id}` as the WB product ID (numeric).

### GET items/{id}
Get basic item info for a SKU.

---

### GET items/{id}/full
Get detailed info and period stats for a SKU (replaces old `sales` endpoint).

---

### GET items/{id}/by_period
Get daily stats for a SKU (sales, balance data by day).

---

### GET items/{id}/balance/stores
Get current stock breakdown by region/warehouse for a SKU.

---

### GET items/{id}/balance/sizes
Get current stock breakdown by size for a SKU.

---

### GET items/{id}/balance/stores_and_sizes
Get stock breakdown by stores and sizes combined.

---

### GET items/{id}/balance/colors
Get stock breakdown by colors.

---

### GET items/{id}/sales/stores
Get sales breakdown by region/store for a SKU.

---

### GET items/{id}/sales/sizes
Get sales breakdown by size for a SKU.

---

### GET items/{id}/sales/heatmap
Get sales heatmap for a SKU.

---

### GET items/{id}/stores
Get stores with sales and balance data.

---

### GET items/{id}/search_stats
Get search position stats for a SKU.

---

## SKU Keyword Positions

### POST items/{id}/keywords
Get search queries the SKU appears in and its position for each.

**Response item fields:**
| Field | Description |
|-------|-------------|
| `keyword` | Search query |
| `position` | Position in search results |
| `date` | Date |

---

### POST items/{id}/keywords/hourly
Get hourly keyword position data for a SKU.

---

## SKU Reviews

### GET items/{id}/comments
Get review history for a SKU.

**Response item fields:**
| Field | Description |
|-------|-------------|
| `date` | Review date |
| `text` | Review text |
| `rating` | Rating (1–5) |
| `valuation` | Valuation score |

---

## SKU FAQ

### GET items/{id}/faq
Get FAQ for a SKU.

---

## SKU Photos History

### GET items/{id}/photos_history
Get product photo change history for a SKU.

---

## SKU Recommended Products

Recommended items endpoints are available under `items/{id}/recommended/`.

---

Use script wrappers:
- `scripts/wb/wb-sku.sh`
- `scripts/wb/wb-similar.sh`
- `scripts/request.sh` (for any method not covered by dedicated wrappers)
