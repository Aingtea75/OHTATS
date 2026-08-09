# OHTATS — Data Flow Blueprint

> Dokumen ini mendefinisikan aliran data canonical OHTATS antar client, application, orchestration, domain services, persistence, connector, event transport, dan external systems.
>
> Dokumen ini tidak menggantikan `SYSTEM_DESIGN.md`, `ARCHITECTURE.md`, `MODULE_SPECIFICATION.md`, atau `DATABASE_DESIGN.md`. Fungsinya adalah menetapkan flow, ownership, boundary, dan control point.

---

# Status

**DATA FLOW BASELINE — REVIEW**

**Version:** 1.0.0

**Authority:** Data-flow reference

---

# 1. Purpose

Data Flow Blueprint memastikan setiap aliran data OHTATS memiliki:

- source yang jelas;
- destination yang jelas;
- owner yang jelas;
- validation boundary;
- security boundary;
- persistence rule;
- event/audit rule;
- error/retry behavior;
- correlation identity bila proses lintas modul.

Data flow tidak boleh menciptakan duplicate canonical ownership.

---

# 2. Canonical Flow

```text
Client / External Request
        ↓
API / Application
        ↓
Authentication / Authorization
        ↓
Validation / Policy
        ↓
Core Orchestration
        ↓
Domain Service
        ├──────────────→ Persistence Contract → Transactional Data Store
        ├──────────────→ Event Contract → Event Transport
        └──────────────→ Connector Contract → External System
```

External systems tidak boleh menjadi sumber langsung bagi UI/client tanpa melewati boundary OHTATS yang sesuai.

---

# 3. Data Classification

## 3.1 Master / Reference Data

Contoh:

- users;
- brokers;
- platforms;
- instruments;
- strategies;
- AI providers;
- plugins;
- subscription plans.

Master data memiliki canonical owner dan lifecycle yang jelas.

## 3.2 Transactional Data

Contoh:

- trading requests;
- orders;
- executions;
- deals;
- positions;
- workflow executions;
- subscriptions.

Transactional data menjadi authoritative business state sesuai database blueprint.

## 3.3 Historical / Immutable Data

Contoh:

- order events;
- position events;
- deals;
- audit logs;
- security events;
- published datasets;
- backtest results.

Data historical tidak boleh diubah untuk memperbaiki histori tanpa mekanisme correction/versioning yang terdokumentasi.

## 3.4 Transient Data

Contoh:

- cache;
- queue message;
- websocket state;
- worker lease;
- temporary calculation.

Transient data bukan otomatis persistent master state.

## 3.5 Sensitive Data

Contoh:

- credential;
- API key;
- access token;
- private key;
- secret provider configuration.

Sensitive data harus melalui secure secret boundary dan tidak boleh dimasukkan plaintext ke audit, log, queue payload, atau ordinary business records.

---

# 4. Request / Response Flow

```text
Client
  ↓
API Endpoint
  ↓
Authentication
  ↓
Authorization
  ↓
Request Validation
  ↓
Application Service
  ↓
Core Orchestration
  ↓
Domain Service
  ↓
Result
  ↓
Response Transformation
  ↓
Client
```

API response tidak boleh mengekspos internal database schema secara mentah.

---

# 5. Trading Data Flow

Semua executable trading action menggunakan satu control path.

```text
User / Strategy / AI / Workflow / Copy Trading
                    ↓
             Trading Request
                    ↓
             Input Validation
                    ↓
        Authentication / Authorization
                    ↓
              Policy Check
                    ↓
              Risk Evaluation
                    ↓
              Idempotency Check
                    ↓
          Persist Request State
                    ↓
              Order Creation
                    ↓
           Connector / Adapter
                    ↓
          Broker / Platform
                    ↓
        Execution / Broker Event
                    ↓
              Deal / Fill
                    ↓
       Position Reconciliation
                    ↓
       Persist Historical State
                    ↓
             Event / Audit
```

Tidak ada alternate path dari AI, plugin, workflow, copy trading, MCP, atau API langsung menuju broker command.

---

# 6. Market Data Flow

```text
Market Data Provider
        ↓
Connector
        ↓
Normalization
        ↓
Validation
        ↓
Canonical Instrument / Broker Symbol Mapping
        ↓
Hot Runtime Stream ─────→ Consumers
        │
        └───────────────→ Historical Dataset Storage
```

Historical dataset harus memiliki immutable dataset identity/version.

High-volume tick data tidak boleh diasumsikan selalu disimpan pada transactional database.

---

# 7. Strategy Flow

```text
Strategy Identity
      ↓
Strategy Version
      ↓
Validation / Publication
      ↓
Deployment
      ↓
Trading Account / Target
      ↓
Trading Request
```

Published strategy version bersifat immutable.

Strategy identity tidak menjadi owner langsung atas broker-specific execution state.

---

# 8. AI Flow

```text
Client / Workflow / Application
        ↓
AI Request
        ↓
AI Manager
        ↓
Provider Abstraction
        ↓
AI Provider Adapter
        ↓
Provider
        ↓
Normalized Response
        ↓
Analysis / Structured Decision
        ↓
Policy / Strategy Validation
        ↓
Risk Evaluation (if executable)
        ↓
Normal Domain Flow
```

AI provider response tidak boleh menjadi broker command.

AI usage metadata dapat dipersistenkan melalui `ai_requests`, `ai_responses`, `ai_usage_records`, dan related entities sesuai database blueprint.

---

# 9. Backtest Flow

```text
Backtest Definition
       ↓
Strategy Version
       ↓
Dataset Version
       ↓
Execution Assumptions
       ↓
Backtest Run
       ↓
Simulated Trades
       ↓
Metrics
       ↓
Report
```

Backtest data tidak boleh tercampur dengan live order/deal/position history.

Backtest tidak boleh menghasilkan live broker command secara diam-diam.

---

# 10. Copy Trading Flow

```text
Master Trading Event
        ↓
Copy Trade Rule
        ↓
Symbol / Instrument Mapping
        ↓
Follower Policy
        ↓
Trading Request
        ↓
Normal Risk / Trading Pipeline
        ↓
Follower Execution
        ↓
Copy Execution Record
        ↓
Audit
```

Copy trading tidak memperoleh privilege bypass.

---

# 11. Workflow Flow

```text
Workflow Definition
       ↓
Workflow Version
       ↓
Workflow Execution
       ↓
Step Execution
       ↓
Domain Command / Event
       ↓
Result
       ↓
Next Step / Retry / Failure
       ↓
Execution Completion
       ↓
Audit / Reporting
```

Workflow state authoritative berada pada workflow persistence model. Queue hanya menjadi transport/execution mechanism.

---

# 12. Event Flow

Events digunakan untuk asynchronous coordination dan notification.

```text
Domain State Change
        ↓
Domain Event
        ↓
Event Transport
        ↓
Consumer
        ├── Workflow
        ├── Notification
        ├── Monitoring
        ├── Reporting
        └── Integration
```

Event transport bukan source of truth untuk authoritative financial state.

Consumer harus menangani duplicate delivery dan retry secara idempotent.

---

# 13. Persistence Flow

```text
Domain Service
      ↓
Repository / Persistence Contract
      ↓
Transactional Store
```

Market-data historical flow dapat menggunakan storage khusus:

```text
Market Data Manager
      ↓
Dataset Contract
      ↓
Time-Series / Object / Analytical Storage
```

Canonical business references tetap berada pada database model yang ditetapkan `DATABASE_DESIGN.md`.

---

# 14. Audit Flow

Critical action harus menghasilkan audit evidence.

```text
Action
  ↓
Authorization / Policy Result
  ↓
Domain Result
  ↓
Audit Event
  ↓
Append-only Audit Store
```

Audit event harus memiliki actor/context, action, entity, outcome, timestamp, source, dan correlation/request identity bila tersedia.

Secrets harus disanitasi.

---

# 15. Error Flow

```text
Failure
  ↓
Classify
  ├── Validation Error
  ├── Authorization Error
  ├── Domain Error
  ├── Connector Error
  ├── Provider Error
  ├── Timeout
  └── Infrastructure Error
        ↓
Retry / Reject / Compensate / Escalate
        ↓
Persist Relevant State
        ↓
Audit / Log / Metric
```

Retry hanya digunakan bila operasi aman untuk diulang. Trading operation wajib mengikuti idempotency policy.

---

# 16. Correlation & Traceability

Proses lintas layer harus mempertahankan correlation identity bila relevan.

Contoh:

```text
request_id
    ↓
correlation_id
    ↓
workflow execution
    ↓
trading request
    ↓
order
    ↓
broker request
    ↓
deal / position event
    ↓
audit
```

Correlation ID bukan primary key pengganti entity ID.

---

# 17. Security Boundaries

Data flow harus menerapkan:

- least privilege;
- authentication;
- authorization;
- input validation;
- output sanitization;
- secret isolation;
- encryption sesuai kebutuhan;
- auditability.

Tidak boleh ada flow yang memindahkan secret ke layer yang tidak membutuhkannya.

---

# 18. Ownership Rules

| Data | Canonical Owner |
|---|---|
| User identity | Identity / Access Service |
| Strategy | Strategy Manager |
| Strategy Version | Strategy Manager |
| Risk Policy | Risk Manager |
| Trading Request | Trading Engine |
| Order | Trading Engine |
| Deal | Trading Engine |
| Position | Trading Engine |
| Instrument / Market Dataset | Market Data Manager |
| AI Session / Request / Decision | AI Manager |
| Workflow Execution | Workflow Engine |
| Copy Rule / Execution | Copy Trading Engine |
| Plugin | Plugin Manager |
| Subscription / License | Licensing Manager |
| Notification | Notification Manager |
| Audit | Security & Audit Manager |
| Operational Job | Scheduler / Job Service |

Persistence layer stores authoritative state but does not redefine domain ownership.

---

# 19. Data Flow Acceptance Criteria

Data Flow is ready for approval when:

- every major request path has a defined flow;
- trading has one canonical control path;
- AI cannot bypass controls;
- market data is separated from transactional assumptions;
- historical state is distinguishable from transient state;
- sensitive data has a secure boundary;
- events are not treated as financial source of truth;
- correlation and auditability are defined;
- retry/idempotency behavior is considered;
- ownership does not conflict with `MODULE_SPECIFICATION.md`;
- persistence follows `DATABASE_DESIGN.md` and `ERD.md`.

---

# 20. Related Blueprints

- `01_VISION.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `DATABASE_REVIEW.md`
- `DATABASE_REVIEW_ADDENDUM.md`
- `ERD.md`
- `EVENT_SYSTEM.md`
- `MESSAGE_QUEUE.md`
- `ERROR_HANDLING.md`
- `API_DESIGN.md`
- `INTEGRATION.md`

---

# END OF DATA_FLOW.md
