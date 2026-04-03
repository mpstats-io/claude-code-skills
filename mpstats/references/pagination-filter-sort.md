# Pagination, Filtering & Sorting

Common request/response model used by all POST endpoints that return product lists.

## Request Body (POST endpoints)

```json
{
  "startRow": 0,
  "endRow": 100,
  "filterModel": {},
  "sortModel": []
}
```

| Field        | Type   | Description |
|--------------|--------|-------------|
| `startRow`   | int    | Start row index (0-based) |
| `endRow`     | int    | End row index. Max 5000 records per request |
| `filterModel`| object | Filters applied to results |
| `sortModel`  | array  | Sort configuration |

## Response Body

```json
{
  "startRow": 0,
  "endRow": 100,
  "filterModel": {},
  "sortModel": [],
  "total": 42,
  "data": [...]
}
```

| Field        | Type   | Description |
|--------------|--------|-------------|
| `startRow`   | int    | Start row from request |
| `endRow`     | int    | End row from request |
| `filterModel`| object | Filters that were applied |
| `sortModel`  | array  | Sort that was applied |
| `total`      | int    | Total rows without pagination |
| `data`       | array  | Result array |

## Filter Model Examples

### Number filter
```json
{
  "filterModel": {
    "id": {
      "filterType": "number",
      "type": "equals",
      "filter": 13495594,
      "filterTo": null
    }
  }
}
```

### Filter types
- `"type": "equals"` — exact match
- `"type": "greaterThan"` — greater than
- `"type": "lessThan"` — less than
- `"type": "inRange"` — range (use `filter` for min, `filterTo` for max)

## Sort Model Examples

```json
{
  "sortModel": [
    { "colId": "revenue", "sort": "desc" }
  ]
}
```

Sort direction: `"asc"` or `"desc"`

Common sort columns: `revenue`, `sales`, `balance`, `rating`, `comments`, `final_price`

## Query Parameters (common across endpoints)

| Param   | Type   | Description |
|---------|--------|-------------|
| `d1`    | string | Start date `YYYY-MM-DD` |
| `d2`    | string | End date `YYYY-MM-DD` |
| `fbs`   | int    | Include FBS (0 = off, 1 = on) |

For practical usage, rely on prepared shell scripts in `scripts/` and pass limits/date range there.
