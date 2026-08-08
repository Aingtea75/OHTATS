# DATABASE_DESIGN.md

# OHTATS Database Design --- FINAL

> Status: **FINAL DATABASE BLUEPRINT**
>
> Dokumen ini adalah rancangan database logical/physical-neutral OHTATS.
> Implementasi SQL, migration, ORM, dan storage engine harus mengikuti
> aturan dalam dokumen ini.
>
> Prinsip utama: **database transaction tidak boleh dipaksa menjadi
> tempat seluruh data real-time/high-volume**. Market data historis
> dapat menggunakan object/time-series storage dengan metadata dan
> versioning tetap direferensikan oleh database.

------------------------------------------------------------------------

# 1. Tujuan

Database OHTATS harus mendukung:

-   multi-user;
-   multi-broker;
-   multi-account;
-   MT4;
-   MT5;
-   TradingView;
-   broker/exchange API;
-   multi-AI provider/model;
-   strategy dan strategy versioning;
-   risk management;
-   live trading;
-   backtesting reproducible;
-   workflow automation;
-   copy trading;
-   plugin system;
-   notification;
-   licensing/subscription;
-   audit dan security;
-   API/MCP access;
-   scheduler/job;
-   backup/recovery;
-   extensibility.

Database adalah **source of record untuk state bisnis dan histori yang
memang harus dipersistenkan**, bukan source of record untuk setiap cache
atau stream real-time.

------------------------------------------------------------------------

# 2. Prinsip Desain

1.  Gunakan UUID untuk primary key entity bisnis.
2.  Gunakan BIGINT atau time-sortable identifier untuk data volume
    sangat tinggi bila dibutuhkan.
3.  Terapkan normalisasi minimal sampai 3NF untuk master/transactional
    data.
4.  Gunakan foreign key untuk hubungan yang benar-benar bersifat
    referensial.
5.  Jangan membuat foreign key ke entity yang tidak didefinisikan.
6.  Jangan menjadikan nama simbol broker sebagai canonical instrument.
7.  Jangan menyimpan secret/password/API key plaintext.
8.  Data historis finansial dan audit bersifat append-only.
9.  Entity konfigurasi dapat menggunakan soft delete bila diperlukan.
10. Jangan menggunakan soft delete untuk histori transaksi immutable.
11. Semua timestamp disimpan dalam UTC; timezone pengguna disimpan
    sebagai atribut profile/settings.
12. Monetary/price/quantity fields menggunakan DECIMAL, bukan floating
    point.
13. JSON hanya digunakan untuk metadata/configuration yang memang
    fleksibel, bukan untuk data relasional inti.
14. Setiap strategy yang dapat dieksekusi harus mempunyai immutable
    version.
15. Backtest harus menunjuk strategy version dan dataset version yang
    dapat direproduksi.
16. Broker, platform, instrument, dan broker-specific symbol dipisahkan.
17. Module tidak otomatis berarti table.
18. Cache, queue, websocket state, dan transient runtime state tidak
    wajib dipersistenkan.
19. Constraint dan index harus mendukung workload nyata, bukan dibuat
    sebanyak mungkin.
20. Migration harus backward-aware dan dapat diaudit.

------------------------------------------------------------------------

# 3. Konvensi

## 3.1 Naming

-   table: `snake_case`, plural.
-   column: `snake_case`.
-   primary key: `id`.
-   foreign key: `<entity>_id`.
-   timestamp: `created_at`, `updated_at`.
-   soft delete: `deleted_at`.
-   boolean: `is_*` atau `has_*`.
-   code yang menjadi identifier bisnis: `*_code`.
-   external identifier: `*_external_id` atau nama spesifik provider.
-   semua FK menunjuk ke `id` entity tujuan kecuali ada alasan kuat.

## 3.2 Status

Status harus didefinisikan per domain. Jangan memakai satu ENUM global
untuk seluruh tabel.

## 3.3 Audit columns

Entity mutable umumnya memiliki:

-   `created_at`
-   `updated_at`

Entity yang membutuhkan soft delete:

-   `deleted_at`

Event/historical record minimal memiliki:

-   `occurred_at`
-   `created_at`

------------------------------------------------------------------------

# 4. Domain Catalog

## Identity & Security

1.  `users`
2.  `user_profiles`
3.  `roles`
4.  `permissions`
5.  `user_roles`
6.  `role_permissions`
7.  `sessions`
8.  `api_keys`
9.  `security_events`
10. `audit_logs`

## Broker & Connectivity

11. `brokers`
12. `platforms`
13. `broker_platforms`
14. `connections`

## Instrument & Market Data

15. `instrument_types`
16. `instruments`
17. `broker_symbols`
18. `symbol_mappings`
19. `market_data_sources`
20. `market_data_datasets`
21. `market_data_bars`
22. `market_data_ticks`

## Trading

23. `trading_accounts`
24. `account_balance_snapshots`
25. `trading_requests`
26. `orders`
27. `order_events`
28. `order_executions`
29. `deals`
30. `positions`
31. `position_events`
32. `trading_journals`

## Strategy & Risk

33. `strategies`
34. `strategy_versions`
35. `strategy_parameters`
36. `strategy_deployments`
37. `risk_policies`
38. `risk_rules`
39. `risk_events`

## Backtest

40. `backtests`
41. `backtest_runs`
42. `backtest_trades`
43. `backtest_metrics`

## AI

44. `ai_providers`
45. `ai_models`
46. `ai_provider_models`
47. `ai_sessions`
48. `ai_messages`
49. `ai_requests`
50. `ai_responses`
51. `ai_analyses`
52. `ai_decisions`
53. `prompt_templates`
54. `prompt_versions`
55. `ai_usage_records`

## Workflow

56. `workflows`
57. `workflow_versions`
58. `workflow_steps`
59. `workflow_executions`
60. `workflow_execution_steps`

## Copy Trading

61. `copy_trade_groups`
62. `copy_trade_masters`
63. `copy_trade_followers`
64. `copy_trade_rules`
65. `copy_trade_mappings`
66. `copy_trade_executions`

## Plugin

67. `plugins`
68. `plugin_versions`
69. `plugin_dependencies`
70. `plugin_installations`

## Licensing

71. `subscription_plans`
72. `subscription_plan_versions`
73. `subscriptions`
74. `licenses`
75. `license_entitlements`

## Notification & Integration

76. `notifications`
77. `notification_deliveries`
78. `external_integrations`
79. `integration_credentials`

## Operations

80. `system_settings`
81. `feature_flags`
82. `jobs`
83. `job_executions`
84. `api_usage_records`
85. `backup_records`
86. `system_events`

------------------------------------------------------------------------

# 5. Identity & Security

## 5.1 users

Purpose: canonical OHTATS user identity.

Columns:

  Column              Type           Rules
  ------------------- -------------- ----------------------------
  id                  UUID           PK
  username            VARCHAR(100)   UNIQUE, NOT NULL
  email               VARCHAR(255)   UNIQUE, NOT NULL
  password_hash       VARCHAR(255)   nullable for external auth
  status              VARCHAR(30)    NOT NULL
  email_verified_at   DATETIME       nullable
  last_login_at       DATETIME       nullable
  created_at          DATETIME       NOT NULL
  updated_at          DATETIME       NOT NULL
  deleted_at          DATETIME       nullable

Never store plaintext password.

Indexes: PK(`id`), UNIQUE(`username`), UNIQUE(`email`), INDEX(`status`).

## 5.2 user_profiles

  Column         Type           Rules
  -------------- -------------- ------------------
  id             UUID           PK
  user_id        UUID           FK users, UNIQUE
  display_name   VARCHAR(150)   nullable
  first_name     VARCHAR(100)   nullable
  last_name      VARCHAR(100)   nullable
  timezone       VARCHAR(64)    nullable
  locale         VARCHAR(20)    nullable
  avatar_url     VARCHAR(500)   nullable
  created_at     DATETIME       NOT NULL
  updated_at     DATETIME       NOT NULL

## 5.3 roles

  Column           Type           Rules
  ---------------- -------------- ----------
  id               UUID           PK
  code             VARCHAR(80)    UNIQUE
  name             VARCHAR(120)   NOT NULL
  description      TEXT           nullable
  is_system_role   BOOLEAN        NOT NULL
  status           VARCHAR(30)    NOT NULL
  created_at       DATETIME       NOT NULL
  updated_at       DATETIME       NOT NULL

Examples: `SUPER_ADMIN`, `ADMINISTRATOR`, `TRADER`, `VIEWER`,
`DEVELOPER`.

## 5.4 permissions

Atomic permission such as `orders.read`, `orders.create`,
`orders.cancel`, `strategies.deploy`, `ai.use`, `licenses.manage`.

  Column        Type           Rules
  ------------- -------------- ----------
  id            UUID           PK
  code          VARCHAR(150)   UNIQUE
  name          VARCHAR(150)   NOT NULL
  resource      VARCHAR(100)   NOT NULL
  action        VARCHAR(100)   NOT NULL
  description   TEXT           nullable
  created_at    DATETIME       NOT NULL
  updated_at    DATETIME       NOT NULL

## 5.5 user_roles

  Column        Type       Rules
  ------------- ---------- --------------------
  user_id       UUID       FK users
  role_id       UUID       FK roles
  assigned_at   DATETIME   NOT NULL
  assigned_by   UUID       FK users, nullable
  expires_at    DATETIME   nullable

PK(`user_id`, `role_id`).

## 5.6 role_permissions

  Column          Type       Rules
  --------------- ---------- --------------------
  role_id         UUID       FK roles
  permission_id   UUID       FK permissions
  granted_at      DATETIME   NOT NULL
  granted_by      UUID       FK users, nullable

PK(`role_id`, `permission_id`).

## 5.7 sessions

  Column               Type           Rules
  -------------------- -------------- ----------
  id                   UUID           PK
  user_id              UUID           FK users
  token_hash           VARCHAR(255)   NOT NULL
  refresh_token_hash   VARCHAR(255)   nullable
  ip_address           VARCHAR(64)    nullable
  user_agent           TEXT           nullable
  device_id            VARCHAR(255)   nullable
  status               VARCHAR(30)    NOT NULL
  created_at           DATETIME       NOT NULL
  last_activity_at     DATETIME       NOT NULL
  expires_at           DATETIME       NOT NULL
  revoked_at           DATETIME       nullable

Never store session token plaintext.

## 5.8 api_keys

  Column         Type           Rules
  -------------- -------------- ----------
  id             UUID           PK
  user_id        UUID           FK users
  name           VARCHAR(120)   NOT NULL
  key_prefix     VARCHAR(32)    NOT NULL
  key_hash       VARCHAR(255)   NOT NULL
  status         VARCHAR(30)    NOT NULL
  last_used_at   DATETIME       nullable
  expires_at     DATETIME       nullable
  created_at     DATETIME       NOT NULL
  revoked_at     DATETIME       nullable

Never store the full API key.

## 5.9 security_events

Append-only security history.

  Column        Type           Rules
  ------------- -------------- -----------------------
  id            UUID           PK
  user_id       UUID           FK users, nullable
  session_id    UUID           FK sessions, nullable
  event_type    VARCHAR(100)   NOT NULL
  severity      VARCHAR(30)    NOT NULL
  source        VARCHAR(100)   NOT NULL
  ip_address    VARCHAR(64)    nullable
  user_agent    TEXT           nullable
  success       BOOLEAN        NOT NULL
  reason_code   VARCHAR(100)   nullable
  metadata      JSON           nullable
  occurred_at   DATETIME       NOT NULL
  created_at    DATETIME       NOT NULL

No normal UPDATE/DELETE.

## 5.10 audit_logs

Append-only application audit.

  Column          Type           Rules
  --------------- -------------- -----------------------
  id              UUID           PK
  actor_user_id   UUID           FK users, nullable
  session_id      UUID           FK sessions, nullable
  request_id      VARCHAR(100)   nullable
  action          VARCHAR(100)   NOT NULL
  entity_type     VARCHAR(100)   NOT NULL
  entity_id       VARCHAR(100)   nullable
  result          VARCHAR(30)    NOT NULL
  source          VARCHAR(100)   NOT NULL
  ip_address      VARCHAR(64)    nullable
  before_data     JSON           nullable
  after_data      JSON           nullable
  metadata        JSON           nullable
  occurred_at     DATETIME       NOT NULL
  created_at      DATETIME       NOT NULL

Audit records are append-only.

------------------------------------------------------------------------

# 6. Broker & Platform

## 6.1 brokers

A broker/exchange/provider is not the same thing as a trading platform.

  Column         Type           Rules
  -------------- -------------- ----------
  id             UUID           PK
  code           VARCHAR(50)    UNIQUE
  name           VARCHAR(150)   NOT NULL
  legal_name     VARCHAR(200)   nullable
  broker_type    VARCHAR(50)    NOT NULL
  country_code   VARCHAR(10)    nullable
  website        VARCHAR(500)   nullable
  status         VARCHAR(30)    NOT NULL
  description    TEXT           nullable
  created_at     DATETIME       NOT NULL
  updated_at     DATETIME       NOT NULL
  deleted_at     DATETIME       nullable

Do not store `platform` as an ENUM in this table.

## 6.2 platforms

Examples: MT4, MT5, TradingView, REST API, FIX, exchange API.

  Column       Type           Rules
  ------------ -------------- ----------
  id           UUID           PK
  code         VARCHAR(50)    UNIQUE
  name         VARCHAR(100)   NOT NULL
  category     VARCHAR(50)    NOT NULL
  version      VARCHAR(50)    nullable
  status       VARCHAR(30)    NOT NULL
  created_at   DATETIME       NOT NULL
  updated_at   DATETIME       NOT NULL

## 6.3 broker_platforms

Maps broker capability to platform.

  Column                Type           Rules
  --------------------- -------------- --------------
  id                    UUID           PK
  broker_id             UUID           FK brokers
  platform_id           UUID           FK platforms
  server_name           VARCHAR(150)   nullable
  api_supported         BOOLEAN        NOT NULL
  websocket_supported   BOOLEAN        NOT NULL
  plugin_required       BOOLEAN        NOT NULL
  api_version           VARCHAR(50)    nullable
  status                VARCHAR(30)    NOT NULL
  created_at            DATETIME       NOT NULL
  updated_at            DATETIME       NOT NULL

UNIQUE(`broker_id`, `platform_id`, `server_name`).

## 6.4 connections

Stores connection metadata only. Secret material lives in a
secret-management mechanism.

  Column               Type           Rules
  -------------------- -------------- ---------------------
  id                   UUID           PK
  user_id              UUID           FK users, nullable
  broker_platform_id   UUID           FK broker_platforms
  connection_name      VARCHAR(150)   NOT NULL
  connection_type      VARCHAR(50)    NOT NULL
  secret_ref           VARCHAR(500)   nullable
  endpoint             VARCHAR(500)   nullable
  status               VARCHAR(30)    NOT NULL
  last_connected_at    DATETIME       nullable
  last_error_at        DATETIME       nullable
  last_error_code      VARCHAR(100)   nullable
  created_at           DATETIME       NOT NULL
  updated_at           DATETIME       NOT NULL
  deleted_at           DATETIME       nullable

------------------------------------------------------------------------

# 7. Instrument & Market Data

## 7.1 instrument_types

Examples: FOREX, CRYPTO, STOCK, FUTURES, CFD, INDEX, COMMODITY.

  Column        Type           Rules
  ------------- -------------- ----------
  id            UUID           PK
  code          VARCHAR(50)    UNIQUE
  name          VARCHAR(100)   NOT NULL
  description   TEXT           nullable
  status        VARCHAR(30)    NOT NULL
  created_at    DATETIME       NOT NULL
  updated_at    DATETIME       NOT NULL

## 7.2 instruments

Canonical instrument independent of broker symbol naming.

  Column               Type           Rules
  -------------------- -------------- ---------------------
  id                   UUID           PK
  instrument_type_id   UUID           FK instrument_types
  canonical_code       VARCHAR(100)   UNIQUE
  name                 VARCHAR(150)   NOT NULL
  base_currency        VARCHAR(20)    nullable
  quote_currency       VARCHAR(20)    nullable
  status               VARCHAR(30)    NOT NULL
  created_at           DATETIME       NOT NULL
  updated_at           DATETIME       NOT NULL
  deleted_at           DATETIME       nullable

## 7.3 broker_symbols

Broker-specific representation and trading rules.

  Column               Type             Rules
  -------------------- ---------------- ---------------------
  id                   UUID             PK
  broker_platform_id   UUID             FK broker_platforms
  instrument_id        UUID             FK instruments
  symbol_code          VARCHAR(100)     NOT NULL
  symbol_name          VARCHAR(150)     nullable
  digits               INTEGER          NOT NULL
  tick_size            DECIMAL(24,12)   NOT NULL
  price_step           DECIMAL(24,12)   nullable
  contract_size        DECIMAL(24,8)    nullable
  minimum_quantity     DECIMAL(24,12)   NOT NULL
  maximum_quantity     DECIMAL(24,12)   nullable
  quantity_step        DECIMAL(24,12)   NOT NULL
  currency             VARCHAR(20)      nullable
  trading_session      JSON             nullable
  status               VARCHAR(30)      NOT NULL
  last_synced_at       DATETIME         nullable
  created_at           DATETIME         NOT NULL
  updated_at           DATETIME         NOT NULL
  deleted_at           DATETIME         nullable

UNIQUE(`broker_platform_id`, `symbol_code`).

## 7.4 symbol_mappings

Maps external representations to canonical instruments.

  Column              Type           Rules
  ------------------- -------------- --------------------
  id                  UUID           PK
  instrument_id       UUID           FK instruments
  source_type         VARCHAR(50)    NOT NULL
  source_identifier   VARCHAR(150)   nullable
  source_symbol       VARCHAR(150)   NOT NULL
  mapping_type        VARCHAR(30)    NOT NULL
  confidence_score    DECIMAL(5,2)   nullable
  status              VARCHAR(30)    NOT NULL
  verified_by         UUID           FK users, nullable
  verified_at         DATETIME       nullable
  created_at          DATETIME       NOT NULL
  updated_at          DATETIME       NOT NULL

## 7.5 market_data_sources

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  code            VARCHAR(80)    UNIQUE
  name            VARCHAR(150)   NOT NULL
  source_type     VARCHAR(50)    NOT NULL
  provider_name   VARCHAR(150)   nullable
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 7.6 market_data_datasets

Metadata and immutable identity for a historical dataset.

  Column            Type            Rules
  ----------------- --------------- ------------------------
  id                UUID            PK
  source_id         UUID            FK market_data_sources
  instrument_id     UUID            FK instruments
  dataset_version   VARCHAR(50)     NOT NULL
  timeframe         VARCHAR(20)     nullable for tick
  dataset_name      VARCHAR(200)    NOT NULL
  start_time        DATETIME        NOT NULL
  end_time          DATETIME        NOT NULL
  timezone          VARCHAR(64)     NOT NULL
  data_format       VARCHAR(50)     NOT NULL
  storage_uri       VARCHAR(1000)   NOT NULL
  row_count         BIGINT          nullable
  checksum          VARCHAR(128)    nullable
  status            VARCHAR(30)     NOT NULL
  created_at        DATETIME        NOT NULL
  updated_at        DATETIME        NOT NULL

Published datasets must be immutable. A corrected dataset receives a new
version.

## 7.7 market_data_bars

Logical candle schema. Physical storage may be a
time-series/object/columnar system.

  Column          Type             Rules
  --------------- ---------------- -------------------------
  id              BIGINT           PK or time-sortable ID
  dataset_id      UUID             FK market_data_datasets
  instrument_id   UUID             FK instruments
  timeframe       VARCHAR(20)      NOT NULL
  open_time       DATETIME         NOT NULL
  close_time      DATETIME         nullable
  open_price      DECIMAL(24,12)   NOT NULL
  high_price      DECIMAL(24,12)   NOT NULL
  low_price       DECIMAL(24,12)   NOT NULL
  close_price     DECIMAL(24,12)   NOT NULL
  volume          DECIMAL(24,12)   nullable
  tick_volume     BIGINT           nullable
  spread          DECIMAL(24,12)   nullable
  created_at      DATETIME         NOT NULL

UNIQUE(`dataset_id`, `open_time`).

## 7.8 market_data_ticks

Logical tick schema. High-volume physical storage should not be assumed
to be the transactional database.

  Column            Type             Rules
  ----------------- ---------------- -------------------------
  id                BIGINT           PK/time-sortable
  dataset_id        UUID             FK market_data_datasets
  instrument_id     UUID             FK instruments
  event_time        DATETIME         NOT NULL
  bid               DECIMAL(24,12)   nullable
  ask               DECIMAL(24,12)   nullable
  last_price        DECIMAL(24,12)   nullable
  bid_volume        DECIMAL(24,12)   nullable
  ask_volume        DECIMAL(24,12)   nullable
  last_volume       DECIMAL(24,12)   nullable
  source_sequence   BIGINT           nullable
  created_at        DATETIME         NOT NULL

------------------------------------------------------------------------

# 8. Trading Accounts

## 8.1 trading_accounts

  Column                Type            Rules
  --------------------- --------------- ---------------------
  id                    UUID            PK
  user_id               UUID            FK users
  connection_id         UUID            FK connections
  broker_id             UUID            FK brokers
  broker_platform_id    UUID            FK broker_platforms
  account_external_id   VARCHAR(150)    NOT NULL
  account_name          VARCHAR(150)    nullable
  account_type          VARCHAR(30)     NOT NULL
  account_mode          VARCHAR(30)     nullable
  currency              VARCHAR(20)     NOT NULL
  leverage              DECIMAL(12,4)   nullable
  status                VARCHAR(30)     NOT NULL
  is_default            BOOLEAN         NOT NULL
  created_at            DATETIME        NOT NULL
  updated_at            DATETIME        NOT NULL
  deleted_at            DATETIME        nullable

UNIQUE(`broker_platform_id`, `account_external_id`).

Do not use `balance`, `equity`, and margin as the authoritative current
state without timestamped synchronization. Current account state may be
cached; history belongs in snapshots/events.

## 8.2 account_balance_snapshots

  Column          Type            Rules
  --------------- --------------- ---------------------
  id              UUID            PK
  account_id      UUID            FK trading_accounts
  snapshot_time   DATETIME        NOT NULL
  balance         DECIMAL(24,8)   NOT NULL
  equity          DECIMAL(24,8)   NOT NULL
  margin          DECIMAL(24,8)   nullable
  free_margin     DECIMAL(24,8)   nullable
  margin_level    DECIMAL(24,8)   nullable
  currency        VARCHAR(20)     NOT NULL
  source          VARCHAR(50)     NOT NULL
  created_at      DATETIME        NOT NULL

Index(`account_id`, `snapshot_time`).

------------------------------------------------------------------------

# 9. Trading Lifecycle

Canonical lifecycle:

`trading_request -> order -> order_execution -> deal -> position`

Do not force every order to map directly to one position. One order can
have multiple executions, and position construction depends on
platform/account mode.

## 9.1 trading_requests

Represents an intent/request before broker order submission.

  Column                Type             Rules
  --------------------- ---------------- --------------------------------
  id                    UUID             PK
  account_id            UUID             FK trading_accounts
  strategy_version_id   UUID             FK strategy_versions, nullable
  instrument_id         UUID             FK instruments
  broker_symbol_id      UUID             FK broker_symbols
  request_type          VARCHAR(50)      NOT NULL
  side                  VARCHAR(20)      NOT NULL
  quantity              DECIMAL(24,12)   NOT NULL
  requested_price       DECIMAL(24,12)   nullable
  stop_loss             DECIMAL(24,12)   nullable
  take_profit           DECIMAL(24,12)   nullable
  time_in_force         VARCHAR(30)      nullable
  source_type           VARCHAR(50)      NOT NULL
  source_id             VARCHAR(100)     nullable
  risk_check_status     VARCHAR(30)      NOT NULL
  status                VARCHAR(30)      NOT NULL
  idempotency_key       VARCHAR(150)     UNIQUE
  correlation_id        VARCHAR(100)     nullable
  created_at            DATETIME         NOT NULL
  updated_at            DATETIME         NOT NULL

## 9.2 orders

  Column                Type             Rules
  --------------------- ---------------- --------------------------------
  id                    UUID             PK
  trading_request_id    UUID             FK trading_requests, nullable
  account_id            UUID             FK trading_accounts
  strategy_version_id   UUID             FK strategy_versions, nullable
  instrument_id         UUID             FK instruments
  broker_symbol_id      UUID             FK broker_symbols
  broker_order_id       VARCHAR(150)     nullable
  side                  VARCHAR(20)      NOT NULL
  order_type            VARCHAR(30)      NOT NULL
  quantity              DECIMAL(24,12)   NOT NULL
  requested_price       DECIMAL(24,12)   nullable
  stop_loss             DECIMAL(24,12)   nullable
  take_profit           DECIMAL(24,12)   nullable
  time_in_force         VARCHAR(30)      nullable
  status                VARCHAR(30)      NOT NULL
  submitted_at          DATETIME         nullable
  accepted_at           DATETIME         nullable
  cancelled_at          DATETIME         nullable
  correlation_id        VARCHAR(100)     nullable
  created_at            DATETIME         NOT NULL
  updated_at            DATETIME         NOT NULL

No direct mandatory `position_id`.

## 9.3 order_events

Append-only state transition/event history.

  Column            Type           Rules
  ----------------- -------------- -----------
  id                UUID           PK
  order_id          UUID           FK orders
  event_type        VARCHAR(50)    NOT NULL
  event_time        DATETIME       NOT NULL
  broker_event_id   VARCHAR(150)   nullable
  status_from       VARCHAR(30)    nullable
  status_to         VARCHAR(30)    nullable
  payload           JSON           nullable
  created_at        DATETIME       NOT NULL

## 9.4 order_executions

An order can be partially filled multiple times.

  Column                Type             Rules
  --------------------- ---------------- -----------
  id                    UUID             PK
  order_id              UUID             FK orders
  broker_execution_id   VARCHAR(150)     nullable
  execution_time        DATETIME         NOT NULL
  quantity              DECIMAL(24,12)   NOT NULL
  price                 DECIMAL(24,12)   NOT NULL
  fee                   DECIMAL(24,12)   nullable
  fee_currency          VARCHAR(20)      nullable
  liquidity_type        VARCHAR(30)      nullable
  created_at            DATETIME         NOT NULL

## 9.5 deals

Canonical executed transaction/fill record.

  Column             Type             Rules
  ------------------ ---------------- ------------------------
  id                 UUID             PK
  account_id         UUID             FK trading_accounts
  order_id           UUID             FK orders, nullable
  execution_id       UUID             FK order_executions
  position_id        UUID             FK positions, nullable
  instrument_id      UUID             FK instruments
  broker_symbol_id   UUID             FK broker_symbols
  broker_deal_id     VARCHAR(150)     nullable
  deal_type          VARCHAR(30)      NOT NULL
  side               VARCHAR(20)      NOT NULL
  quantity           DECIMAL(24,12)   NOT NULL
  price              DECIMAL(24,12)   NOT NULL
  fee                DECIMAL(24,12)   nullable
  swap               DECIMAL(24,12)   nullable
  realized_pnl       DECIMAL(24,12)   nullable
  currency           VARCHAR(20)      nullable
  executed_at        DATETIME         NOT NULL
  created_at         DATETIME         NOT NULL

Deals are append-only.

## 9.6 positions

Represents the aggregate position state under the account/platform
model.

  Column                 Type             Rules
  ---------------------- ---------------- --------------------------------
  id                     UUID             PK
  account_id             UUID             FK trading_accounts
  instrument_id          UUID             FK instruments
  broker_symbol_id       UUID             FK broker_symbols
  strategy_version_id    UUID             FK strategy_versions, nullable
  external_position_id   VARCHAR(150)     nullable
  side                   VARCHAR(20)      NOT NULL
  quantity               DECIMAL(24,12)   NOT NULL
  average_entry_price    DECIMAL(24,12)   NOT NULL
  current_price          DECIMAL(24,12)   nullable
  stop_loss              DECIMAL(24,12)   nullable
  take_profit            DECIMAL(24,12)   nullable
  realized_pnl           DECIMAL(24,12)   nullable
  unrealized_pnl         DECIMAL(24,12)   nullable
  swap                   DECIMAL(24,12)   nullable
  commission             DECIMAL(24,12)   nullable
  status                 VARCHAR(30)      NOT NULL
  opened_at              DATETIME         NOT NULL
  closed_at              DATETIME         nullable
  created_at             DATETIME         NOT NULL
  updated_at             DATETIME         NOT NULL

Uniqueness of external position ID must be scoped to account/platform,
not globally.

## 9.7 position_events

Append-only position lifecycle.

  Column           Type             Rules
  ---------------- ---------------- --------------
  id               UUID             PK
  position_id      UUID             FK positions
  event_type       VARCHAR(50)      NOT NULL
  event_time       DATETIME         NOT NULL
  quantity_delta   DECIMAL(24,12)   nullable
  price            DECIMAL(24,12)   nullable
  pnl_delta        DECIMAL(24,12)   nullable
  payload          JSON             nullable
  created_at       DATETIME         NOT NULL

## 9.8 trading_journals

Human/system explanation and trading notes.

  Column                Type           Rules
  --------------------- -------------- --------------------------------
  id                    UUID           PK
  user_id               UUID           FK users
  account_id            UUID           FK trading_accounts, nullable
  strategy_version_id   UUID           FK strategy_versions, nullable
  position_id           UUID           FK positions, nullable
  journal_type          VARCHAR(50)    NOT NULL
  title                 VARCHAR(200)   nullable
  content               TEXT           NOT NULL
  metadata              JSON           nullable
  created_at            DATETIME       NOT NULL
  updated_at            DATETIME       NOT NULL

------------------------------------------------------------------------

# 10. Strategy & Risk

## 10.1 strategies

Stable identity; mutable metadata only.

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  owner_user_id   UUID           FK users
  strategy_code   VARCHAR(80)    UNIQUE
  strategy_name   VARCHAR(150)   NOT NULL
  description     TEXT           nullable
  category        VARCHAR(100)   nullable
  strategy_type   VARCHAR(50)    NOT NULL
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL
  deleted_at      DATETIME       nullable

Do not put executable strategy version/configuration directly into this
identity table.

## 10.2 strategy_versions

Immutable executable definition.

  Column            Type           Rules
  ----------------- -------------- ---------------
  id                UUID           PK
  strategy_id       UUID           FK strategies
  version           VARCHAR(50)    NOT NULL
  release_status    VARCHAR(30)    NOT NULL
  logic_type        VARCHAR(50)    NOT NULL
  logic_reference   VARCHAR(500)   nullable
  configuration     JSON           nullable
  checksum          VARCHAR(128)   nullable
  created_by        UUID           FK users
  created_at        DATETIME       NOT NULL
  published_at      DATETIME       nullable
  deprecated_at     DATETIME       nullable

UNIQUE(`strategy_id`, `version`).

Published version is immutable.

## 10.3 strategy_parameters

  Column                Type             Rules
  --------------------- ---------------- ----------------------
  id                    UUID             PK
  strategy_version_id   UUID             FK strategy_versions
  parameter_code        VARCHAR(100)     NOT NULL
  value_type            VARCHAR(30)      NOT NULL
  value                 TEXT             NOT NULL
  min_value             DECIMAL(24,12)   nullable
  max_value             DECIMAL(24,12)   nullable
  step_value            DECIMAL(24,12)   nullable
  is_optimizable        BOOLEAN          NOT NULL
  created_at            DATETIME         NOT NULL
  updated_at            DATETIME         NOT NULL

UNIQUE(`strategy_version_id`, `parameter_code`).

## 10.4 strategy_deployments

Connects a strategy version to a live/backtest/copy-trading target.

  Column                Type          Rules
  --------------------- ------------- -------------------------------
  id                    UUID          PK
  strategy_version_id   UUID          FK strategy_versions
  account_id            UUID          FK trading_accounts, nullable
  deployment_type       VARCHAR(30)   NOT NULL
  configuration         JSON          nullable
  status                VARCHAR(30)   NOT NULL
  started_at            DATETIME      nullable
  stopped_at            DATETIME      nullable
  created_at            DATETIME      NOT NULL
  updated_at            DATETIME      NOT NULL

## 10.5 risk_policies

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  owner_user_id   UUID           FK users
  policy_code     VARCHAR(80)    UNIQUE
  name            VARCHAR(150)   NOT NULL
  description     TEXT           nullable
  scope_type      VARCHAR(30)    NOT NULL
  scope_id        UUID           nullable
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 10.6 risk_rules

Atomic rules under a policy.

  Column           Type           Rules
  ---------------- -------------- ------------------
  id               UUID           PK
  risk_policy_id   UUID           FK risk_policies
  rule_code        VARCHAR(100)   NOT NULL
  rule_type        VARCHAR(50)    NOT NULL
  configuration    JSON           NOT NULL
  priority         INTEGER        NOT NULL
  enabled          BOOLEAN        NOT NULL
  created_at       DATETIME       NOT NULL
  updated_at       DATETIME       NOT NULL

UNIQUE(`risk_policy_id`, `rule_code`).

## 10.7 risk_events

Append-only risk decisions/violations.

  Column               Type           Rules
  -------------------- -------------- -------------------------------
  id                   UUID           PK
  risk_policy_id       UUID           FK risk_policies, nullable
  risk_rule_id         UUID           FK risk_rules, nullable
  trading_request_id   UUID           FK trading_requests, nullable
  account_id           UUID           FK trading_accounts
  event_type           VARCHAR(50)    NOT NULL
  decision             VARCHAR(30)    NOT NULL
  reason_code          VARCHAR(100)   nullable
  details              JSON           nullable
  occurred_at          DATETIME       NOT NULL
  created_at           DATETIME       NOT NULL

------------------------------------------------------------------------

# 11. Backtest

## 11.1 backtests

Logical experiment definition.

  Column        Type           Rules
  ------------- -------------- ---------------
  id            UUID           PK
  user_id       UUID           FK users
  strategy_id   UUID           FK strategies
  name          VARCHAR(200)   NOT NULL
  description   TEXT           nullable
  created_at    DATETIME       NOT NULL
  updated_at    DATETIME       NOT NULL

## 11.2 backtest_runs

Reproducible execution.

  Column                Type           Rules
  --------------------- -------------- ----------------------------
  id                    UUID           PK
  backtest_id           UUID           FK backtests
  strategy_version_id   UUID           FK strategy_versions
  dataset_id            UUID           FK market_data_datasets
  risk_policy_id        UUID           FK risk_policies, nullable
  configuration         JSON           nullable
  engine_version        VARCHAR(80)    NOT NULL
  run_checksum          VARCHAR(128)   nullable
  status                VARCHAR(30)    NOT NULL
  started_at            DATETIME       nullable
  finished_at           DATETIME       nullable
  created_at            DATETIME       NOT NULL

## 11.3 backtest_trades

Synthetic/historical trade result, separate from live `deals`.

  Column            Type             Rules
  ----------------- ---------------- ------------------
  id                UUID             PK
  backtest_run_id   UUID             FK backtest_runs
  sequence_no       BIGINT           NOT NULL
  instrument_id     UUID             FK instruments
  side              VARCHAR(20)      NOT NULL
  quantity          DECIMAL(24,12)   NOT NULL
  entry_time        DATETIME         NOT NULL
  entry_price       DECIMAL(24,12)   NOT NULL
  exit_time         DATETIME         nullable
  exit_price        DECIMAL(24,12)   nullable
  pnl               DECIMAL(24,12)   nullable
  fees              DECIMAL(24,12)   nullable
  metadata          JSON             nullable
  created_at        DATETIME         NOT NULL

UNIQUE(`backtest_run_id`, `sequence_no`).

## 11.4 backtest_metrics

  Column            Type             Rules
  ----------------- ---------------- ------------------
  id                UUID             PK
  backtest_run_id   UUID             FK backtest_runs
  metric_code       VARCHAR(100)     NOT NULL
  metric_value      DECIMAL(30,12)   NOT NULL
  metric_unit       VARCHAR(30)      nullable
  created_at        DATETIME         NOT NULL

UNIQUE(`backtest_run_id`, `metric_code`).

Metrics may include Profit Factor, Win Rate, Drawdown, Sharpe, Recovery
Factor, Expectancy, etc.

------------------------------------------------------------------------

# 12. AI

## 12.1 ai_providers

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  code            VARCHAR(80)    UNIQUE
  name            VARCHAR(150)   NOT NULL
  provider_type   VARCHAR(50)    NOT NULL
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 12.2 ai_models

  Column          Type           Rules
  --------------- -------------- -----------------
  id              UUID           PK
  provider_id     UUID           FK ai_providers
  model_code      VARCHAR(150)   NOT NULL
  display_name    VARCHAR(150)   nullable
  capabilities    JSON           nullable
  context_limit   BIGINT         nullable
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

UNIQUE(`provider_id`, `model_code`).

## 12.3 ai_provider_models

Use only if OHTATS needs routing/configuration separate from model
master.

  Column          Type          Rules
  --------------- ------------- -----------------
  id              UUID          PK
  provider_id     UUID          FK ai_providers
  model_id        UUID          FK ai_models
  configuration   JSON          nullable
  priority        INTEGER       NOT NULL
  status          VARCHAR(30)   NOT NULL
  created_at      DATETIME      NOT NULL
  updated_at      DATETIME      NOT NULL

## 12.4 ai_sessions

  Column         Type          Rules
  -------------- ------------- -------------------------------
  id             UUID          PK
  user_id        UUID          FK users
  session_type   VARCHAR(50)   NOT NULL
  strategy_id    UUID          FK strategies, nullable
  account_id     UUID          FK trading_accounts, nullable
  status         VARCHAR(30)   NOT NULL
  created_at     DATETIME      NOT NULL
  updated_at     DATETIME      NOT NULL

## 12.5 ai_messages

  Column          Type          Rules
  --------------- ------------- ----------------
  id              UUID          PK
  ai_session_id   UUID          FK ai_sessions
  role            VARCHAR(30)   NOT NULL
  content         TEXT          NOT NULL
  sequence_no     BIGINT        NOT NULL
  metadata        JSON          nullable
  created_at      DATETIME      NOT NULL

UNIQUE(`ai_session_id`, `sequence_no`).

## 12.6 ai_requests

  Column              Type          Rules
  ------------------- ------------- ------------------------------
  id                  UUID          PK
  ai_session_id       UUID          FK ai_sessions
  provider_model_id   UUID          FK ai_provider_models
  prompt_version_id   UUID          FK prompt_versions, nullable
  request_type        VARCHAR(50)   NOT NULL
  input_payload       JSON          nullable
  status              VARCHAR(30)   NOT NULL
  requested_at        DATETIME      NOT NULL
  completed_at        DATETIME      nullable

## 12.7 ai_responses

  Column                 Type           Rules
  ---------------------- -------------- ----------------
  id                     UUID           PK
  ai_request_id          UUID           FK ai_requests
  provider_response_id   VARCHAR(200)   nullable
  output_text            TEXT           nullable
  structured_output      JSON           nullable
  finish_reason          VARCHAR(100)   nullable
  latency_ms             BIGINT         nullable
  created_at             DATETIME       NOT NULL

## 12.8 ai_analyses

Stores structured analysis produced by AI.

  Column             Type           Rules
  ------------------ -------------- --------------------------
  id                 UUID           PK
  ai_request_id      UUID           FK ai_requests
  instrument_id      UUID           FK instruments, nullable
  analysis_type      VARCHAR(50)    NOT NULL
  timeframe          VARCHAR(20)    nullable
  analysis_payload   JSON           NOT NULL
  confidence_score   DECIMAL(5,2)   nullable
  created_at         DATETIME       NOT NULL

## 12.9 ai_decisions

AI decisions are not automatically executable orders.

  Column                Type           Rules
  --------------------- -------------- --------------------------------
  id                    UUID           PK
  ai_request_id         UUID           FK ai_requests
  strategy_version_id   UUID           FK strategy_versions, nullable
  instrument_id         UUID           FK instruments, nullable
  decision_type         VARCHAR(50)    NOT NULL
  decision              VARCHAR(50)    NOT NULL
  rationale             TEXT           nullable
  confidence_score      DECIMAL(5,2)   nullable
  proposed_action       JSON           nullable
  execution_status      VARCHAR(30)    NOT NULL
  created_at            DATETIME       NOT NULL

Execution still requires the normal risk/trading pipeline.

## 12.10 prompt_templates

  Column        Type           Rules
  ------------- -------------- ----------
  id            UUID           PK
  code          VARCHAR(100)   UNIQUE
  name          VARCHAR(150)   NOT NULL
  description   TEXT           nullable
  status        VARCHAR(30)    NOT NULL
  created_at    DATETIME       NOT NULL
  updated_at    DATETIME       NOT NULL

## 12.11 prompt_versions

  Column               Type           Rules
  -------------------- -------------- ---------------------
  id                   UUID           PK
  prompt_template_id   UUID           FK prompt_templates
  version              VARCHAR(50)    NOT NULL
  content              TEXT           NOT NULL
  checksum             VARCHAR(128)   nullable
  status               VARCHAR(30)    NOT NULL
  created_by           UUID           FK users
  created_at           DATETIME       NOT NULL

UNIQUE(`prompt_template_id`, `version`).

## 12.12 ai_usage_records

  Column           Type             Rules
  ---------------- ---------------- -----------------
  id               UUID             PK
  ai_request_id    UUID             FK ai_requests
  provider_id      UUID             FK ai_providers
  model_id         UUID             FK ai_models
  input_tokens     BIGINT           nullable
  output_tokens    BIGINT           nullable
  total_tokens     BIGINT           nullable
  estimated_cost   DECIMAL(24,12)   nullable
  currency         VARCHAR(20)      nullable
  recorded_at      DATETIME         NOT NULL

------------------------------------------------------------------------

# 13. Workflow

## 13.1 workflows

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  owner_user_id   UUID           FK users
  workflow_code   VARCHAR(80)    UNIQUE
  name            VARCHAR(150)   NOT NULL
  description     TEXT           nullable
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL
  deleted_at      DATETIME       nullable

## 13.2 workflow_versions

  Column        Type           Rules
  ------------- -------------- --------------
  id            UUID           PK
  workflow_id   UUID           FK workflows
  version       VARCHAR(50)    NOT NULL
  definition    JSON           NOT NULL
  checksum      VARCHAR(128)   nullable
  status        VARCHAR(30)    NOT NULL
  created_by    UUID           FK users
  created_at    DATETIME       NOT NULL

UNIQUE(`workflow_id`, `version`).

## 13.3 workflow_steps

  Column                Type           Rules
  --------------------- -------------- ----------------------
  id                    UUID           PK
  workflow_version_id   UUID           FK workflow_versions
  step_code             VARCHAR(100)   NOT NULL
  step_type             VARCHAR(50)    NOT NULL
  sequence_no           INTEGER        NOT NULL
  configuration         JSON           nullable
  created_at            DATETIME       NOT NULL

UNIQUE(`workflow_version_id`, `step_code`).

## 13.4 workflow_executions

  Column                Type           Rules
  --------------------- -------------- ----------------------
  id                    UUID           PK
  workflow_version_id   UUID           FK workflow_versions
  triggered_by          UUID           FK users, nullable
  trigger_type          VARCHAR(50)    NOT NULL
  correlation_id        VARCHAR(100)   nullable
  status                VARCHAR(30)    NOT NULL
  started_at            DATETIME       nullable
  finished_at           DATETIME       nullable
  created_at            DATETIME       NOT NULL

## 13.5 workflow_execution_steps

  Column                  Type           Rules
  ----------------------- -------------- ------------------------
  id                      UUID           PK
  workflow_execution_id   UUID           FK workflow_executions
  workflow_step_id        UUID           FK workflow_steps
  status                  VARCHAR(30)    NOT NULL
  input_payload           JSON           nullable
  output_payload          JSON           nullable
  error_code              VARCHAR(100)   nullable
  started_at              DATETIME       nullable
  finished_at             DATETIME       nullable
  created_at              DATETIME       NOT NULL

------------------------------------------------------------------------

# 14. Copy Trading

Copy trading must never bypass risk and broker execution controls.

## 14.1 copy_trade_groups

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  owner_user_id   UUID           FK users
  name            VARCHAR(150)   NOT NULL
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 14.2 copy_trade_masters

  Column                Type          Rules
  --------------------- ------------- --------------------------------
  id                    UUID          PK
  group_id              UUID          FK copy_trade_groups
  account_id            UUID          FK trading_accounts
  strategy_version_id   UUID          FK strategy_versions, nullable
  status                VARCHAR(30)   NOT NULL
  created_at            DATETIME      NOT NULL

## 14.3 copy_trade_followers

  Column       Type          Rules
  ------------ ------------- ----------------------
  id           UUID          PK
  group_id     UUID          FK copy_trade_groups
  account_id   UUID          FK trading_accounts
  status       VARCHAR(30)   NOT NULL
  created_at   DATETIME      NOT NULL

## 14.4 copy_trade_rules

  Column          Type          Rules
  --------------- ------------- -------------------------
  id              UUID          PK
  follower_id     UUID          FK copy_trade_followers
  rule_type       VARCHAR(50)   NOT NULL
  configuration   JSON          NOT NULL
  enabled         BOOLEAN       NOT NULL
  created_at      DATETIME      NOT NULL
  updated_at      DATETIME      NOT NULL

## 14.5 copy_trade_mappings

Maps source/master instruments to follower broker symbols.

  Column                    Type          Rules
  ------------------------- ------------- -------------------------
  id                        UUID          PK
  master_id                 UUID          FK copy_trade_masters
  follower_id               UUID          FK copy_trade_followers
  source_instrument_id      UUID          FK instruments
  target_broker_symbol_id   UUID          FK broker_symbols
  status                    VARCHAR(30)   NOT NULL
  created_at                DATETIME      NOT NULL

## 14.6 copy_trade_executions

  Column                      Type           Rules
  --------------------------- -------------- -------------------------------
  id                          UUID           PK
  master_id                   UUID           FK copy_trade_masters
  follower_id                 UUID           FK copy_trade_followers
  source_deal_id              UUID           FK deals
  target_trading_request_id   UUID           FK trading_requests, nullable
  target_order_id             UUID           FK orders, nullable
  status                      VARCHAR(30)    NOT NULL
  requested_at                DATETIME       NOT NULL
  completed_at                DATETIME       nullable
  error_code                  VARCHAR(100)   nullable

------------------------------------------------------------------------

# 15. Plugin

## 15.1 plugins

  Column          Type           Rules
  --------------- -------------- --------------------
  id              UUID           PK
  owner_user_id   UUID           FK users, nullable
  plugin_code     VARCHAR(100)   UNIQUE
  name            VARCHAR(150)   NOT NULL
  plugin_type     VARCHAR(50)    NOT NULL
  status          VARCHAR(30)    NOT NULL
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 15.2 plugin_versions

  Column        Type            Rules
  ------------- --------------- ------------
  id            UUID            PK
  plugin_id     UUID            FK plugins
  version       VARCHAR(50)     NOT NULL
  package_uri   VARCHAR(1000)   NOT NULL
  checksum      VARCHAR(128)    NOT NULL
  manifest      JSON            NOT NULL
  status        VARCHAR(30)     NOT NULL
  created_at    DATETIME        NOT NULL

UNIQUE(`plugin_id`, `version`).

## 15.3 plugin_dependencies

  Column               Type           Rules
  -------------------- -------------- --------------------
  id                   UUID           PK
  plugin_version_id    UUID           FK plugin_versions
  dependency_type      VARCHAR(50)    NOT NULL
  dependency_code      VARCHAR(150)   NOT NULL
  version_constraint   VARCHAR(100)   nullable
  created_at           DATETIME       NOT NULL

## 15.4 plugin_installations

  Column               Type          Rules
  -------------------- ------------- --------------------
  id                   UUID          PK
  plugin_version_id    UUID          FK plugin_versions
  user_id              UUID          FK users
  installation_scope   VARCHAR(50)   NOT NULL
  status               VARCHAR(30)   NOT NULL
  installed_at         DATETIME      nullable
  uninstalled_at       DATETIME      nullable
  created_at           DATETIME      NOT NULL

------------------------------------------------------------------------

# 16. Licensing & Subscription

## 16.1 subscription_plans

  Column        Type           Rules
  ------------- -------------- ----------
  id            UUID           PK
  code          VARCHAR(80)    UNIQUE
  name          VARCHAR(150)   NOT NULL
  description   TEXT           nullable
  status        VARCHAR(30)    NOT NULL
  created_at    DATETIME       NOT NULL
  updated_at    DATETIME       NOT NULL

## 16.2 subscription_plan_versions

  Column          Type            Rules
  --------------- --------------- -----------------------
  id              UUID            PK
  plan_id         UUID            FK subscription_plans
  version         VARCHAR(50)     NOT NULL
  duration_days   INTEGER         NOT NULL
  price           DECIMAL(24,8)   NOT NULL
  currency        VARCHAR(20)     NOT NULL
  features        JSON            nullable
  status          VARCHAR(30)     NOT NULL
  created_at      DATETIME        NOT NULL

## 16.3 subscriptions

  Column            Type          Rules
  ----------------- ------------- -------------------------------
  id                UUID          PK
  user_id           UUID          FK users
  plan_version_id   UUID          FK subscription_plan_versions
  status            VARCHAR(30)   NOT NULL
  starts_at         DATETIME      NOT NULL
  ends_at           DATETIME      nullable
  auto_renew        BOOLEAN       NOT NULL
  created_at        DATETIME      NOT NULL
  updated_at        DATETIME      NOT NULL

## 16.4 licenses

  Column             Type           Rules
  ------------------ -------------- ----------------------------
  id                 UUID           PK
  user_id            UUID           FK users
  subscription_id    UUID           FK subscriptions, nullable
  license_key_hash   VARCHAR(255)   UNIQUE
  status             VARCHAR(30)    NOT NULL
  issued_at          DATETIME       NOT NULL
  expires_at         DATETIME       nullable
  revoked_at         DATETIME       nullable
  created_at         DATETIME       NOT NULL

Store hash, not plaintext license secret.

## 16.5 license_entitlements

  Column             Type            Rules
  ------------------ --------------- -------------
  id                 UUID            PK
  license_id         UUID            FK licenses
  entitlement_code   VARCHAR(150)    NOT NULL
  limit_value        DECIMAL(24,8)   nullable
  configuration      JSON            nullable
  created_at         DATETIME        NOT NULL

UNIQUE(`license_id`, `entitlement_code`).

------------------------------------------------------------------------

# 17. Notification & External Integration

## 17.1 notifications

  Column              Type           Rules
  ------------------- -------------- ----------
  id                  UUID           PK
  user_id             UUID           FK users
  notification_type   VARCHAR(50)    NOT NULL
  title               VARCHAR(200)   NOT NULL
  message             TEXT           NOT NULL
  severity            VARCHAR(30)    NOT NULL
  source_type         VARCHAR(50)    nullable
  source_id           VARCHAR(100)   nullable
  read_at             DATETIME       nullable
  created_at          DATETIME       NOT NULL

## 17.2 notification_deliveries

  Column                Type           Rules
  --------------------- -------------- ------------------
  id                    UUID           PK
  notification_id       UUID           FK notifications
  channel               VARCHAR(30)    NOT NULL
  destination           VARCHAR(500)   NOT NULL
  status                VARCHAR(30)    NOT NULL
  provider_message_id   VARCHAR(200)   nullable
  sent_at               DATETIME       nullable
  delivered_at          DATETIME       nullable
  failed_at             DATETIME       nullable
  error_code            VARCHAR(100)   nullable
  created_at            DATETIME       NOT NULL

## 17.3 external_integrations

  Column             Type           Rules
  ------------------ -------------- --------------------
  id                 UUID           PK
  user_id            UUID           FK users, nullable
  integration_type   VARCHAR(50)    NOT NULL
  provider_code      VARCHAR(100)   NOT NULL
  name               VARCHAR(150)   NOT NULL
  configuration      JSON           nullable
  status             VARCHAR(30)    NOT NULL
  created_at         DATETIME       NOT NULL
  updated_at         DATETIME       NOT NULL

## 17.4 integration_credentials

Only references to secret storage.

  Column            Type           Rules
  ----------------- -------------- --------------------------
  id                UUID           PK
  integration_id    UUID           FK external_integrations
  secret_ref        VARCHAR(500)   NOT NULL
  credential_type   VARCHAR(50)    NOT NULL
  status            VARCHAR(30)    NOT NULL
  expires_at        DATETIME       nullable
  created_at        DATETIME       NOT NULL
  revoked_at        DATETIME       nullable

------------------------------------------------------------------------

# 18. Operations

## 18.1 system_settings

  Column          Type           Rules
  --------------- -------------- --------------------
  id              UUID           PK
  setting_key     VARCHAR(200)   UNIQUE
  setting_value   TEXT           NOT NULL
  value_type      VARCHAR(30)    NOT NULL
  scope           VARCHAR(50)    NOT NULL
  description     TEXT           nullable
  updated_by      UUID           FK users, nullable
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

Secrets must not be stored here.

## 18.2 feature_flags

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  flag_code       VARCHAR(150)   UNIQUE
  enabled         BOOLEAN        NOT NULL
  scope           VARCHAR(50)    NOT NULL
  configuration   JSON           nullable
  created_at      DATETIME       NOT NULL
  updated_at      DATETIME       NOT NULL

## 18.3 jobs

  Column         Type           Rules
  -------------- -------------- ----------
  id             UUID           PK
  job_type       VARCHAR(100)   NOT NULL
  payload        JSON           nullable
  priority       INTEGER        NOT NULL
  status         VARCHAR(30)    NOT NULL
  scheduled_at   DATETIME       nullable
  available_at   DATETIME       nullable
  attempts       INTEGER        NOT NULL
  max_attempts   INTEGER        NOT NULL
  created_at     DATETIME       NOT NULL
  updated_at     DATETIME       NOT NULL

## 18.4 job_executions

  Column          Type           Rules
  --------------- -------------- ----------
  id              UUID           PK
  job_id          UUID           FK jobs
  worker_id       VARCHAR(150)   nullable
  status          VARCHAR(30)    NOT NULL
  started_at      DATETIME       nullable
  finished_at     DATETIME       nullable
  error_code      VARCHAR(100)   nullable
  error_message   TEXT           nullable
  created_at      DATETIME       NOT NULL

## 18.5 api_usage_records

  Column           Type            Rules
  ---------------- --------------- -----------------------
  id               UUID            PK
  user_id          UUID            FK users, nullable
  api_key_id       UUID            FK api_keys, nullable
  provider_type    VARCHAR(50)     NOT NULL
  operation        VARCHAR(150)    NOT NULL
  request_count    BIGINT          NOT NULL
  response_count   BIGINT          NOT NULL
  usage_units      DECIMAL(24,8)   nullable
  recorded_at      DATETIME        NOT NULL

## 18.6 backup_records

  Column            Type            Rules
  ----------------- --------------- ----------
  id                UUID            PK
  backup_type       VARCHAR(50)     NOT NULL
  storage_uri       VARCHAR(1000)   NOT NULL
  checksum          VARCHAR(128)    nullable
  size_bytes        BIGINT          nullable
  status            VARCHAR(30)     NOT NULL
  started_at        DATETIME        nullable
  completed_at      DATETIME        nullable
  retention_until   DATETIME        nullable
  created_at        DATETIME        NOT NULL

## 18.7 system_events

Append-only platform event history.

  Column           Type           Rules
  ---------------- -------------- ----------
  id               UUID           PK
  event_type       VARCHAR(100)   NOT NULL
  source           VARCHAR(100)   NOT NULL
  severity         VARCHAR(30)    NOT NULL
  correlation_id   VARCHAR(100)   nullable
  payload          JSON           nullable
  occurred_at      DATETIME       NOT NULL
  created_at       DATETIME       NOT NULL

------------------------------------------------------------------------

# 19. Core Relationships

``` text
users
 ├── user_profiles
 ├── user_roles ── roles ── role_permissions ── permissions
 ├── sessions
 ├── api_keys
 ├── connections
 ├── trading_accounts
 ├── strategies
 ├── ai_sessions
 ├── backtests
 ├── workflows
 ├── subscriptions ── subscription_plan_versions ── subscription_plans
 ├── licenses ── license_entitlements
 └── notifications

brokers
 └── broker_platforms ── platforms
        ├── connections
        └── broker_symbols ── instruments

instrument_types
 └── instruments
      ├── broker_symbols
      ├── symbol_mappings
      └── market_data_datasets

market_data_datasets
 ├── market_data_bars
 └── market_data_ticks

strategies
 └── strategy_versions
      ├── strategy_parameters
      └── strategy_deployments

strategy_versions
 ├── trading_requests
 ├── orders
 ├── positions
 ├── backtest_runs
 ├── risk/deployment references
 └── AI decision references

trading_requests
 └── orders
      ├── order_events
      └── order_executions
             └── deals
                   └── positions
                        └── position_events

backtests
 └── backtest_runs
      ├── strategy_versions
      ├── market_data_datasets
      ├── backtest_trades
      └── backtest_metrics

ai_providers
 └── ai_models
      └── ai_provider_models
           └── ai_requests
                ├── ai_responses
                ├── ai_analyses
                ├── ai_decisions
                └── ai_usage_records
```

------------------------------------------------------------------------

# 20. Trading State Rules

1.  `trading_requests` represents intent.
2.  `orders` represents broker order instruction.
3.  `order_events` represents order lifecycle.
4.  `order_executions` represents fills.
5.  `deals` represents executed transaction records.
6.  `positions` represents current/closed aggregate position state.
7.  `position_events` represents position lifecycle.
8.  An order may have zero, one, or many executions.
9.  A deal must reference an execution.
10. A position may be created/changed/closed by multiple deals.
11. Do not assume one order equals one position.
12. Netting and hedging account modes must be supported by
    connector/position logic, not by a universal one-order-one-position
    FK.

------------------------------------------------------------------------

# 21. Strategy Rules

1.  `strategies` is identity.
2.  `strategy_versions` is executable immutable version.
3.  `strategy_parameters` belongs to a strategy version.
4.  Published versions cannot be modified in place.
5.  New logic/configuration creates a new version.
6.  Live trading references a specific strategy version.
7.  Backtest references a specific strategy version.
8.  AI decisions may reference a strategy version.
9.  Copy trading may reference a strategy version.
10. Strategy deployment is the association between a version and a
    runtime target.

------------------------------------------------------------------------

# 22. Backtest Reproducibility

A reproducible backtest requires:

``` text
strategy_version_id
+
market_data_dataset_id
+
risk_policy_id (if used)
+
engine_version
+
configuration
+
run_checksum
```

The database must never claim that two runs are identical merely because
they use the same strategy identity.

------------------------------------------------------------------------

# 23. AI Safety Boundary

AI output is advisory/decision data until it enters the controlled
trading pipeline.

Canonical path:

``` text
AI Request
   ↓
AI Analysis / AI Decision
   ↓
Trading Request
   ↓
Risk Policy / Risk Rules
   ↓
Order
   ↓
Execution
```

AI must not bypass:

-   authorization;
-   account state validation;
-   risk management;
-   broker/platform validation;
-   idempotency;
-   audit logging.

------------------------------------------------------------------------

# 24. Copy Trading Safety Boundary

Canonical path:

``` text
Master Deal
   ↓
Copy Mapping
   ↓
Follower Rule
   ↓
Target Trading Request
   ↓
Risk Check
   ↓
Target Order
```

Copy trading must not directly insert target `deals`.

------------------------------------------------------------------------

# 25. Audit & Immutability Policy

Append-only:

-   `security_events`
-   `audit_logs`
-   `order_events`
-   `order_executions`
-   `deals`
-   `position_events`
-   `risk_events`
-   `system_events`
-   `backtest_runs` after completion
-   published market-data dataset versions
-   published strategy versions
-   published workflow versions
-   published prompt versions

Mutable/configuration:

-   users
-   profiles
-   connections
-   brokers
-   platforms
-   strategies
-   workflows
-   subscription metadata
-   system settings

Revocable rather than deleted:

-   sessions
-   API keys
-   licenses
-   credentials
-   integrations

------------------------------------------------------------------------

# 26. Foreign Key Rules

Every FK must satisfy:

1.  referenced table exists;
2.  referenced column exists;
3.  referenced column has PK/UNIQUE semantics where required;
4.  datatype is compatible;
5.  delete behavior is explicitly chosen;
6.  historical tables must not cascade-delete financial history;
7.  user deletion must not silently erase audit/transaction history;
8.  external IDs are not used as relational FK unless explicitly
    designed as stable unique keys.

Recommended default:

-   configuration child -\> `RESTRICT` or controlled soft delete;
-   historical child -\> `RESTRICT`;
-   pure junction -\> `CASCADE` only when deleting the relationship is
    safe;
-   audit/history -\> never cascade from user/business deletion.

------------------------------------------------------------------------

# 27. Index Rules

Every table:

-   PK index.

Every FK frequently queried:

-   index FK.

Common composite indexes:

-   `trading_accounts(user_id, status)`
-   `broker_symbols(broker_platform_id, symbol_code)`
-   `orders(account_id, created_at)`
-   `order_events(order_id, event_time)`
-   `order_executions(order_id, execution_time)`
-   `deals(account_id, executed_at)`
-   `positions(account_id, status)`
-   `position_events(position_id, event_time)`
-   `market_data_bars(dataset_id, open_time)`
-   `ai_messages(ai_session_id, sequence_no)`
-   `workflow_execution_steps(workflow_execution_id, workflow_step_id)`

Avoid indexing every column automatically.

------------------------------------------------------------------------

# 28. Constraint Rules

Prices, quantities, and monetary values:

-   must not use FLOAT/DOUBLE as authoritative storage;
-   quantity must be positive where semantically required;
-   `minimum_quantity <= maximum_quantity` when maximum exists;
-   `quantity_step > 0`;
-   `tick_size > 0`;
-   bar high \>= open and close;
-   bar low \<= open and close;
-   confidence scores are constrained to their valid range;
-   percentage-like values must define their unit.

Business validation that cannot be safely represented as a DB CHECK
remains application/domain validation.

------------------------------------------------------------------------

# 29. Soft Delete Rules

Soft delete is allowed for:

-   users;
-   user profiles;
-   connections;
-   brokers;
-   instruments;
-   broker symbols;
-   strategies;
-   workflows;
-   plugins;
-   subscription plan identities.

Soft delete is not the normal lifecycle mechanism for:

-   deals;
-   executions;
-   order events;
-   position events;
-   audit logs;
-   security events;
-   system events;
-   completed backtest records.

For credentials/sessions/licenses use explicit revocation/expiry fields.

------------------------------------------------------------------------

# 30. Data Retention

Retention must be policy-driven.

Suggested categories:

### Critical financial history

Long-term retention; never delete merely because the live object is
closed.

### Audit/security

Long-term retention according to compliance/security policy.

### Market data

Tiered retention; hot/fast storage and archive/object storage may
differ.

### Runtime jobs

Shorter retention after successful completion.

### Notifications

Retention according to product requirement.

The database design does not hard-code a single universal retention
period.

------------------------------------------------------------------------

# 31. Transaction Boundaries

A transaction should be used for atomic state changes such as:

``` text
trading_request creation + initial state
order creation + request state transition
order execution + related order state update
position state update + position event
license issue + entitlement creation
```

Do not hold a database transaction open while waiting for an external
broker, AI provider, or network request.

External operations use state machines/idempotency/correlation IDs.

------------------------------------------------------------------------

# 32. Idempotency & Correlation

External commands should use idempotency keys.

Examples:

-   trading request;
-   broker order submission;
-   notification delivery;
-   workflow trigger;
-   AI provider request where supported;
-   copy trade execution.

Use `correlation_id` to trace a business flow across:

``` text
AI
→ workflow
→ trading request
→ order
→ execution
→ deal
→ position
→ audit
```

------------------------------------------------------------------------

# 33. Secret Management

Never store plaintext:

-   broker passwords;
-   trading account passwords;
-   API secrets;
-   private keys;
-   OAuth client secrets;
-   AI provider keys;
-   webhook secrets.

Database stores only:

``` text
secret_ref
credential metadata
status
expiry/revocation metadata
```

Actual secret storage is an infrastructure concern.

------------------------------------------------------------------------

# 34. API / MCP

REST API and MCP are interfaces, not automatically separate business
tables.

Use:

-   `users`;
-   `roles`;
-   `permissions`;
-   `sessions`;
-   `api_keys`;
-   `audit_logs`;
-   `api_usage_records`.

Create additional persistence only when the interface introduces a real
business entity.

------------------------------------------------------------------------

# 35. Cache / Queue / WebSocket

Do not create permanent tables merely for:

-   current websocket connections;
-   cache entries;
-   transient market prices;
-   message queue internals;
-   worker heartbeats.

Persistent operational state belongs in the relevant entity tables;
ephemeral runtime state belongs to the infrastructure component designed
for it.

------------------------------------------------------------------------

# 36. ERD --- High Level

``` text
USERS
 ├── USER_PROFILES
 ├── USER_ROLES ── ROLES ── ROLE_PERMISSIONS ── PERMISSIONS
 ├── SESSIONS
 ├── API_KEYS
 ├── STRATEGIES ── STRATEGY_VERSIONS ── STRATEGY_PARAMETERS
 │                         └── STRATEGY_DEPLOYMENTS
 ├── CONNECTIONS ── BROKER_PLATFORMS ── BROKERS
 │                                  └── PLATFORMS
 ├── TRADING_ACCOUNTS
 │      ├── ACCOUNT_BALANCE_SNAPSHOTS
 │      ├── TRADING_REQUESTS
 │      │      └── ORDERS
 │      │           ├── ORDER_EVENTS
 │      │           └── ORDER_EXECUTIONS ── DEALS ── POSITIONS
 │      │                                      └── POSITION_EVENTS
 │      └── TRADING_JOURNALS
 ├── AI_SESSIONS ── AI_REQUESTS ── AI_RESPONSES
 │                              ├── AI_ANALYSES
 │                              ├── AI_DECISIONS
 │                              └── AI_USAGE_RECORDS
 ├── BACKTESTS ── BACKTEST_RUNS ── BACKTEST_TRADES
 │                              └── BACKTEST_METRICS
 ├── WORKFLOWS ── WORKFLOW_VERSIONS ── WORKFLOW_STEPS
 │                                  └── WORKFLOW_EXECUTIONS
 ├── COPY_TRADE_GROUPS
 ├── SUBSCRIPTIONS ── SUBSCRIPTION_PLAN_VERSIONS ── SUBSCRIPTION_PLANS
 ├── LICENSES ── LICENSE_ENTITLEMENTS
 └── NOTIFICATIONS ── NOTIFICATION_DELIVERIES

INSTRUMENT_TYPES
 └── INSTRUMENTS
      ├── BROKER_SYMBOLS
      ├── SYMBOL_MAPPINGS
      └── MARKET_DATA_DATASETS
            ├── MARKET_DATA_BARS
            └── MARKET_DATA_TICKS
```

------------------------------------------------------------------------

# 37. Final Table Catalog

  ------------------------------------------------------------------------------------------------
                     \# Table                        Category         Lifecycle
  --------------------- ---------------------------- ---------------- ----------------------------
                      1 users                        Identity         Mutable/soft-delete

                      2 user_profiles                Identity         Mutable

                      3 roles                        Security         Mutable

                      4 permissions                  Security         Controlled

                      5 user_roles                   Security         Relationship

                      6 role_permissions             Security         Relationship

                      7 sessions                     Security         Revocable/expiring

                      8 api_keys                     Security         Revocable/expiring

                      9 security_events              Security         Append-only

                     10 audit_logs                   Security         Append-only

                     11 brokers                      Connectivity     Mutable/soft-delete

                     12 platforms                    Connectivity     Controlled

                     13 broker_platforms             Connectivity     Mutable

                     14 connections                  Connectivity     Revocable/soft-delete

                     15 instrument_types             Market           Controlled

                     16 instruments                  Market           Mutable/soft-delete

                     17 broker_symbols               Market           Mutable/soft-delete

                     18 symbol_mappings              Market           Controlled

                     19 market_data_sources          Market           Controlled

                     20 market_data_datasets         Market           Versioned/immutable

                     21 market_data_bars             Market           Append/archive

                     22 market_data_ticks            Market           Append/archive

                     23 trading_accounts             Trading          Mutable/soft-delete

                     24 account_balance_snapshots    Trading          Append-only

                     25 trading_requests             Trading          Lifecycle

                     26 orders                       Trading          Lifecycle

                     27 order_events                 Trading          Append-only

                     28 order_executions             Trading          Append-only

                     29 deals                        Trading          Append-only

                     30 positions                    Trading          Lifecycle

                     31 position_events              Trading          Append-only

                     32 trading_journals             Trading          Mutable

                     33 strategies                   Strategy         Mutable/soft-delete

                     34 strategy_versions            Strategy         Versioned/immutable

                     35 strategy_parameters          Strategy         Versioned

                     36 strategy_deployments         Strategy         Lifecycle

                     37 risk_policies                Risk             Mutable

                     38 risk_rules                   Risk             Mutable

                     39 risk_events                  Risk             Append-only

                     40 backtests                    Backtest         Mutable

                     41 backtest_runs                Backtest         Immutable after completion

                     42 backtest_trades              Backtest         Append-only

                     43 backtest_metrics             Backtest         Append-only

                     44 ai_providers                 AI               Controlled

                     45 ai_models                    AI               Controlled

                     46 ai_provider_models           AI               Configuration

                     47 ai_sessions                  AI               Lifecycle

                     48 ai_messages                  AI               Append-only

                     49 ai_requests                  AI               Append-only/lifecycle

                     50 ai_responses                 AI               Append-only

                     51 ai_analyses                  AI               Append-only

                     52 ai_decisions                 AI               Append-only

                     53 prompt_templates             AI               Mutable

                     54 prompt_versions              AI               Immutable after publish

                     55 ai_usage_records             AI               Append-only

                     56 workflows                    Workflow         Mutable/soft-delete

                     57 workflow_versions            Workflow         Immutable after publish

                     58 workflow_steps               Workflow         Versioned

                     59 workflow_executions          Workflow         Append/lifecycle

                     60 workflow_execution_steps     Workflow         Append/lifecycle

                     61 copy_trade_groups            Copy Trading     Mutable

                     62 copy_trade_masters           Copy Trading     Lifecycle

                     63 copy_trade_followers         Copy Trading     Lifecycle

                     64 copy_trade_rules             Copy Trading     Mutable

                     65 copy_trade_mappings          Copy Trading     Controlled

                     66 copy_trade_executions        Copy Trading     Append/lifecycle

                     67 plugins                      Plugin           Mutable

                     68 plugin_versions              Plugin           Immutable after publish

                     69 plugin_dependencies          Plugin           Versioned

                     70 plugin_installations         Plugin           Lifecycle

                     71 subscription_plans           Licensing        Controlled

                     72 subscription_plan_versions   Licensing        Versioned

                     73 subscriptions                Licensing        Lifecycle

                     74 licenses                     Licensing        Revocable

                     75 license_entitlements         Licensing        Controlled

                     76 notifications                Notification     Mutable/read-state

                     77 notification_deliveries      Notification     Append/lifecycle

                     78 external_integrations        Integration      Mutable/revocable

                     79 integration_credentials      Integration      Secret-reference/revocable

                     80 system_settings              Operations       Mutable

                     81 feature_flags                Operations       Mutable

                     82 jobs                         Operations       Lifecycle

                     83 job_executions               Operations       Append/lifecycle

                     84 api_usage_records            Operations       Append-only

                     85 backup_records               Operations       Append-only

                     86 system_events                Operations       Append-only
  ------------------------------------------------------------------------------------------------

**Final logical catalog: 86 tables.**

------------------------------------------------------------------------

# 38. Tables Explicitly Removed / Replaced From Earlier Design

The following concepts must not remain as conflicting duplicate masters:

### `trading_symbols`

Replaced by:

-   `instruments`
-   `broker_symbols`
-   `symbol_mappings`

Reason: broker-specific symbol names and trading rules differ.

### Broker `platform` column

Removed from the broker master.

Replaced by:

-   `platforms`
-   `broker_platforms`

### Strategy `version` column as executable state

Moved to:

-   `strategy_versions`

### Strategy risk defaults

Moved to:

-   `risk_policies`
-   `risk_rules`

where they represent actual risk controls.

### Order → Position as mandatory direct relationship

Removed.

Use:

`order → executions → deals → positions`

with platform/account-mode-specific position aggregation.

### Plaintext credentials

Removed from business tables.

Use secret references.

------------------------------------------------------------------------

# 39. Migration Requirements

Migration from the previous design must be done in controlled phases:

1.  Create new master tables.
2.  Create compatibility columns/tables only when necessary.
3.  Migrate brokers into `brokers`, `platforms`, and `broker_platforms`.
4.  Migrate old symbols into `instruments`.
5.  Create `broker_symbols` for broker-specific names/rules.
6.  Create symbol mappings.
7.  Create strategy identities and versions.
8.  Migrate old strategy configuration into version/parameter/risk
    structures.
9.  Create trading request/order event/execution/deal relationships.
10. Backfill historical order/execution/deal relationships where
    evidence exists.
11. Do not invent missing historical relationships.
12. Validate all FK and uniqueness constraints.
13. Switch application reads/writes.
14. Remove obsolete structures only after successful validation and
    backup.
15. Record migration in the migration system and audit trail.

------------------------------------------------------------------------

# 40. Final Integrity Checklist

Before database implementation is declared complete:

-   [ ] all 86 tables are defined;
-   [ ] every PK exists;
-   [ ] every FK target exists;
-   [ ] every FK datatype is compatible;
-   [ ] no duplicate master entity remains;
-   [ ] no global uniqueness exists where broker/platform scope is
    required;
-   [ ] MT4 supported;
-   [ ] MT5 supported;
-   [ ] TradingView supported;
-   [ ] multi-broker supported;
-   [ ] multi-account supported;
-   [ ] hedging/netting can be represented;
-   [ ] partial fills supported;
-   [ ] order lifecycle is event-capable;
-   [ ] deal history is append-only;
-   [ ] strategy versioning is reproducible;
-   [ ] backtest dataset is versioned;
-   [ ] AI provider/model is separated;
-   [ ] AI decision cannot bypass risk/trading pipeline;
-   [ ] copy trading maps source to target symbols;
-   [ ] copy trading uses normal risk/trading pipeline;
-   [ ] secrets are references, not plaintext;
-   [ ] audit is append-only;
-   [ ] security events are append-only;
-   [ ] market-data storage can scale independently;
-   [ ] migrations are versioned;
-   [ ] retention is policy-driven.

------------------------------------------------------------------------

# 41. Definition of Done

`DATABASE_DESIGN.md` is considered final when:

1.  The application architecture can map every persistent business
    capability to an entity.
2.  Every persistent entity has an explicit lifecycle.
3.  Every relationship has an explicit owner/cardinality.
4.  Every critical historical action has an append-only record where
    required.
5.  Trading data is separated from backtest data.
6.  Canonical instruments are separated from broker symbols.
7.  Strategy identity is separated from executable versions.
8.  AI output is separated from executable trading commands.
9.  Credentials are externalized through secret references.
10. The design does not require one particular database/storage vendor.
11. Future MT5/TradingView/broker/API/plugin expansion does not require
    redesigning core identity tables.

------------------------------------------------------------------------

# END OF DATABASE_DESIGN.md
