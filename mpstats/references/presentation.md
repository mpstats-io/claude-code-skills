# Presentation & Reporting Guidelines

This reference defines how MPSTATS-based analytical results should be presented to the user.

## Goal

MPSTATS outputs should feel like marketplace analytics, not raw API dumps.
The answer should help the user make a decision quickly:

- what is happening
- why it matters
- what to do next

## Default answer structure

For most analytical requests, use this order:

1. Short conclusion
2. Key metrics
3. Evidence in tables and/or charts
4. Interpretation
5. Risks, caveats, or next actions

If the task is simple, keep the structure compact. If the task is report-like, expand it.

## Tables: when they are required

Include at least one table when the result involves any of the following:

- multiple products, sellers, brands, or categories
- period comparisons
- price segmentation
- ranking lists
- niche comparisons
- seller or competitor comparisons
- SKU-level top rows

Good table examples:

- top sellers by revenue
- category or niche comparison
- price bucket breakdown
- month-by-month dynamics
- comparison of 2-5 candidate niches

Avoid giant tables. Prefer 5-15 rows unless the user asks for full exports.

## Charts: when they should be included

Include a chart, or a chart-ready block in the report, when there is meaningful visual signal in:

- time series (`by_date`, trends, forecasts, seasonality)
- price segmentation
- market share or seller concentration
- period comparison
- revenue distribution across buckets or entities

Recommended chart types:

- line chart for revenue/sales over time
- bar chart for top sellers, brands, SKUs, or categories
- stacked bar chart for price segmentation or share splits
- column chart for period-over-period comparisons

If the final output channel does not support rendered charts, provide a compact textual interpretation plus a table that clearly exposes the same pattern.

## Narrative rules

- Lead with insight, not with data extraction mechanics.
- Do not paste raw JSON unless explicitly requested.
- Every metric block should answer "why this matters."
- When discussing a niche, seller, or product, include both opportunity and risk.
- For recommendations, explicitly state why one option is stronger than the alternatives.

## HTML/PDF report standard

If a standalone HTML or PDF report is generated, it should follow MPSTATS-style presentation.

### MPSTATS-style principles

- Analytics-first, not brochure-first
- Clean dashboard/report hybrid
- Strong information hierarchy
- Data blocks, metric cards, and clear separators
- Branded but restrained visuals
- Focus on decisions, not decoration

### Expected report sections

Use the relevant subset for the task:

1. Title and report metadata
2. Executive summary
3. Methodology / data source note
4. KPI cards
5. Main analysis sections
6. Tables
7. Charts
8. Key takeaways
9. Risks / caveats
10. Recommended next steps

### MPSTATS Brand Color System

Reports MUST use the MPSTATS brand palette (green + white). Never use blue, purple, or other off-brand accents.

**Core palette:**

| Role | Hex | Usage |
|------|-----|-------|
| Primary green | `#00B956` | Accent, buttons, active elements, chart primary |
| Dark green | `#007A3D` | Hero gradients, headings, strong emphasis |
| Deep green | `#004D26` | Darkest hero background, text on light |
| Light green bg | `#E8F5E9` | Summary boxes, positive callouts, soft fill |
| Mint tint | `#F0FFF4` | Subtle section backgrounds |
| White | `#FFFFFF` | Paper, cards, primary background |
| Dark text | `#1A1A2E` | Body copy |
| Muted text | `#5A6872` | Labels, captions, secondary text |
| Border/line | `#D9E0E7` | Dividers, table borders, card strokes |
| Warm warning | `#C98900` | Warning callouts, caution badges |
| Warning bg | `#FFF5DA` | Warning block background |
| Risk red | `#C23B32` | Risk callouts, negative badges |
| Risk bg | `#FDEBEA` | Risk block background |
| Good green | `#0F9D58` | Positive badges (secondary to primary green) |
| Good bg | `#E7F6ED` | Positive block background |

**Chart colors (contrasting palette):**

Use green as the primary series. For multi-series charts, use this ordered set:

1. `#00B956` — primary (MPSTATS green)
2. `#FF6B35` — orange (contrast)
3. `#2D77D0` — blue (neutral complement)
4. `#9B59B6` — purple
5. `#F39C12` — amber
6. `#1ABC9C` — teal

For bar/pie charts with 2 segments: `#00B956` vs `#E0E0E0` (green vs gray).

**CSS variables template for HTML reports:**

```css
:root {
  --bg: #F7F9FB;
  --paper: #FFFFFF;
  --ink: #1A1A2E;
  --muted: #5A6872;
  --line: #D9E0E7;
  --accent: #00B956;
  --accent-dark: #007A3D;
  --accent-deep: #004D26;
  --accent-soft: #E8F5E9;
  --accent-tint: #F0FFF4;
  --good: #0F9D58;
  --good-soft: #E7F6ED;
  --warn: #C98900;
  --warn-soft: #FFF5DA;
  --risk: #C23B32;
  --risk-soft: #FDEBEA;
  --card-shadow: 0 12px 32px rgba(0, 77, 38, 0.06);
}
```

**Hero section gradient:** always use green tones, never blue.
```css
.hero {
  background: linear-gradient(135deg, #004D26 0%, #007A3D 55%, #00B956 100%);
  color: white;
}
```

### Visual language

Prefer styling that feels close to marketplace analytics products:

- calm light background (white or very light green tint)
- MPSTATS green as the primary accent color
- cards for KPIs with subtle green accents
- compact comparison tables
- highlighted takeaway boxes with green borders/backgrounds
- risk/caveat blocks styled with warning/risk colors (not green)
- branded header with MPSTATS green gradient

Avoid:

- blue, purple, or other off-brand accent colors
- generic blog-like layouts
- overly playful landing-page styles
- loud gradients unrelated to MPSTATS green
- decorative elements that compete with the data

## Minimal output rules by task type

### Quick factual answer

- short summary
- one small table if there are multiple rows

### Comparative analysis

- recommendation up front
- comparison table required
- chart if there is trend or share data

### Niche / product research

- summary of opportunity
- table with key metrics
- at least one trend or segmentation view when available
- explicit risks and entry considerations

### Seller / brand review

- headline conclusion
- KPI table
- top entities table
- chart for time dynamics if available

### Full report request

- HTML or PDF is appropriate
- include KPI cards, tables, and charts where applicable
- style should follow MPSTATS report principles above
