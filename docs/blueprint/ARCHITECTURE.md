# OHTATS Architecture

> Dokumen ini mendefinisikan arsitektur teknis tingkat platform OHTATS dan menjadi referensi hubungan antar-layer, dependency, boundary, serta integrasi. `SYSTEM_DESIGN.md` mendefinisikan fungsi sistem tingkat tinggi; dokumen ini menetapkan bentuk hubungan teknisnya.

---

# Status

**ARCHITECTURE BASELINE — REVIEW**

**Version:** 1.0.0

**Authority:** Technical architecture reference

---

# 1. Architecture Principles

OHTATS mengikuti prinsip:

- Modular
- Layered
- Event-driven
- API-first
- Plugin-based
- Provider-agnostic
- Platform-agnostic
- Secure by design
- Risk-first
- Auditable
- Reproducible
- Scalable
- Maintainable
- Extensible

---

# 2. System Boundary

```text
+----------------------------------------------------------------+
|                         OHTATS PLATFORM                        |
|                                                                |
|  Client / Interface                                            |
|          |                                                     |
|          v                                                     |
|  API & Application                                             |
|          |                                                     |
|          v                                                     |
|  Core Orchestration                                            |
|          |                                                     |
|          +---- Domain Services                                 |
|          |       +-- AI                                       |
|          |       +-- Strategy                                  |
|          |       +-- Risk                                      |
|          |       +-- Trading                                   |
|          |       +-- Market Data                               |
|          |       +-- Backtest                                  |
|          |       +-- Workflow                                  |
|          |       +-- Copy Trading                              |
|          |       +-- Plugin                                    |
|          |       +-- Reporting                                 |
|          |       +-- Security / Audit                          |
|          |       +-- Licensing                                 |
|          |       +-- Operations                                |
|          |                                                     |
|          v                                                     |
|  Connector & Integration                                       |
|          |                                                     |
|          +---- Persistence & Data                              |
+----------+-----------------------------------------------------+
           |
           +---- MT4 / MT5 / TradingView
           +---- Broker APIs / Exchanges
           +---- Market Data Providers
           +---- AI Providers
           +---- Notification / External Services
```

External systems remain outside the OHTATS core boundary. Vendor-specific behavior must be isolated by connector, adapter, provider, or integration contracts.

---

# 3. Canonical Layers

OHTATS uses the following canonical technical layers:

1. **Client & Interface Layer**
2. **API & Application Layer**
3. **Core Orchestration Layer**
4. **Domain Services Layer**
5. **Connector & Integration Layer**
6. **Persistence & Data Layer**
7. **Infrastructure & Operations Services**

The layers are architectural boundaries, not necessarily separate deployable processes.

---

## 3.1 Client & Interface Layer

### Responsibilities

- Web dashboard
- Desktop interface
- Mobile interface
- Administrative interface
- External API clients
- Presentation state
- User interaction

### Rules

- Must not access the database directly.
- Must not issue broker commands directly.
- Must communicate through API/application contracts.
- Must not contain core trading business rules.

---

## 3.2 API & Application Layer

### Responsibilities

- Request entry point
- Authentication integration
- Authorization integration
- Input validation
- Request/response transformation
- API versioning
- Application use cases
- Configuration requests
- Strategy requests
- AI requests
- Trading requests
- Backtest requests
- Workflow requests
- Reporting requests

### Rules

- May orchestrate use cases but must not bypass domain controls.
- Must not contain vendor-specific broker logic.
- Must not directly manipulate persistence internals.

---

## 3.3 Core Orchestration Layer

### Responsibilities

- Command routing
- Domain coordination
- Event coordination
- Workflow triggering
- Lifecycle coordination
- Idempotency coordination
- Process failure handling
- Policy enforcement coordination

Core Orchestration is a coordinator, not a replacement for domain engines.

### Critical rule

Core orchestration must never provide a bypass around authorization, risk, security, trading, or audit controls.

---

## 3.4 Domain Services Layer

The domain layer contains the capability engines and managers defined by `SYSTEM_DESIGN.md`.

Canonical domains:

- AI Manager
- Strategy Manager
- Risk Manager
- Trading Engine
- Market Data Manager
- Backtest Engine
- Workflow Engine
- Copy Trading Engine
- Plugin Manager
- Notification Manager
- Reporting Manager
- Security & Audit Manager
- Licensing & Subscription Manager
- Operations Manager

Each domain owns its responsibility and communicates through explicit service/event contracts.

---

## 3.5 Connector & Integration Layer

### Responsibilities

- Broker connectivity
- Platform connectivity
- Market-data connectivity
- AI provider connectivity
- Notification provider connectivity
- External service connectivity
- Protocol translation
- Capability detection
- Connection health
- Reconnect handling

### Rules

External/vendor-specific models must not leak into core domain contracts unless explicitly normalized into a canonical model.

---

## 3.6 Persistence & Data Layer

### Responsibilities

- Transactional persistence
- Market data storage
- Backtest data
- Audit/event records
- Configuration persistence
- Retention
- Backup/recovery integration

Canonical persistent entities follow `DATABASE_DESIGN.md` and `ERD.md`.

### Rules

- UI does not access persistence directly.
- Vendor-specific storage schemas must not become canonical domain entities without architectural review.
- Historical financial records are immutable according to database rules.

---

## 3.7 Infrastructure & Operations Services

Infrastructure services support the runtime without becoming the owner of business-domain state.

Examples:

- Logging
- Monitoring
- Scheduler
- Cache
- Queue/event transport
- Backup/restore
- Secret management
- Runtime configuration
- Operational health

Transient infrastructure state does not automatically become a persistent master entity.

---

# 4. Dependency Rules

Dependency direction must remain controlled:

```text
Client
  ↓
API / Application
  ↓
Core Orchestration
  ↓
Domain Services
  ↓
Connector / Persistence contracts
  ↓
External Systems / Storage
```

Rules:

1. Higher layers may depend on documented contracts of lower layers.
2. Lower layers must not depend upward on presentation concerns.
3. Domain logic must not depend directly on vendor-specific implementations.
4. External integrations must use adapters/connectors/providers.
5. AI providers must be accessed through provider abstractions.
6. Trading platforms and brokers must be accessed through connector abstractions.
7. Persistence must be accessed through repository/service contracts where appropriate.
8. Cross-domain access must use explicit service or event contracts.
9. Circular dependencies are prohibited.
10. A plugin must not bypass capability, security, risk, or audit boundaries.

---

# 5. Trading Architecture Boundary

All executable trading actions follow one canonical pipeline:

```text
User / Strategy / Workflow / Copy Trading / AI
                    |
                    v
             Trading Request
                    |
                    v
              Validation
                    |
                    v
             Policy / Auth
                    |
                    v
             Risk Evaluation
                    |
             +------+------+
             |             |
           Reject        Approve
             |             |
             v             v
           Audit      Order Creation
                           |
                           v
                       Connector
                           |
                           v
                    Broker / Platform
                           |
                           v
                     Execution / Deal
                           |
                           v
                        Position
                           |
                           v
                      Events / Audit
```

No AI, workflow, plugin, copy-trading, or application endpoint may create a broker command outside this control path.

---

# 6. AI Architecture Boundary

AI is a capability provider, not a privileged execution channel.

```text
AI Request
   ↓
AI Provider Abstraction
   ↓
AI Response / Analysis
   ↓
Structured Decision
   ↓
Strategy / Policy Validation
   ↓
Risk Evaluation
   ↓
Trading Pipeline (if applicable)
```

AI provider replacement must not require changes to the core domain model.

---

# 7. Backtest Boundary

Backtest is isolated from live execution:

```text
Strategy Version
      ↓
Dataset Version
      ↓
Backtest Run
      ↓
Simulated Trades
      ↓
Metrics
      ↓
Report
```

Backtest must not silently produce live broker commands.

---

# 8. Copy Trading Boundary

```text
Master Event
     ↓
Copy Rule
     ↓
Symbol Mapping
     ↓
Follower Risk Policy
     ↓
Trading Request
     ↓
Normal Trading Pipeline
```

Copy trading must not create a privileged execution path.

---

# 9. Event & Audit Architecture

Events support:

- asynchronous processing;
- workflow triggering;
- integration;
- monitoring;
- lifecycle coordination;
- audit support.

Events are not a replacement for authoritative persistent financial state.

Critical operations must be auditable, including authentication/security changes, configuration changes, strategy publication/deployment, risk changes, trading requests, order lifecycle, relevant AI decisions, copy-trading actions, licensing changes, and administrative actions.

---

# 10. Security Architecture

Security is cross-cutting across all layers:

```text
Identity
  ↓
Authentication
  ↓
Authorization
  ↓
Policy
  ↓
Capability
  ↓
Domain Action
  ↓
Audit
```

Secrets and credentials must remain inside the security boundary and must not be stored as ordinary business data in plaintext.

---

# 11. Architecture Acceptance Criteria

Architecture is ready for approval when:

- canonical layers are unambiguous;
- dependency direction is documented;
- external systems are isolated behind connectors/providers;
- AI cannot bypass controls;
- trading follows one canonical control pipeline;
- backtest and copy trading boundaries are explicit;
- persistence follows the database baseline;
- event/audit responsibility is clear;
- plugin capability boundaries are explicit;
- and the architecture is consistent with `SYSTEM_DESIGN.md`.

---

# 12. Related Blueprints

- `01_VISION.md`
- `PROJECT_CONSTITUTION.md`
- `PLATFORM_PHILOSOPHY.md`
- `SYSTEM_DESIGN.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `DATABASE_REVIEW.md`
- `ERD.md`
- `ARCHITECTURE_DECISIONS.md`

---

# END OF ARCHITECTURE.md
