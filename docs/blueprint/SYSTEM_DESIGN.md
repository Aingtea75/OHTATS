# OHTATS — System Design

> Dokumen ini mendefinisikan desain sistem tingkat tinggi OHTATS dan menjadi
> jembatan antara vision, architecture, module specification, database,
> integration, dan implementation.

---

# Status

**FINAL SYSTEM DESIGN BLUEPRINT**

Dokumen ini bersifat logical/system-level. Detail implementasi mengikuti
dokumen blueprint terkait dan tidak mengikat OHTATS pada vendor, database
engine, cloud provider, atau AI provider tertentu.

Dokumen terkait utama:

- `docs/blueprint/01_VISION.md`
- `docs/blueprint/ARCHITECTURE.md`
- `docs/blueprint/MODULE_SPECIFICATION.md`
- `docs/blueprint/DATABASE_DESIGN.md`
- `docs/blueprint/ERD.md`
- `docs/blueprint/MULTI_PLATFORM.md`
- `docs/blueprint/TRADING_ENGINE.md`
- `docs/blueprint/RISK_MANAGEMENT.md`
- `docs/blueprint/AI_ARCHITECTURE.md`
- `docs/blueprint/BACKTEST_ENGINE.md`
- `docs/blueprint/COPY_TRADING.md`

---

# 1. System Purpose

OHTATS adalah platform modular untuk menyediakan fasilitas analisis,
strategi, risk management, trading, backtest, AI integration, copy trading,
workflow automation, plugin, monitoring, reporting, licensing, dan
integrasi platform trading.

OHTATS harus:

- mendukung MT4;
- mendukung MT5;
- mendukung TradingView;
- mendukung multi-broker;
- mendukung multi-account;
- mendukung multi-AI-provider;
- mendukung backtest dan reproducible testing;
- mendukung copy trading;
- mendukung workflow automation;
- mendukung plugin dan extension;
- mendukung dashboard dan client interface;
- dapat diperluas ke cloud/deployment model di masa depan.

MT4, MT5, TradingView, broker, AI provider, dan external service tidak
menjadi core master entity yang terpisah. Mereka direpresentasikan melalui
model platform, broker, connection, provider, dan adapter/connector.

---

# 2. Design Principles

OHTATS mengikuti prinsip:

1. Modular
2. Extensible
3. Scalable
4. Secure
5. Auditable
6. Event-driven
7. API-first
8. Plugin-based
9. Provider-agnostic
10. Platform-agnostic
11. Risk-first
12. Configuration-driven
13. Reproducible
14. Backward-compatible
15. Database-vendor-neutral

---

# 3. System Boundary

```text
+--------------------------------------------------------------+
|                         OHTATS PLATFORM                      |
|                                                              |
|  Client / UI                                                 |
|      |                                                       |
|      v                                                       |
|  API / Application Layer                                     |
|      |                                                       |
|      v                                                       |
|  Core Orchestration                                           |
|      |                                                       |
|      +---- AI                                                 |
|      +---- Strategy                                            |
|      +---- Risk                                                |
|      +---- Trading                                             |
|      +---- Market Data                                         |
|      +---- Backtest                                            |
|      +---- Workflow                                            |
|      +---- Copy Trading                                        |
|      +---- Plugin                                              |
|      +---- Notification                                        |
|      +---- Reporting                                           |
|      +---- Security / Audit                                    |
|      +---- Licensing / Subscription                            |
|      +---- Operations                                          |
|      |                                                        |
|      v                                                        |
|  Connector / Integration Layer                               |
|      |                                                        |
+------+--------------------------------------------------------+
       |
       +---- MT4
       +---- MT5
       +---- TradingView
       +---- Broker APIs
       +---- Market Data Providers
       +---- AI Providers
       +---- External Services
```

External systems remain outside the OHTATS core boundary. Connector and
integration layers isolate external protocols and vendor-specific behavior.

---

# 4. Core System Layers

## 4.1 Client & Interface Layer

Menyediakan antarmuka untuk pengguna dan sistem eksternal.

Contoh:

- Web dashboard
- Desktop interface
- Mobile interface
- API clients
- Administrative interface

Layer ini tidak boleh menjalankan broker command secara langsung.

---

## 4.2 API & Application Layer

Menjadi entry point aplikasi untuk:

- authentication;
- authorization;
- configuration;
- strategy management;
- trading requests;
- AI requests;
- backtest requests;
- workflow requests;
- copy trading management;
- reporting;
- subscription/licensing;
- operational administration.

Semua request harus melewati authorization, validation, dan policy yang
sesuai.

---

## 4.3 Core Orchestration Layer

Core Orchestration adalah pusat koordinasi sistem.

Tanggung jawab:

- lifecycle aplikasi;
- routing command;
- event coordination;
- module coordination;
- workflow triggering;
- policy enforcement;
- transaction/process coordination;
- failure handling;
- idempotency coordination.

Core Orchestration tidak menggantikan domain engine dan tidak boleh
melewati risk/trading controls.

---

## 4.4 Domain Services Layer

Domain services berisi engine/manager yang menjalankan capability utama:

- AI Manager
- Strategy Manager
- Risk Manager
- Trading Engine
- Market Data Manager
- Backtest Engine
- Copy Trading Engine
- Workflow Engine
- Plugin Manager
- Notification Manager
- Reporting Manager
- Security & Audit Manager
- Licensing & Subscription Manager
- Operations Manager

Setiap domain memiliki tanggung jawab jelas dan tidak membuat duplicate
master entity.

---

## 4.5 Connector & Integration Layer

Layer ini mengisolasi komunikasi dengan:

- MT4;
- MT5;
- TradingView;
- broker APIs;
- market data providers;
- AI providers;
- notification providers;
- external integrations.

Connector menerjemahkan model internal OHTATS ke protocol/vendor-specific
model dan sebaliknya.

---

## 4.6 Persistence & Data Layer

Persistence layer menangani:

- transactional database;
- market data storage;
- backtest data;
- audit/event records;
- operational records;
- backup/recovery;
- retention.

Struktur persistent entity mengikuti `DATABASE_DESIGN.md` dan `ERD.md`.

---

# 5. Core Components

## 5.1 Core Orchestration

Mengatur lifecycle, command routing, event coordination, idempotency,
dan koordinasi antar domain.

Core tidak boleh menjadi jalur bypass terhadap risk, security, atau audit.

## 5.2 AI Manager

Mengelola:

- AI providers;
- AI models;
- provider-model mapping;
- AI sessions;
- AI messages;
- AI requests/responses;
- AI analyses;
- AI decisions;
- AI usage;
- prompt templates dan versions.

AI provider/model bersifat interchangeable.

AI output adalah input keputusan, bukan broker command langsung.

## 5.3 Strategy Manager

Mengelola:

- strategy identity;
- strategy versions;
- strategy parameters;
- strategy deployments;
- lifecycle strategy;
- validation;
- publication;
- reproducibility.

Published executable version bersifat immutable.

## 5.4 Risk Manager

Mengelola:

- risk policies;
- risk rules;
- position sizing;
- exposure limits;
- daily loss limits;
- drawdown controls;
- validation;
- risk events;
- trading halt/deny conditions.

Risk Manager wajib menjadi gate sebelum executable trading action.

## 5.5 Trading Engine

Mengelola lifecycle trading:

```text
trading_request
      |
      v
order
      |
      v
order_event / order_execution
      |
      v
deal
      |
      v
position
      |
      v
position_event
```

Aturan:

- satu order dapat memiliki banyak executions;
- satu execution dapat menghasilkan deal sesuai model connector;
- position dapat dipengaruhi banyak deal;
- tidak ada asumsi satu order = satu position;
- hedging dan netting didukung melalui account/connector/position logic.

## 5.6 Market Data Manager

Mengelola:

- canonical instruments;
- broker symbols;
- symbol mappings;
- market data sources;
- datasets;
- bars;
- ticks;
- ingestion;
- normalization;
- validation;
- versioning;
- retention.

`instruments` adalah canonical instrument.

`broker_symbols` menyimpan representasi broker/platform-specific.

## 5.7 Backtest Engine

Mengelola:

- backtest definitions;
- backtest runs;
- strategy version;
- market-data dataset version;
- simulated trades;
- metrics;
- reproducibility;
- result reporting.

Backtest data dipisahkan dari live trading data.

## 5.8 Connector Manager

Mengelola:

- broker connections;
- platform adapters;
- account connectivity;
- command translation;
- execution responses;
- connection health;
- reconnect;
- capability detection.

Model hubungan utama:

```text
brokers
   |
broker_platforms
   |
platforms
   |
connections
   |
trading_accounts
```

Connector tidak boleh menyimpan credential plaintext di business tables.

## 5.9 Workflow Engine

Mengelola:

- workflow identity;
- workflow versions;
- workflow steps;
- workflow executions;
- execution steps;
- retries;
- state transitions;
- failure handling.

Workflow dapat mengorkestrasi domain services tetapi tidak boleh bypass
security, risk, trading, atau audit controls.

## 5.10 Copy Trading Engine

Mengelola:

- copy trade groups;
- masters;
- followers;
- copy rules;
- symbol mappings;
- copy executions.

Copy trading menggunakan normal trading/risk pipeline.

```text
Master Event
     |
Copy Mapping
     |
Risk Validation
     |
Trading Request
     |
Normal Trading Pipeline
```

Tidak boleh dibuat jalur eksekusi broker khusus yang melewati risk controls.

## 5.11 Plugin Manager

Mengelola:

- plugin identity;
- plugin versions;
- dependencies;
- installations;
- compatibility;
- activation/deactivation;
- lifecycle;
- permissions/capabilities.

Plugin tidak boleh memperoleh hak sistem lebih tinggi dari capability
yang diberikan.

## 5.12 Notification Manager

Mengelola:

- notification creation;
- delivery;
- retry;
- delivery status;
- provider integration.

Provider dapat mencakup dashboard, email, Telegram, Discord, WhatsApp,
atau provider lain sesuai konfigurasi dan ketersediaan.

## 5.13 Reporting Manager

Menghasilkan:

- trading reports;
- performance reports;
- risk reports;
- backtest reports;
- AI usage reports;
- operational reports;
- audit-oriented reports.

Reporting membaca data yang telah tervalidasi dan tidak mengubah historical
financial records.

## 5.14 Security & Audit Manager

Mengelola:

- authentication;
- authorization;
- API keys;
- security events;
- audit logs;
- access policy;
- sensitive operation logging.

Audit dan security events harus append-only sesuai aturan database.

## 5.15 Licensing & Subscription Manager

Mengelola:

- subscription plans;
- plan versions;
- subscriptions;
- licenses;
- license entitlements;
- entitlement validation;
- expiration;
- access control.

Akses fasilitas dapat dibatasi berdasarkan entitlement tanpa mencampurkan
license state ke domain trading master.

## 5.16 Operations Manager

Mengelola:

- system settings;
- feature flags;
- jobs;
- job executions;
- API usage;
- backups;
- system events;
- operational health.

Operational transient state seperti cache, queue state, atau websocket
state tidak wajib menjadi persistent master table.

---

# 6. Canonical Identity Model

OHTATS menggunakan canonical identity untuk menghindari duplicate master.

## 6.1 Broker & Platform

```text
brokers
   |
broker_platforms
   |
platforms
```

Broker/platform capability tidak dibuat sebagai master terpisah untuk MT4,
MT5, atau TradingView.

## 6.2 Instrument

```text
instrument_types
   |
instruments
   |
broker_symbols
   |
symbol_mappings
```

`instruments` adalah canonical.

`broker_symbols` adalah broker/platform representation.

## 6.3 Strategy

```text
strategies
   |
strategy_versions
   |
strategy_parameters
   |
strategy_deployments
```

Identity berbeda dari executable immutable version.

## 6.4 AI

```text
ai_providers
   |
ai_provider_models
   |
ai_models
```

Provider dan model dipisahkan sehingga model dapat berkembang tanpa
mengubah identity provider.

---

# 7. Trading Control Pipeline

Seluruh executable trading action harus mengikuti pipeline:

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
             Risk Evaluation
                    |
          +---------+---------+
          |                   |
        Reject              Approve
          |                   |
          v                   v
       Audit              Order Creation
                              |
                              v
                         Connector
                              |
                              v
                       Broker/Platform
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

Tidak ada domain yang boleh membuat broker command langsung tanpa melalui
kontrol yang diwajibkan.

---

# 8. AI Decision Boundary

AI dapat:

- menganalisis market data;
- menganalisis news/input;
- mengevaluasi strategy;
- memberikan recommendation;
- menghasilkan structured decision;
- meminta simulasi/backtest;
- mengusulkan trading action.

AI tidak boleh:

- mengakses broker command secara langsung;
- melewati risk manager;
- melewati authorization;
- mengubah immutable historical records;
- menjadi sumber tunggal keputusan tanpa policy yang diwajibkan.

Boundary:

```text
AI Request
   |
AI Response
   |
AI Analysis
   |
AI Decision
   |
Strategy / Policy Validation
   |
Risk Evaluation
   |
Trading Pipeline
```

---

# 9. Backtest Boundary

Backtest harus terisolasi dari live execution.

```text
Strategy Version
       |
Market Data Dataset Version
       |
Backtest Run
       |
Simulated Trades
       |
Metrics
       |
Report
```

Backtest tidak boleh mengirim order live kecuali melalui mekanisme
eksplisit yang terpisah dan tervalidasi.

---

# 10. Copy Trading Boundary

Copy trading mengambil event dari master account/group dan mengubahnya
menjadi request untuk follower.

```text
Master
  |
Master Event
  |
Copy Rule
  |
Symbol Mapping
  |
Follower Risk Policy
  |
Trading Request
  |
Normal Trading Pipeline
```

Copy trading tidak memiliki execution path yang menghindari risk controls.

---

# 11. Event & Audit Model

Event digunakan untuk:

- lifecycle;
- integration;
- asynchronous processing;
- monitoring;
- workflow triggering;
- audit support.

Historical financial state tidak boleh bergantung hanya pada ephemeral
events.

Critical historical records harus memiliki persistent representation
sesuai database rules.

Audit harus mencatat operasi kritis seperti:

- authentication/security;
- configuration changes;
- strategy publication/deployment;
- risk changes;
- trading requests;
- order lifecycle;
- AI decisions yang relevan;
- copy trading actions;
- licensing changes;
- administrative actions.

---

# 12. Security Boundary

Security berlaku di seluruh layer.

```text
Identity
   |
Authentication
   |
Authorization
   |
Policy
   |
Capability
   |
Domain Action
   |
Audit
```

Credential/secret:

- tidak disimpan plaintext di business tables;
- direpresentasikan melalui secret reference;
- akses dikontrol;
- penggunaan dapat diaudit.

Least privilege dan capability-based access harus digunakan untuk plugin,
connector, AI provider, dan external integration.

---

# 13. Data Ownership Rules

Setiap domain memiliki ownership yang jelas.

- Identity → user/security domain
- Broker/platform → connectivity domain
- Instrument → market-data domain
- Trading account → trading/connectivity domain
- Strategy → strategy domain
- Risk → risk domain
- Backtest → backtest domain
- AI → AI domain
- Workflow → workflow domain
- Copy trading → copy-trading domain
- Plugin → plugin domain
- Subscription/license → licensing domain
- Notification → notification domain
- Operations → operations domain

Domain lain mengakses data melalui contract/service/event yang sesuai,
bukan membuat duplicate master.

---

# 14. Persistence Rules

Persistent data mengikuti `DATABASE_DESIGN.md`.

Aturan utama:

1. Semua persistent entity memiliki lifecycle.
2. PK/FK dan cardinality mengikuti database design.
3. Historical financial records mengikuti append-only rules.
4. Secrets menggunakan references.
5. Market data dapat diskalakan secara independen.
6. Backtest data terpisah dari live trading data.
7. Migration harus versioned.
8. Retention harus policy-driven.
9. Physical database vendor tidak ditentukan oleh system design.
10. Operational transient state tidak dipaksa menjadi persistent master.

---

# 15. Failure & Recovery Model

Setiap domain harus memiliki:

- timeout policy;
- retry policy;
- idempotency strategy;
- error classification;
- recovery behavior;
- audit trail.

Untuk connector/trading:

- command timeout tidak boleh dianggap otomatis sebagai failed execution;
- execution status harus dikonfirmasi melalui broker/platform;
- duplicate submission harus dicegah dengan idempotency/reference;
- reconnect harus aman;
- reconciliation harus tersedia.

Untuk AI:

- provider failure dapat dialihkan ke provider lain jika policy mengizinkan;
- failed AI request tidak boleh menjadi broker command;
- usage harus dapat dicatat.

---

# 16. Scalability Model

OHTATS harus dapat berkembang dari local deployment menuju deployment
terdistribusi.

Komponen yang dapat diskalakan independen:

- API/application;
- AI processing;
- market-data ingestion;
- backtest workers;
- workflow workers;
- notification workers;
- reporting workers;
- connector workers.

Database dan storage dapat dipisahkan berdasarkan workload tanpa mengubah
canonical identity model.

---

# 17. Deployment Model

OHTATS harus mendukung:

1. Local/single-machine deployment.
2. Dedicated server deployment.
3. Cloud deployment.
4. Hybrid deployment.

Deployment model tidak mengubah domain model.

External user-owned device, broker terminal, connector host, atau network
environment dapat memiliki tanggung jawab operasional masing-masing.

---

# 18. Observability

System harus menyediakan:

- structured logging;
- metrics;
- health checks;
- tracing bila diperlukan;
- audit;
- security events;
- job execution status;
- connector health;
- AI usage;
- trading lifecycle visibility.

Observability tidak boleh mengubah source-of-truth historical trading data.

---

# 19. Module Interaction Rules

1. AI tidak memanggil broker connector secara langsung.
2. Strategy tidak melewati Risk Manager.
3. Workflow tidak melewati security/risk/trading controls.
4. Copy trading menggunakan normal trading pipeline.
5. Backtest tidak menggunakan live execution path.
6. Connector tidak menentukan business policy.
7. Database layer tidak memiliki business decision authority.
8. Reporting tidak mengubah source records.
9. Plugin hanya menggunakan declared capabilities.
10. Notification delivery tidak boleh mengubah trading state.
11. Licensing controls access tetapi tidak menjadi pengganti authorization.
12. Audit tidak boleh menjadi editable business record.

---

# 20. Primary Domain Flow

```text
User / Client
     |
     v
Authentication & Authorization
     |
     v
Application/API
     |
     v
Core Orchestration
     |
     +-----------------------------+
     |                             |
     v                             v
Strategy / AI / Workflow      Market Data
     |                             |
     +-------------+---------------+
                   |
                   v
              Risk Manager
                   |
                   v
            Trading Request
                   |
                   v
                 Order
                   |
                   v
              Connector
                   |
                   v
           MT4 / MT5 / TV / Broker
                   |
                   v
         Execution / Deal / Position
                   |
                   v
          Event + Audit + Reporting
```

---

# 21. Database Alignment

SYSTEM_DESIGN wajib konsisten dengan database blueprint berikut:

- `brokers`, `platforms`, `broker_platforms`
- `connections`, `trading_accounts`
- `instrument_types`, `instruments`, `broker_symbols`, `symbol_mappings`
- `market_data_sources`, `market_data_datasets`, `market_data_bars`,
  `market_data_ticks`
- `trading_requests`, `orders`, `order_events`, `order_executions`, `deals`,
  `positions`, `position_events`
- `strategies`, `strategy_versions`, `strategy_parameters`,
  `strategy_deployments`
- `risk_policies`, `risk_rules`, `risk_events`
- `backtests`, `backtest_runs`, `backtest_trades`, `backtest_metrics`
- AI domain entities
- workflow domain entities
- copy-trading domain entities
- plugin domain entities
- licensing/subscription entities
- notification/integration entities
- operations entities

Tidak boleh diperkenalkan kembali:

- `trading_symbols` sebagai duplicate master;
- broker `platform` sebagai master column pengganti normalization;
- strategy `version` sebagai executable state;
- mandatory direct `order -> position`;
- plaintext credentials.

---

# 22. Extensibility Rules

Future extension harus menggunakan adapter/domain extension tanpa mengubah
canonical identity jika capability yang ada masih mencukupi.

Contoh extension:

- platform baru;
- broker baru;
- AI provider/model baru;
- market data provider baru;
- notification provider baru;
- plugin baru;
- execution venue baru.

Extension harus:

1. memiliki contract;
2. memiliki capability definition;
3. memiliki security boundary;
4. memiliki observability;
5. memiliki lifecycle;
6. tidak membuat duplicate master entity.

---

# 23. System Invariants

Invariants berikut wajib selalu berlaku:

1. AI tidak dapat bypass risk/trading pipeline.
2. Unauthorized actor tidak dapat melakukan privileged domain action.
3. Historical financial records tidak diedit secara destruktif.
4. Canonical instrument tidak digandakan untuk setiap broker.
5. Strategy identity tidak dicampur dengan executable version.
6. Copy trading tidak bypass risk controls.
7. Backtest tidak mengubah live trading state.
8. Secret tidak disimpan plaintext.
9. Connector/vendor behavior tidak menjadi business policy.
10. Deployment topology tidak mengubah domain identity.

---

# 24. Definition of Done

SYSTEM_DESIGN.md dianggap final apabila:

- seluruh domain utama OHTATS memiliki boundary;
- interaksi antar domain terdokumentasi;
- trading pipeline memiliki risk gate;
- AI boundary terdokumentasi;
- backtest boundary terdokumentasi;
- copy trading boundary terdokumentasi;
- connector/platform abstraction terdokumentasi;
- security dan audit boundary terdokumentasi;
- workflow dan plugin boundary terdokumentasi;
- licensing/subscription boundary terdokumentasi;
- persistence rules konsisten dengan DATABASE_DESIGN;
- relationship model konsisten dengan ERD;
- tidak ada duplicate master entity;
- desain tetap vendor-neutral;
- MT4, MT5, TradingView dapat diintegrasikan tanpa membuat master entity
  terpisah;
- future extension dapat dilakukan melalui adapter/domain extension.

---

# END OF SYSTEM_DESIGN.md
