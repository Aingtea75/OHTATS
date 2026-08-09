# OHTATS Module Specification

> Dokumen ini mendefinisikan modul dan batas tanggung jawab OHTATS. `SYSTEM_DESIGN.md` adalah sumber fungsi tingkat sistem; `ARCHITECTURE.md` adalah sumber boundary teknis; dokumen ini memetakan capability menjadi modul tanpa membuat duplicate master entity.

---

# Status

**MODULE SPECIFICATION BASELINE — REVIEW**

**Version:** 1.0.0

---

# 1. Module Principles

Setiap modul harus:

- memiliki single responsibility;
- memiliki boundary dan interface yang jelas;
- testable;
- replaceable jika berada di integration/provider boundary;
- configurable;
- observable;
- auditable untuk operasi kritis;
- tidak membuat duplicate master entity;
- tidak bypass security, authorization, risk, trading, atau audit controls.

---

# 2. Core Orchestration Modules

## 2.1 Core Orchestrator

Mengkoordinasikan lifecycle, command routing, domain coordination, event coordination, idempotency, workflow triggering, dan failure handling.

**Tidak boleh:** menjalankan broker command langsung atau menjadi pengganti domain engine.

## 2.2 Application Service Layer

Mengeksekusi application use case dari API/client dan meneruskan proses ke domain service yang sesuai.

**Tidak boleh:** menyimpan business master state yang seharusnya dimiliki domain.

---

# 3. Domain Modules

## 3.1 AI Manager

Mengelola AI provider/model abstraction, AI request/response, analysis, decision, session, usage, prompt, dan policy integration.

AI output bukan broker command.

## 3.2 Strategy Manager

Mengelola strategy identity, version, parameter, validation, deployment, publication, dan reproducibility.

Published executable strategy version harus immutable.

## 3.3 Risk Manager

Mengelola risk policy, risk rules, sizing, exposure, loss limits, drawdown controls, validation, deny/halt conditions, dan risk events.

Risk Manager adalah mandatory gate sebelum executable trading action.

## 3.4 Trading Engine

Mengelola canonical trading lifecycle:

```text
Trading Request → Validation → Risk → Order → Connector → Execution/Deal → Position → Event/Audit
```

Trading Engine tidak boleh membuat asumsi satu order = satu position.

## 3.5 Market Data Manager

Mengelola canonical instruments, broker symbols, mappings, data sources, datasets, bars, ticks, ingestion, normalization, validation, versioning, dan retention.

## 3.6 Backtest Engine

Mengelola backtest definition/run, strategy version, dataset version, simulated trades, metrics, reproducibility, dan reporting.

Backtest terisolasi dari live execution.

## 3.7 Workflow Engine

Mengelola workflow definition/version, steps, execution state, retries, transitions, dan failure handling.

Workflow dapat mengorkestrasi domain tetapi tidak boleh bypass controls.

## 3.8 Copy Trading Engine

Mengelola master/follower relationship, copy rules, symbol mapping, follower policy, dan copy execution request.

Semua follower action masuk ke normal trading/risk pipeline.

## 3.9 Portfolio & Performance Service

Mengelola aggregation dan analytical view terhadap portfolio, exposure, performance, metrics, dan reporting input.

Tidak menjadi duplicate owner untuk order, deal, atau position history.

## 3.10 Reporting Manager

Menghasilkan trading, performance, risk, backtest, AI usage, operational, dan audit-oriented reports dari data tervalidasi.

Reporting tidak mengubah historical financial records.

## 3.11 Licensing & Subscription Manager

Mengelola plan, plan version, subscription, license, entitlement, expiration, dan access policy.

Entitlement tidak menjadi bagian dari ownership atau historical trading state.

---

# 4. Integration Modules

## 4.1 Connector Manager

Mengelola lifecycle dan capability dari koneksi eksternal.

## 4.2 Trading Platform Connectors

Implementasi connector terpisah untuk:

- MT4;
- MT5;
- TradingView;
- broker REST/API;
- FIX/API;
- crypto exchange;
- platform tambahan melalui extension.

Connector menerjemahkan canonical OHTATS model ke model vendor-specific.

## 4.3 AI Provider Adapters

Provider adapter dapat mendukung:

- OpenAI;
- Google Gemini;
- Anthropic Claude;
- xAI Grok;
- DeepSeek;
- OpenRouter;
- Ollama;
- LM Studio;
- custom API.

Daftar ini adalah target capability, bukan dependency wajib.

## 4.4 External Service Adapters

Adapter untuk notification, market data, storage, atau external service lain sesuai integration contract.

---

# 5. Platform & Extension Modules

## 5.1 Plugin Manager

Mengelola plugin identity, version, dependency, compatibility, installation, activation, deactivation, lifecycle, permission, dan capability.

Plugin tidak memperoleh hak di luar capability yang diberikan.

## 5.2 Marketplace Service

Mengelola katalog, metadata, compatibility, publication, entitlement, dan distribution policy untuk component yang didistribusikan melalui marketplace.

Marketplace bukan owner dari domain trading history.

## 5.3 MCP Service

Menyediakan Model Context Protocol boundary untuk AI assistant atau external client sesuai authorization dan capability policy.

MCP tidak boleh menjadi bypass terhadap security, risk, trading, atau audit controls.

---

# 6. Interface Modules

## 6.1 Dashboard / Client Interface

Menyediakan web, desktop, mobile, dan administrative interface.

UI tidak mengakses database atau broker secara langsung.

## 6.2 API Service

Menyediakan REST/API contract, request validation, authentication integration, authorization integration, transformation, dan versioning.

## 6.3 WebSocket / Realtime Service

Menyediakan event/data streaming kepada client sesuai authorization.

## 6.4 Identity & Access Service

Mengelola authentication, session, token, user identity, role, permission, dan access policy.

---

# 7. Security, Audit & Operations Modules

## 7.1 Security & Audit Manager

Mengelola authentication/security events, authorization policy, sensitive operations, audit trail, dan access governance.

## 7.2 Configuration Manager

Mengelola configuration hierarchy, validation, environment separation, dan runtime configuration policy.

Secret harus dikelola melalui secure secret boundary dan tidak disimpan plaintext sebagai business data.

## 7.3 Logging Service

Mengelola structured application/runtime logging tanpa menggantikan audit records.

## 7.4 Monitoring & Observability Service

Mengelola health, metrics, traces, alerts, dan operational visibility.

## 7.5 Scheduler / Job Service

Mengelola scheduled jobs, execution state, retry, dan operational scheduling.

## 7.6 Notification Manager

Mengelola notification creation, routing, delivery, retry, status, dan provider adapters.

## 7.7 Backup & Recovery Service

Mengelola backup orchestration, restore workflow, retention, verification, dan recovery evidence.

## 7.8 Data / Persistence Service

Menyediakan repository/persistence contracts dan storage orchestration. Struktur canonical persistent entity mengikuti `DATABASE_DESIGN.md` dan `ERD.md`.

---

# 8. Module Dependency Rules

```text
Client / API
     ↓
Application / Core Orchestration
     ↓
Domain Modules
     ↓
Integration / Persistence Contracts
     ↓
External Systems / Storage
```

Rules:

1. Domain modules tidak boleh bergantung langsung pada vendor implementation.
2. Connector/provider berada di integration boundary.
3. Tidak boleh ada circular dependency antar domain.
4. Module tidak boleh membuat duplicate canonical master entity.
5. Cross-module mutation harus menggunakan documented service/command/event contract.
6. Critical trading action harus melalui Risk Manager dan Trading Engine.
7. AI, workflow, copy trading, plugin, dan MCP tidak boleh bypass controls.
8. Historical financial state tetap authoritative pada persistence model yang ditetapkan database blueprint.

---

# 9. Canonical Trading Ownership

| Capability | Canonical Module |
|---|---|
| Trading request | Trading Engine |
| Order lifecycle | Trading Engine |
| Execution / Deal lifecycle | Trading Engine |
| Position lifecycle | Trading Engine |
| Risk decision | Risk Manager |
| Strategy identity/version | Strategy Manager |
| Market instrument/data | Market Data Manager |
| Backtest run | Backtest Engine |
| Copy rules | Copy Trading Engine |
| Workflow execution | Workflow Engine |
| AI analysis/decision | AI Manager |
| Report generation | Reporting Manager |
| Entitlement | Licensing & Subscription Manager |
| External connectivity | Connector Manager |

This table prevents duplicate ownership across modules.

---

# 10. Module Acceptance Criteria

A module is ready for approval when:

- its responsibility is explicit;
- its owner/boundary is explicit;
- inputs and outputs are identifiable;
- dependencies are controlled;
- it does not duplicate canonical master entities;
- security and audit requirements are defined;
- failure behavior is considered;
- testing scope is identifiable;
- and its behavior is consistent with `SYSTEM_DESIGN.md` and `ARCHITECTURE.md`.

---

# 11. Related Blueprints

- `01_VISION.md`
- `PROJECT_CONSTITUTION.md`
- `PLATFORM_PHILOSOPHY.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `DATABASE_DESIGN.md`
- `DATABASE_REVIEW.md`
- `ERD.md`
- `ARCHITECTURE_DECISIONS.md`

---

# END OF MODULE_SPECIFICATION.md
