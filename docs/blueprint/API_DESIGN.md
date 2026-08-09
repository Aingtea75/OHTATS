# OHTATS — API Design Blueprint

> Menetapkan kontrak API eksternal/internal OHTATS tanpa mengikat implementasi pada framework tertentu.

# Status

**API DESIGN BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principles

- API-first.
- Contract-first.
- Versioned.
- Authentication and authorization by default.
- Idempotency untuk command yang dapat diulang.
- Pagination/filtering untuk collection.
- Stable error model.
- Correlation/request ID untuk traceability.
- Tidak mengekspos schema database secara mentah.
- Tidak memberi jalur broker command di luar Trading Engine.

# 2. API Boundary

```text
Client
  ↓
API Gateway / API Service
  ↓
Authentication
  ↓
Authorization / Policy
  ↓
Application Service
  ↓
Domain Service
  ↓
Persistence / Event / Connector Contract
```

API tidak boleh langsung mengakses database atau broker.

# 3. Versioning

Canonical public API menggunakan path versioning, misalnya:

```text
/api/v1/...
```

Breaking change memerlukan major version baru. Non-breaking extension harus kompatibel dengan consumer lama.

# 4. Resource Families

- `/users`
- `/sessions`
- `/trading-accounts`
- `/brokers`
- `/platforms`
- `/connections`
- `/instruments`
- `/market-data`
- `/strategies`
- `/strategy-versions`
- `/deployments`
- `/risk-policies`
- `/trading-requests`
- `/orders`
- `/positions`
- `/deals`
- `/backtests`
- `/ai/providers`
- `/ai/sessions`
- `/ai/requests`
- `/workflows`
- `/copy-trading`
- `/plugins`
- `/subscriptions`
- `/licenses`
- `/notifications`
- `/reports`
- `/jobs`
- `/audit`

Resource names must follow canonical ownership in `MODULE_SPECIFICATION.md`.

# 5. Command vs Query

Query:

```text
GET /api/v1/orders/{id}
GET /api/v1/positions
```

Command:

```text
POST /api/v1/trading-requests
POST /api/v1/orders/{id}/cancel
POST /api/v1/strategies/{id}/deployments
```

Trading commands require authorization, policy, risk validation, and idempotency where applicable.

# 6. Trading API Rule

```text
API Request
  ↓
Trading Request
  ↓
Authorization
  ↓
Policy
  ↓
Risk Manager
  ↓
Trading Engine
  ↓
Connector
```

API endpoint tidak boleh langsung memanggil broker connector untuk execution.

# 7. Authentication / Authorization

Authentication dapat menggunakan session/token/API key sesuai deployment.

Authorization harus mempertimbangkan:

- user;
- role;
- permission;
- resource ownership;
- account scope;
- capability;
- licensing/entitlement bila relevan.

# 8. Idempotency

Command yang dapat menyebabkan external side effect harus mendukung idempotency bila retry mungkin terjadi.

Header canonical:

```text
Idempotency-Key: <client-generated-key>
X-Correlation-ID: <correlation-id>
```

Server harus menyimpan hasil/replay state sesuai transaction policy.

# 9. Error Contract

Canonical response:

```json
{
  "error": {
    "code": "TRADING_RISK_REJECTED",
    "message": "Request rejected by risk policy",
    "request_id": "...",
    "details": {}
  }
}
```

Jangan mengembalikan secret, stack trace internal, credential, atau vendor-sensitive payload.

# 10. Pagination / Filtering

Collection API harus mendukung pagination untuk data yang dapat bertumbuh.

Filter/sort harus whitelist-based dan tidak diteruskan mentah ke query database.

# 11. WebSocket / Realtime

Realtime API digunakan untuk event/data streaming yang diizinkan.

Client tidak boleh menganggap websocket event sebagai authoritative replacement untuk REST/resource state.

# 12. Audit

Critical API actions menghasilkan audit evidence sesuai `DATA_FLOW.md` dan `DATABASE_REVIEW.md`.

# 13. Acceptance Criteria

API baseline siap approval ketika:

- contract ownership jelas;
- versioning jelas;
- authz diterapkan;
- trading path tidak bypass risk/trading engine;
- idempotency tersedia untuk side-effect command;
- error model stabil;
- correlation ID tersedia;
- pagination/filtering aman;
- secrets tidak bocor;
- kontrak konsisten dengan database dan data flow.

# 14. Related Blueprints

- `DATA_FLOW.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `SECURITY.md`
- `ERROR_HANDLING.md`
- `EVENT_SYSTEM.md`

# END OF API_DESIGN.md
