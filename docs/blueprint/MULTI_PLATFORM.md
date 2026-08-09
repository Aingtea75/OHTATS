# OHTATS — Multi-Platform Blueprint

# Status

**MULTI-PLATFORM BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Objective

OHTATS mendukung banyak trading platform tanpa menjadikan model satu vendor sebagai canonical core model.

Target:

- MT4;
- MT5;
- TradingView;
- broker REST/API;
- FIX/API;
- crypto exchange;
- platform tambahan melalui connector/plugin.

# 2. Canonical Boundary

```text
Trading Domain
      ↓
Canonical Trading Contract
      ↓
Connector Manager
      ↓
Platform Connector
      ↓
Broker / Platform
```

# 3. Capability Model

Connector harus dapat menyatakan capability:

- account model;
- hedging/netting;
- order types;
- execution model;
- partial fills;
- amend/cancel;
- market data;
- streaming;
- authentication;
- symbol rules;
- position semantics.

# 4. Account / Broker Separation

Broker, platform, broker-platform capability, connection, trading account, instrument, dan broker symbol mengikuti canonical database model.

# 5. Symbol Normalization

```text
Canonical Instrument
       ↓
Broker Symbol Mapping
       ↓
Platform Symbol
```

Contoh broker suffix/prefix tidak boleh mengubah canonical instrument identity.

# 6. Position Semantics

MT4/MT5/platform lain dapat berbeda dalam netting/hedging dan position lifecycle. Connector bertanggung jawab menerjemahkan semantics vendor menjadi canonical position/deal model.

# 7. Reconciliation

Connector harus mendukung reconciliation untuk state yang dapat berbeda akibat disconnect, manual action, partial execution, atau timeout.

# 8. Testing

Setiap platform connector memerlukan contract, capability, authentication, execution, failure, reconciliation, idempotency, dan security tests.

# 9. Acceptance Criteria

- connector isolation;
- canonical model preserved;
- capability discovery;
- symbol mapping;
- account/platform separation;
- position semantics defined;
- reconciliation defined;
- consistent dengan `INTEGRATION.md`, `DATABASE_DESIGN.md`, `ERD.md`, dan `TRADING_ENGINE.md`.

# END OF MULTI_PLATFORM.md
