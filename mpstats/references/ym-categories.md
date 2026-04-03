# Yandex Market — Categories, Brands, Sellers & SKU Analytics

All endpoints: `GET` or `POST` to `https://mpstats.io/api/<path>`

Note: Yandex Market API does not have a separate rubricator endpoint (category tree). Start from known category paths.

---

## Category: Products

### POST ym/get/category
Get products in a Yandex Market category.

**Query params:**
| Param  | Type   | Required | Description |
|--------|--------|----------|-------------|
| `d1`   | string | yes      | Start date `YYYY-MM-DD` |
| `d2`   | string | yes      | End date `YYYY-MM-DD` |
| `path` | string | yes      | URL-encoded category path |
| `fbs`  | int    | no       | Include FBS (1 = yes) |

**Body:** See `pagination-filter-sort.md`

---

## Category: Subcategories

### GET ym/get/category/categories
Get subcategory breakdown for a YM category.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

## Category: Sellers

### GET ym/get/category/sellers
Get seller breakdown for a YM category.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

## Category: Brands

### GET ym/get/category/brands
Get brand breakdown for a YM category.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

## Category: By Date

### GET ym/get/category/by_date
Get YM category metrics by day.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

## Category: Price Segmentation

### GET ym/get/category/price_segmentation
Get price segment breakdown for a YM category.

**Query params:** `d1`, `d2`, `path`, `fbs`

---

## Category: Period Comparison

### POST ym/get/category/compare
Compare two periods for a YM category.

**Query params:** `d1`, `d2`, `path`, `fbs`
**Body:** pagination/filter/sort model

---

## Brands

### POST ym/get/brand
Get products for a YM brand.

**Query params:** `d1`, `d2`, `path`
**Body:** pagination/filter/sort model

### GET ym/get/brand/categories
Get categories for a YM brand.

### GET ym/get/brand/sellers
Get sellers for a YM brand.

### GET ym/get/brand/by_date
Get brand metrics by day.

### GET ym/get/brand/price_segmentation
Get price segmentation for a YM brand.

### POST ym/get/brand/compare
Compare two periods for a YM brand.

---

## Sellers

### POST ym/get/seller
Get products for a YM seller.

**Query params:** `d1`, `d2`, `path`
**Body:** pagination/filter/sort model

### GET ym/get/seller/categories
Get categories for a YM seller.

### GET ym/get/seller/brands
Get brands for a YM seller.

### GET ym/get/seller/by_date
Get seller metrics by day.

### GET ym/get/seller/price_segmentation
Get price segmentation for a YM seller.

### POST ym/get/seller/compare
Compare two periods for a YM seller.

---

## SKU-Level Analytics

### GET ym/get/item/{id}/sales
Get sales and stock history for a Yandex Market item.

---

Use script wrappers:
- `scripts/ym/ym-category.sh`
- `scripts/ym/ym-brand.sh`
- `scripts/ym/ym-seller.sh`
- `scripts/ym/ym-sku.sh`
- `scripts/ym/ym-compare.sh`
- `scripts/request.sh` (for any method not covered by dedicated wrappers)
