# Authentication & Setup

## Base URL

```
https://mpstats.io/api/
```

All endpoint paths in this documentation are relative to this base URL.

## API Token

Obtain your token at https://mpstats.io/userpanel in the "API token" block.

The token is automatically regenerated when:
- You change your password
- You click "Change API token" in settings

## Authentication Methods

### Header (recommended)

```
X-Mpstats-TOKEN: <your_token>
```

### Query parameter (alternative)

```
&auth-token=<your_token>
```

> Token format example: `5a2a5f0e538dd5.6691914852255446e23a9bcac46ee5255625f5d5` — this is a placeholder, never use it in real requests. Always load the real token from `config/.env`.

## Required Headers

Every request must include:
```
X-Mpstats-TOKEN: <token>
Content-Type: application/json
```

## Response Codes

| Code | Meaning |
|------|---------|
| 200  | Success |
| 202  | Request accepted but not yet complete — retry later |
| 401  | Authorization error — invalid or missing token |
| 429  | Rate limit exceeded — see `message` field for details, `Retry-After` header for wait time in seconds |
| 500  | Internal server error — see `message` field for details |

## Rate Limits

Rate limits depend on your subscription plan. On 429:
- Check the `message` field for details
- Check the `Retry-After` response header for wait time in seconds
- Retry after that time

To check remaining API limit quota: `GET user/report_api_limit`
See `account.md` for details.

## Execution Policy

For agent workflows, call ready shell wrappers in `scripts/` and avoid raw HTTP examples in references.
