# Account API

Endpoints for checking your account's API usage and limits.

All endpoints: `GET` to `https://mpstats.io/api/<path>`

---

## API Limit Balance

### GET user/report_api_limit
Get remaining API call quota for your current plan.

**Response:**
```json
{
  "available": 2500,
  "use": 38
}
```

| Field       | Type | Description |
|-------------|------|-------------|
| `available` | int  | Total API calls available on your plan |
| `use`       | int  | API calls used so far |

**Remaining calls** = `available - use`

---

Use script wrapper: `scripts/account/account-limits.sh`.
