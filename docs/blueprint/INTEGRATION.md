# OHTATS — Integration Blueprint

> Menetapkan boundary dan aturan integrasi OHTATS dengan broker, trading platform, AI provider, market-data provider, notification service, storage, dan external service.

# Status

**INTEGRATION BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principles

- External system is outside OHTATS core.
- Integration melalui connector/adapter/provider boundary.
- Vendor model tidak menjadi canonical domain model tanpa normalization.
- Credential melalui secure secret boundary.
- Capability harus dapat dideteksi.
- Connection lifecycle harus observable.
- Retry/reconnect mengikuti error/idempotency policy.

# 2. Integration Categories

1. Trading platform.
2. Broker/exchange.
3. Market data.
4. AI provider.
5. Notification.
6. Storage.
7. Identity/external authentication.
8. Operational/analytics service.

# 3. Trading Platform Integration

Target:

- MT4;
- MT5;
- TradingView;
- REST/API;
- FIX/API;
- crypto exchange;
- future platform connectors.

Canonical flow:

```text
Trading Engine
   ↓
Canonical Order / Trading Contract
   ↓
Connector
   ↓
Vendor Adapter
   ↓
Broker / Platform
```

Connector menerjemahkan canonical model ke vendor-specific request dan mengubah response menjadi canonical execution/event model.

# 4. Broker / Account Integration

Broker identity, platform, server/environment, connection, dan trading account harus tetap dipisahkan sesuai database model.

Connection metadata boleh disimpan pada database; secret material menggunakan secure secret reference.

# 5. AI Provider Integration

```text
AI Manager
   ↓
Provider Interface
   ↓
Provider Adapter
   ↓
External AI Provider / Local Model
```

Provider-specific API, model name, token usage, rate limit, dan error mapping diisolasi pada adapter.

AI provider tidak boleh memperoleh broker execution privilege.

# 6. Market Data Integration

```text
Provider
  ↓
Market Data Connector
  ↓
Normalization
  ↓
Validation
  ↓
Canonical Instrument / Broker Symbol
  ↓
Runtime Stream / Dataset Storage
```

Dataset yang dipublikasikan harus versioned dan immutable.

# 7. Notification Integration

Notification Manager menggunakan provider adapter.

Provider failure tidak boleh mengubah authoritative trading state kecuali domain secara eksplisit mendefinisikan dependency tersebut.

# 8. Storage Integration

Storage provider dapat digunakan untuk:

- historical market data;
- backup artifacts;
- reports;
- plugin packages;
- large datasets.

Database menyimpan metadata/reference yang diperlukan; storage menyimpan artifact sesuai lifecycle.

# 9. Authentication Integration

External identity provider dapat digunakan bila deployment membutuhkannya. External identity harus dinormalisasi ke OHTATS identity/access model.

# 10. Connection Lifecycle

```text
Configured
  ↓
Validated
  ↓
Connecting
  ↓
Connected
  ↓
Degraded / Reconnecting
  ↓
Disconnected / Disabled
```

State transition harus observable dan relevan dapat diaudit.

# 11. Capability Discovery

Connector dapat mengiklankan capability seperti:

- order types;
- hedging/netting;
- partial fill;
- amend/cancel;
- symbol rules;
- market data types;
- streaming;
- authentication methods.

Core harus menggunakan canonical capability model, bukan vendor-specific flags secara langsung.

# 12. Secret Handling

Integration credential tidak boleh:

- disimpan plaintext di business table;
- masuk queue payload;
- masuk audit log;
- masuk application log;
- dikirim ke client tanpa kebutuhan yang sah.

Gunakan `secret_ref` atau secure credential mechanism.

# 13. Reconciliation

External systems dapat menghasilkan state yang berbeda karena timeout, partial fill, disconnect, atau manual action.

Trading integration wajib menyediakan reconciliation capability untuk account, order, deal, dan position sesuai platform.

# 14. Failure Handling

Semua integration mengikuti `ERROR_HANDLING.md`.

Unknown trading result tidak boleh langsung menghasilkan duplicate order. Sistem harus melakukan reconciliation sebelum retry side effect.

# 15. Integration Testing

Setiap connector minimal memerlukan:

- contract tests;
- authentication test;
- capability test;
- happy path;
- failure path;
- timeout/retry test;
- reconciliation test;
- idempotency test untuk side effects;
- secret-handling test.

# 16. Acceptance Criteria

- external boundary jelas;
- connector/provider abstraction jelas;
- canonical model tidak tercemar vendor details;
- credential aman;
- capability discovery tersedia;
- lifecycle dan reconnect defined;
- reconciliation defined untuk trading integration;
- testing scope defined;
- konsisten dengan `ARCHITECTURE.md`, `DATA_FLOW.md`, dan `DATABASE_DESIGN.md`.

# 17. Related Blueprints

- `DATA_FLOW.md`
- `API_DESIGN.md`
- `EVENT_SYSTEM.md`
- `MESSAGE_QUEUE.md`
- `ERROR_HANDLING.md`
- `MULTI_PLATFORM.md`
- `AI_PROVIDER.md`
- `DATABASE_DESIGN.md`

# END OF INTEGRATION.md
