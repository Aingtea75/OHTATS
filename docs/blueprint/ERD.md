# OHTATS - Entity Relationship Diagram (ERD)

> Dokumen ini mendefinisikan hubungan logical/high-level antar entity
> persisten OHTATS dan harus konsisten dengan `DATABASE_DESIGN.md`.

---

# Status

**FINAL ERD BLUEPRINT**

ERD ini merupakan representasi logical relationship.

Dokumen ini tidak mengikat OHTATS pada database engine, ORM, SQL dialect,
atau storage engine tertentu.

Detail PK, FK, datatype, index, constraint, lifecycle, retention,
migration, dan physical implementation mengikuti:

`docs/blueprint/DATABASE_DESIGN.md`

---

# 1. Identity & Security

```text
users
├── user_profiles
├── user_roles
│   └── roles
│       └── role_permissions
│           └── permissions
├── sessions
├── api_keys
├── security_events
└── audit_logs
```

---

# 2. Broker & Platform

```text
brokers
└── broker_platforms
    └── platforms

connections
└── broker_platforms

trading_accounts
└── connections
```

Broker dan platform dipisahkan agar satu broker dapat mendukung
lebih dari satu platform, termasuk MT4, MT5, dan platform/API lain.

---

# 3. Instrument & Market Data

```text
instrument_types
└── instruments
    ├── broker_symbols
    │   └── broker_platforms
    ├── symbol_mappings
    └── market_data_datasets
        ├── market_data_bars
        └── market_data_ticks

market_data_sources
└── market_data_datasets
```

`instruments` adalah canonical instrument.

`broker_symbols` menyimpan representasi symbol yang spesifik terhadap
broker/platform.

---

# 4. Trading

```text
trading_accounts
├── account_balance_snapshots
├── trading_requests
│   └── orders
│       ├── order_events
│       └── order_executions
│           └── deals
│               └── positions
│                   └── position_events
└── trading_journals
```

Trading lifecycle:

```text
trading_request
    ↓
order
    ↓
order_execution
    ↓
deal
    ↓
position
```

Satu order dapat memiliki banyak execution.

Satu position dapat dipengaruhi oleh banyak deal.

ERD tidak mengasumsikan hubungan satu-order-satu-position.

---

# 5. Strategy & Risk

```text
strategies
└── strategy_versions
    ├── strategy_parameters
    └── strategy_deployments

risk_policies
└── risk_rules
    └── risk_events
```

Strategy identity dipisahkan dari executable version.

Trading deployment menggunakan strategy version tertentu.

Risk policy dan risk rules menjadi kontrol risiko yang terpisah.

---

# 6. Backtest

```text
backtests
└── backtest_runs
    ├── strategy_versions
    ├── market_data_datasets
    ├── backtest_trades
    └── backtest_metrics
```

Backtest harus dapat direproduksi dengan referensi terhadap strategy
version dan market-data dataset version.

Data backtest dipisahkan dari data trading live.

---

# 7. AI

```text
ai_providers
└── ai_provider_models
    └── ai_models

ai_sessions
└── ai_messages

ai_requests
├── ai_responses
├── ai_analyses
├── ai_decisions
└── ai_usage_records

prompt_templates
└── prompt_versions
```

AI provider dan model dipisahkan agar OHTATS dapat menggunakan
berbagai AI provider/model secara modular.

`ai_decisions` tidak langsung menjadi broker command.

Keputusan AI harus melewati strategy, risk, trading, dan audit pipeline
sesuai aturan platform.

---

# 8. Workflow

```text
workflows
└── workflow_versions
    └── workflow_steps

workflow_executions
└── workflow_execution_steps
```

Workflow version dipisahkan dari workflow identity.

Execution menyimpan histori pelaksanaan workflow.

---

# 9. Copy Trading

```text
copy_trade_groups
├── copy_trade_masters
├── copy_trade_followers
├── copy_trade_rules
├── copy_trade_mappings
└── copy_trade_executions
```

Copy trading tidak membuat jalur trading terpisah dari risk/trading
pipeline.

Symbol mapping digunakan untuk menyesuaikan instrument/symbol antara
master dan follower.

---

# 10. Plugin

```text
plugins
└── plugin_versions
    ├── plugin_dependencies
    └── plugin_installations
```

Plugin identity dipisahkan dari immutable published version.

Installation merepresentasikan lifecycle plugin pada environment/user.

---

# 11. Licensing & Subscription

```text
subscription_plans
└── subscription_plan_versions
    └── subscriptions

subscriptions
└── licenses
    └── license_entitlements
```

Subscription plan dan versinya dipisahkan dari subscription aktif.

License entitlement menentukan fasilitas/akses yang diberikan.

---

# 12. Notification & Integration

```text
notifications
└── notification_deliveries

external_integrations
└── integration_credentials
```

Credential hanya berupa secret reference dan bukan plaintext secret.

---

# 13. Operations

```text
system_settings
feature_flags

jobs
└── job_executions

api_usage_records
backup_records
system_events
```

Operational runtime state seperti cache, queue, websocket state,
dan transient state tidak diwajibkan menjadi tabel database.

---

# 14. Cross-Domain Relationship

```text
users
├── trading_accounts
├── strategies
├── ai_sessions
├── backtests
├── workflows
├── copy_trade_groups
├── subscriptions
├── licenses
└── notifications

strategies
└── strategy_versions
    ├── strategy_deployments
    ├── trading_requests
    └── backtest_runs

trading_accounts
└── trading_requests
    └── orders
        └── order_executions
            └── deals
                └── positions

instruments
└── broker_symbols
    └── symbol_mappings

market_data_datasets
└── backtest_runs

ai_decisions
└── trading decision references

risk_policies
└── trading/deployment risk references
```

---

# 15. Design Rules

1. Tidak ada duplicate master untuk entity yang sama.
2. `instruments` adalah canonical instrument.
3. `broker_symbols` adalah broker/platform-specific symbol.
4. `strategies` adalah identity.
5. `strategy_versions` adalah executable immutable version.
6. Trading lifecycle menggunakan request → order → execution → deal → position.
7. Backtest menggunakan strategy version dan dataset version.
8. AI decision tidak boleh melewati risk/trading pipeline.
9. Copy trading menggunakan symbol mapping dan normal trading pipeline.
10. Secret tidak disimpan sebagai plaintext.
11. Historical financial records bersifat append-only sesuai aturan database.
12. Relationship detail, PK, FK, cardinality, constraint, dan index mengikuti
    `DATABASE_DESIGN.md`.

---

# 16. Final Consistency

ERD ini harus tetap konsisten dengan:

- `docs/blueprint/DATABASE_DESIGN.md`
- final table catalog sebanyak **86 tables**
- architecture blueprint OHTATS
- strategy versioning
- trading lifecycle
- backtest reproducibility
- AI safety boundary
- copy trading safety boundary
- audit and security policy

---

# END OF ERD.md
