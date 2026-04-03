---
name: mpstats
version: 2.0.0
description: "MPSTATS marketplace analytics API. Use when working with MPSTATS API, Wildberries analytics, Ozon analytics, Yandex Market analytics, marketplace data, product research, sales analytics, competitor analysis, niche research, SKU analysis, seller analytics, brand analytics."
license: MIT
metadata:
  author: esporykhin
  version: "2.0.0"
---

# MPSTATS API

MPSTATS is a Russian marketplace analytics platform providing data on Wildberries, Ozon, and Yandex Market. The API allows integrating marketplace analytics into your own projects: product research, category analysis, seller/brand monitoring, SKU-level sales data.

## When to Apply

- Working with MPSTATS API endpoints
- Fetching marketplace data (WB, Ozon, YM)
- Building analytics tools for Russian marketplaces
- Product/niche/seller/brand research via API
- SKU-level sales, stock, and review data
- Category subcategory breakdown, price segmentation
- Competitor analysis via marketplace data

## Config

Persistent token storage for this skill:

- Preferred: `config/.env` with `MPSTATS_TOKEN=...`
- Override for one command: environment variable `MPSTATS_TOKEN=...`

Initial setup:

```bash
cp config/.env.example config/.env
```

Detailed guide to get token from MPSTATS account and save it:
`config/README.md`

## Token Onboarding (Mandatory)

If token is missing, always offer user exactly 2 options:

1. User sends token in chat, and agent creates `config/.env` itself.
2. User runs one command locally, replacing placeholder token.

Use this wording pattern:

```text
Нужен токен MPSTATS. Выберите удобный вариант:
1) Скиньте токен сюда — я сам создам config/.env и всё подключу.
2) Либо выполните команду (замените YOUR_MPSTATS_TOKEN на свой токен):
   cp config/.env.example config/.env && perl -i -pe 's/^MPSTATS_TOKEN=.*/MPSTATS_TOKEN=YOUR_MPSTATS_TOKEN/' config/.env

Где взять токен: https://mpstats.io/userpanel (в кабинете можно скопировать API token).
Важно: для доступа к API нужна активная подписка MPSTATS.
Тарифы и актуальные акции: https://mpstats.io/tariffs

После этого я сразу продолжу и подключусь к вашему MPSTATS.
```

If user chooses option 1, agent should save token to `config/.env` (persistent for future sessions in this workspace), then continue task.

## Base URL & Auth

```
Wildberries:    https://mpstats.io/api/analytics/v1/wb/
Ozon:           https://mpstats.io/api/analytics/v1/oz/
Yandex Market:  https://mpstats.io/api/ym/
Account:        https://mpstats.io/api/account/
```

**Authentication:** Personal token required for every request.

Header method (preferred):
```
X-Mpstats-TOKEN: <your_token>
```

Query param alternative:
```
?auth-token=<your_token>
```

Token is generated in account settings at https://mpstats.io/userpanel (API token block). Token is reset on password change or manual regeneration.

**Content-Type:** Always send `Content-Type: application/json`

## Response Codes

| Code | Meaning |
|------|---------|
| 200  | Success |
| 202  | Accepted but not yet complete — retry later |
| 401  | Authorization error |
| 429  | Rate limit exceeded — check `message` field and `Retry-After` header (seconds) |
| 500  | Internal server error — check `message` field |

## Quick Reference

References in `references/` are API contracts only (endpoints/params/response semantics).
Do not rely on language-specific code examples from references; for execution use scripts in `scripts/`.

### Presentation & Reporting
See `references/presentation.md` — how to format analytical answers, when to include tables/charts, and how to style HTML/PDF reports in MPSTATS visual language.

### Wildberries API
See `references/wb-categories.md` — category rubricator, category products, subcategories, brands, sellers, trends, by-date, price segmentation, period comparison, subjects, keywords, warehouses, AI forecasts, seasonal effects

See `references/wb-brands-sellers.md` — brand analytics (products, categories, sellers, by-date, warehouses, price segmentation, period comparison, subjects, keywords, feedback), seller analytics (same set)

See `references/wb-similar-sku.md` — similar products (AI, WB AI, WB), in-similar products, SKU-level data (full info, sales, balance, regions, sizes, stores, search stats, keywords, comments, FAQ, photos history)

### Ozon API
See `references/ozon-categories.md` — category rubricator, category products, subcategories, brands, sellers, by-date, price segmentation, period comparison

See `references/ozon-brands-sellers-sku.md` — brand analytics, seller analytics, SKU sales data

### Yandex Market API
See `references/ym-categories.md` — category products, subcategories, sellers, brands, by-date, price segmentation, period comparison, **brand analytics** (products, categories, sellers, by-date, price segmentation, compare), **seller analytics** (same set), **SKU sales history**

### Pagination, Filtering & Sorting
See `references/pagination-filter-sort.md` — common request/response model used by all POST endpoints

### Account API
See `references/account.md` — API limits remaining

### Coverage Status
See `references/coverage.md` — what is already wrapped by scripts and what is still uncovered.

## Result Formatting Policy

When returning analytical results from MPSTATS data:

- Prefer a concise conclusion first, then supporting evidence.
- If the answer contains multiple entities, periods, price buckets, sellers, brands, SKUs, or category slices, include at least one compact table.
- If trend, dynamics, seasonality, price segmentation, period comparison, or distribution are important to the conclusion, include a chart or chart-ready block when the output format supports it.
- Do not dump raw JSON unless the user explicitly asks for it; summarize the signal and use tables for key rows.
- Always interpret the numbers: explain why the metric matters for the business decision, not just what it is.

When generating HTML or PDF reports:

- **MUST** use MPSTATS brand colors (green + white). See `references/presentation.md` for the full palette, CSS variables, and hero gradient.
- Prefer a clean analytics layout: branded green header, metric cards, structured sections, comparison tables, chart blocks, conclusion, and risks/next steps.
- Charts: use MPSTATS green as primary series, contrasting palette for multi-series (see presentation.md).
- Include tables by default and add charts whenever there is a meaningful time series, segmentation, ranking, or comparison.
- Keep reports business-readable: short sections, visible takeaway blocks, and source/methodology notes.

## Scripts

Ready-to-use shell scripts in `scripts/` directory. Call via Bash tool instead of writing code.

Scripts are grouped by marketplace/domain:
- `scripts/account/`
- `scripts/wb/`
- `scripts/ozon/`
- `scripts/ym/`

Script catalog with per-script use-cases: `scripts/README.md`

All scripts auto-load token from `config/.env` via `scripts/common.sh`.

If `MPSTATS_TOKEN` is passed in environment for current command, it overrides `config/.env`.

If token is missing, follow the 2-option flow from **Token Onboarding (Mandatory)**.

| Script | Purpose | Usage |
|--------|---------|-------|
| `account/account-limits.sh` | Check API quota remaining | `./scripts/account/account-limits.sh` |
| `wb/wb-categories-list.sh` | Full WB category tree | `./scripts/wb/wb-categories-list.sh` |
| `wb/wb-category.sh` | WB category products | `./scripts/wb/wb-category.sh "Электроника/Смартфоны" 2024-01-01 2024-03-01` |
| `wb/wb-category-stats.sh` | WB category breakdown (subcategories/brands/sellers/trends) | `./scripts/wb/wb-category-stats.sh "Электроника" subcategories` |
| `wb/wb-sku.sh` | WB SKU analytics (full/sales/balance/keywords/comments) | `./scripts/wb/wb-sku.sh 152490541 sales` |
| `wb/wb-brand.sh` | WB brand products or analytics | `./scripts/wb/wb-brand.sh "Nike" products` |
| `wb/wb-seller.sh` | WB seller products or analytics | `./scripts/wb/wb-seller.sh 123456 products` |
| `wb/wb-search.sh` | WB subjects/niches list for research | `./scripts/wb/wb-search.sh` |
| `wb/wb-subject.sh` | WB subject endpoints (`products`, `categories`, `brands`, `sellers`, `trends`, `by_date`, `price_segmentation`, `keywords`, `similar`, `geography`, `warehouses`) | `./scripts/wb/wb-subject.sh 70 products` |
| `wb/wb-similar.sh` | WB similar families (`identical`, `identical_wb`, `similar`, `in_similar`) | `./scripts/wb/wb-similar.sh similar 72124874 products` |
| `wb/wb-analytics.sh` | WB AI forecasts and season effects | `./scripts/wb/wb-analytics.sh category forecast/daily "Женщинам/Платья и сарафаны"` |
| `wb/wb-promotion-analysis.sh` | DEPRECATED — endpoint removed in analytics/v1 API | N/A |
| `wb/wb-warehouses.sh` | WB warehouse distribution for brand/seller | `./scripts/wb/wb-warehouses.sh brand "Mango"` |
| `wb/wb-compare.sh` | WB period compare for category/brand/seller/subject | `./scripts/wb/wb-compare.sh subject 70 2024-01-01 2024-01-15 2024-01-16 2024-01-31` |
| `ozon/ozon-categories-list.sh` | Full Ozon category tree | `./scripts/ozon/ozon-categories-list.sh` |
| `ozon/ozon-category.sh` | Ozon category products or stats | `./scripts/ozon/ozon-category.sh "Автотовары" products` |
| `ozon/ozon-sku.sh` | Ozon SKU reports (`sales`, `by_day`, `balance`, `categories`, `keywords`, `full`, `by_period`, `search_stats`, `stores`, `comments`) | `./scripts/ozon/ozon-sku.sh 123456789 keywords 2023-11-27 2023-12-26` |
| `ozon/ozon-brand.sh` | Ozon brand products or analytics | `./scripts/ozon/ozon-brand.sh "Samsung" categories` |
| `ozon/ozon-seller.sh` | Ozon seller products or analytics by seller id or name | `./scripts/ozon/ozon-seller.sh 987654 products` |
| `ozon/ozon-compare.sh` | Ozon period compare for category/brand/seller | `./scripts/ozon/ozon-compare.sh category "Автотовары/..." 2024-01-01 2024-01-15 2024-01-16 2024-01-31` |
| `ym/ym-category.sh` | Yandex Market category products or stats | `./scripts/ym/ym-category.sh "Электроника/Смартфоны"` |
| `ym/ym-brand.sh` | Yandex Market brand products or analytics | `./scripts/ym/ym-brand.sh "Samsung" categories` |
| `ym/ym-seller.sh` | Yandex Market seller products or analytics | `./scripts/ym/ym-seller.sh "Эльдорадо" products` |
| `ym/ym-sku.sh` | Yandex Market item sales history with optional dates | `./scripts/ym/ym-sku.sh 12345678 2024-01-01 2024-01-31` |
| `ym/ym-compare.sh` | Yandex Market period compare for category/brand/seller | `./scripts/ym/ym-compare.sh category "Электроника/Смартфоны" 2024-01-01 2024-01-15 2024-01-16 2024-01-31` |
| `request.sh` | Universal raw API caller for any MPSTATS method/path | `./scripts/request.sh POST subject/items 'path=70&d1=2024-01-01&d2=2024-01-31'` |

Run any script with `--help` for full parameter reference.

### When to use which script

- User asks about a **product/SKU** on WB → `wb/wb-sku.sh <sku> sales`
- User asks about a **product/SKU** on Ozon → `ozon/ozon-sku.sh <sku>`
- User asks about a **product/SKU** on YM → `ym/ym-sku.sh <id>`
- User asks about a **WB category** (products, revenue, top sellers) → `wb/wb-category.sh`
- User asks for **subcategory/brand/seller breakdown** within WB category → `wb/wb-category-stats.sh`
- User asks about an **Ozon category** → `ozon/ozon-category.sh`
- User asks about a **YM category** → `ym/ym-category.sh`
- User asks about a **brand** on WB → `wb/wb-brand.sh`
- User asks about a **brand** on Ozon → `ozon/ozon-brand.sh`
- User asks about a **seller** on WB → `wb/wb-seller.sh`
- User asks about a **seller** on Ozon → `ozon/ozon-seller.sh`
- Need to find available **niches/subjects** on WB → `wb/wb-search.sh`
- Need to check **API limits** → `account/account-limits.sh`
- Need full **category tree** → `wb/wb-categories-list.sh` or `ozon/ozon-categories-list.sh`
- Need a method not covered by dedicated wrapper → `request.sh`
