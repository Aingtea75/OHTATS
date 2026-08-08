# DATABASE_REVIEW.md

# OHTATS — Database Review & Readiness Assessment

> **Status: FINAL DATABASE REVIEW**
>
> Dokumen ini merupakan hasil review terhadap `DATABASE_DESIGN.md` sebagai baseline resmi desain database OHTATS.
>
> Dokumen ini tidak menggantikan `DATABASE_DESIGN.md`. Fungsinya adalah sebagai lapisan validasi, risk register, implementation gate, dan checklist kesiapan implementasi.

---

# 1. Tujuan Review

Review database OHTATS bertujuan memastikan desain database:

- konsisten dengan arsitektur OHTATS,
- mendukung multi-user, multi-broker, dan multi-trading-account,
- mendukung MT4, MT5, TradingView, dan integrasi tambahan,
- mendukung AI Provider, AI Session, Workflow, Backtest, Copy Trading, dan Risk Management,
- memiliki integritas referensial,
- dapat diaudit,
- aman terhadap credential dan secret,
- dapat berkembang tanpa redesign inti yang tidak perlu,
- memiliki dasar untuk data trading dan market-data bervolume tinggi,
- memiliki backup/recovery strategy,
- dan siap diterjemahkan menjadi migration/ORM secara bertahap.

---

# 2. Ruang Lingkup

Review mencakup:

1. model domain,
2. entity relationship,
3. struktur tabel,
4. primary key dan foreign key,
5. unique constraint,
6. business constraint,
7. indexing,
8. lifecycle data,
9. soft delete,
10. transaction boundary,
11. concurrency,
12. idempotency,
13. monetary precision,
14. timestamp dan timezone,
15. audit trail,
16. security dan secret handling,
17. API usage,
18. job queue,
19. backup metadata,
20. high-volume data,
21. retention,
22. migration/versioning,
23. disaster recovery,
24. observability,
25. multi-tenant isolation,
26. implementability,
27. maintainability,
28. future extensibility.

Review ini bersifat logical/architectural review. Review ini bukan pengganti load test, penetration test, database benchmark, atau production migration rehearsal.

---

# 3. Baseline yang Direview

Baseline utama:

- `docs/blueprint/DATABASE_DESIGN.md`
- `docs/blueprint/DATABASE_REVIEW.md`

`DATABASE_DESIGN.md` menetapkan database sebagai fondasi untuk multi-user, multi-broker, multi-trading-account, multi-platform, multi-AI-provider, workflow, plugin, audit, logging, notification, backtesting, copy trading, scalability, security, dan high availability.

Prinsip desainnya mencakup modularity, normalisasi, scalability, maintainability, auditability, security by design, performance optimization, backup/recovery, high-availability readiness, extensibility, dan pengurangan duplikasi data.

---

# 4. Executive Verdict

## 4.1 Status

**DATABASE DESIGN: APPROVED WITH IMPLEMENTATION GATES**

Artinya:

- struktur konseptual sudah cukup kuat untuk menjadi baseline implementasi,
- domain utama sudah terwakili,
- desain sudah mempertimbangkan pertumbuhan platform,
- implementasi database tidak boleh dilakukan dengan menerjemahkan dokumen secara buta menjadi SQL.

Beberapa aturan harus dipertegas pada migration/ORM dan application layer sebelum production.

## 4.2 Kesimpulan Utama

Desain database OHTATS layak menjadi **logical database blueprint**.

Prioritas berikutnya bukan menambah tabel tanpa batas, tetapi memastikan:

1. referential integrity,
2. tenant isolation,
3. trading idempotency,
4. monetary precision,
5. timestamp consistency,
6. audit immutability,
7. secret isolation,
8. high-volume data separation,
9. transaction boundary,
10. migration discipline.

---

# 5. Kekuatan Desain

## 5.1 Multi-Platform

Pemisahan Broker, Trading Account, Symbol, Order, Position, dan Deal memberi dasar yang baik untuk MT4, MT5, TradingView, Broker API, exchange, dan platform tambahan.

## 5.2 Multi-Broker

`broker_code`, broker identity, platform, server, dan status menyediakan dasar broker registry.

## 5.3 Strategy-Centric Architecture

Strategy diposisikan sebagai objek pusat untuk trading, AI, workflow, backtest, risk management, dan copy trading.

## 5.4 Auditability

Audit Log sudah menjadi domain utama dan dapat menjadi dasar investigasi.

## 5.5 Backup Metadata

Backup metadata dipisahkan dari file backup sebenarnya. Database menyimpan metadata dan checksum, sedangkan storage menyimpan file.

## 5.6 Asynchronous Processing

Job Queue menyediakan dasar background processing, workflow, AI analysis, backup, retry, dan worker processing.

## 5.7 API Usage

API Usage sudah mempertimbangkan request, token, estimated cost, latency, rate limit, provider, integration, dan status.

---

# 6. Temuan Prioritas

| ID | Area | Severity | Status | Tindakan |
|---|---|---|---|---|
| DBR-001 | Tenant isolation | CRITICAL | Required | Wajib ditegakkan |
| DBR-002 | Trading idempotency | CRITICAL | Required | Wajib sebelum live execution |
| DBR-003 | Audit immutability | CRITICAL | Required | Audit tidak boleh diedit sembarangan |
| DBR-004 | Secret isolation | CRITICAL | Required | Secret tidak boleh berada di payload/log biasa |
| DBR-005 | Monetary precision | HIGH | Required | Tetapkan precision/scale/currency policy |
| DBR-006 | Timezone policy | HIGH | Required | UTC sebagai canonical storage time |
| DBR-007 | Order/Position mapping | HIGH | Required | Ikuti broker-native semantics |
| DBR-008 | Market-data volume | HIGH | Required | Pisahkan hot transactional DB dari historical data |
| DBR-009 | API usage aggregation | MEDIUM | Recommended | Definisikan event vs aggregate |
| DBR-010 | Job idempotency | HIGH | Required | Terapkan deduplication strategy |
| DBR-011 | Migration policy | HIGH | Required | Semua schema change harus versioned |
| DBR-012 | Retention policy | MEDIUM | Required | Tentukan retention per domain |
| DBR-013 | Backup verification | HIGH | Required | Restore test wajib |
| DBR-014 | ERD synchronization | MEDIUM | Required | ERD harus mengikuti final schema |
| DBR-015 | Index governance | MEDIUM | Recommended | Index ditinjau berdasarkan query nyata |

---

# 7. Review Domain Model

## 7.1 Users

User menjadi root ownership domain.

Minimum invariant:

- `id` immutable,
- identity unik,
- status account jelas,
- ownership resource dapat ditelusuri.

Setiap tabel user-owned harus memiliki jalur ownership yang dapat diverifikasi.

## 7.2 Trading Accounts

Trading Account merupakan security dan operational boundary.

Wajib:

- mengacu ke user,
- mengacu ke broker,
- memiliki platform,
- memiliki lifecycle status,
- tidak menyimpan password/API secret plaintext.

Credential harus berada pada secret-management layer atau encrypted credential subsystem.

## 7.3 Brokers

Broker registry harus membedakan:

- broker identity,
- broker platform,
- broker server/environment,
- connection capability.

`broker_code` harus stabil.

## 7.4 Symbols

Symbol global tidak selalu identik dengan symbol broker.

Contoh:

- EURUSD,
- EURUSDm,
- EURUSD.a.

Karena itu implementasi perlu memisahkan canonical symbol dan broker symbol mapping.

## 7.5 Strategies

Strategy harus memiliki version identity yang jelas.

Perubahan material terhadap parameter strategy sebaiknya menghasilkan version baru, bukan mengubah histori strategy yang sudah dipakai.

## 7.6 Orders

Order adalah execution intent/request.

Order harus memiliki:

- internal order ID,
- broker order ID bila tersedia,
- idempotency key,
- execution status,
- timestamps,
- error state.

## 7.7 Positions

Position semantics berbeda antar platform. MT4, MT5, dan platform lain dapat memiliki model netting/hedging yang berbeda.

Position tidak boleh diasumsikan selalu one-to-one dengan Order.

## 7.8 Deals

Deal harus diperlakukan sebagai execution/fill event yang dekat dengan broker execution dan penting untuk reconciliation.

## 7.9 AI Sessions

AI Session harus dapat menelusuri user, provider, model, request metadata, response metadata, token usage bila tersedia, latency, dan error.

Prompt/response sensitif harus mengikuti privacy dan retention policy.

## 7.10 Backtests

Backtest harus dapat diulang.

Metadata minimum:

- strategy version,
- dataset version,
- symbol,
- timeframe,
- parameter set,
- execution assumptions,
- cost assumptions,
- result version.

---

# 8. Referential Integrity

Foreign key yang wajib harus benar-benar ditegakkan.

Minimum relationship:

- Trading Account → User
- Trading Account → Broker
- Strategy → User
- Strategy → Symbol
- Strategy → Broker bila mandatory
- Order → Trading Account
- Order → Symbol
- Position → Trading Account
- Deal → Trading Account
- Backtest → Strategy
- License → Subscription Plan
- Notification → User
- Audit Log → actor/user bila applicable.

Foreign key nullable hanya digunakan bila domain memang mengizinkan hubungan tanpa parent.

---

# 9. Soft Delete Policy

`deleted_at` digunakan untuk mempertahankan histori.

Aturan:

1. record soft-deleted tidak muncul pada query normal,
2. query administratif dapat melihat deleted record,
3. unique constraint harus dipertimbangkan terhadap soft-deleted record,
4. child record tidak boleh kehilangan histori,
5. soft delete bukan pengganti retention policy,
6. data audit tertentu dapat harus immutable.

Unique index dengan soft delete harus mengikuti kemampuan database engine yang dipilih.

---

# 10. Transaction Policy

Transaction wajib digunakan untuk operasi yang membutuhkan atomicity.

Contoh:

### Trading

Validasi risk → create order intent → persist idempotency state → dispatch execution.

### Subscription

Create subscription state → create license → update entitlement.

### Workflow

Create execution → create job state → persist audit event.

### Backup

Create metadata → start job → update status → persist completion metadata.

Jangan membuat transaction database terlalu panjang untuk pekerjaan eksternal yang lambat.

---

# 11. Trading Idempotency

Ini merupakan kontrol paling penting.

Jika request trading dikirim dua kali karena timeout, retry, worker restart, atau crash, sistem harus membedakan retry request yang sama dari new trading instruction.

Minimum:

- `idempotency_key`,
- owner/account scope,
- request fingerprint,
- lifecycle status,
- broker correlation ID bila tersedia.

Idempotency key harus unik dalam scope yang tepat.

---

# 12. Concurrency Control

Trading Account dan Order adalah area concurrency tinggi.

Pertimbangkan:

- optimistic locking,
- row locking bila diperlukan,
- atomic balance/risk checks,
- duplicate request prevention,
- worker race prevention.

Constraint yang harus atomic tidak boleh hanya mengandalkan application validation.

---

# 13. Monetary Precision

Nilai uang harus menggunakan fixed-point decimal, bukan floating-point.

Wajib didefinisikan:

- currency,
- precision,
- scale,
- rounding mode.

Profit, balance, equity, commission, swap, fee, cost, dan estimated cost harus memiliki kebijakan pembulatan yang konsisten.

---

# 14. Trading Quantity Precision

Quantity seperti lot, volume, contract quantity, dan tick size harus menggunakan decimal precision yang sesuai instrumen.

Wajib dapat divalidasi:

- minimum quantity,
- maximum quantity,
- step size,
- tick size.

---

# 15. Time & Timezone

Canonical storage time:

**UTC**

Local timezone digunakan pada presentation/scheduling layer.

Event trading sebaiknya dapat membedakan:

- event timestamp,
- broker timestamp,
- received timestamp,
- processed timestamp,
- created timestamp.

---

# 16. Audit Log

Audit Log harus diperlakukan sebagai historical evidence.

Minimum metadata yang direkomendasikan:

- event ID,
- actor type,
- actor ID,
- action,
- entity type,
- entity ID,
- timestamp,
- request/correlation ID,
- source,
- outcome,
- sanitized metadata.

Audit log tidak boleh menyimpan password, API key, token, secret, atau private key.

Event sensitif harus menggunakan append-only policy.

---

# 17. Correlation ID

Operasi lintas modul harus dapat ditelusuri.

Contoh:

```text
User Request
    ↓
AI Decision
    ↓
Risk Check
    ↓
Workflow
    ↓
Order Intent
    ↓
Broker Request
    ↓
Broker Response
    ↓
Position/Deal
    ↓
Audit
```

Tahap penting harus dapat dikaitkan kembali ke satu correlation ID.

---

# 18. Secret Management

Credential dan secret harus dipisahkan dari business data biasa.

Implementasi wajib memisahkan:

- ordinary business data,
- encrypted secret reference,
- secret provider,
- runtime credential retrieval.

Secret tidak boleh berada di:

- Job Queue payload plaintext,
- API Usage error message,
- Audit Log,
- Backup metadata,
- application log.

---

# 19. API Usage Review

API Usage tepat untuk cost monitoring, token usage, latency, rate limit, dan provider performance.

Namun harus ditetapkan apakah satu record berarti:

1. satu API request, atau
2. aggregate beberapa request.

Jika volume meningkat, event-level usage dan aggregated analytics sebaiknya dipisahkan.

---

# 20. AI Provider Cost Accounting

`estimated_cost` harus dipandang sebagai estimation, bukan accounting truth.

Provider dapat memiliki billing unit berbeda.

Jika billing resmi diperlukan, gunakan immutable usage event dan pricing snapshot.

---

# 21. Job Queue Review

Job Queue sudah memiliki priority, status, retry, worker, schedule, dan error.

Implementation perlu:

- idempotency,
- visibility timeout/lease,
- retry backoff,
- dead-letter state,
- maximum execution duration,
- worker heartbeat bila diperlukan.

Worker restart tidak boleh menyebabkan destructive duplicate execution.

---

# 22. Job Payload Security

`payload JSON` harus dianggap tidak terpercaya.

Tidak boleh menyimpan:

- secret,
- password,
- API key,
- token,
- private key.

Gunakan reference ID untuk data sensitif dan validasi schema payload.

---

# 23. Market Data Strategy

Market data memiliki volume berbeda dari transactional data.

Prinsip:

**Transactional database bukan unlimited market-data warehouse.**

Historical market data dapat dipindahkan ke time-series storage, partitioned tables, object storage, atau analytical warehouse sesuai kebutuhan.

Database utama tetap menjadi source of truth untuk business state.

---

# 24. Hot vs Historical Data

### Hot Data

- account state,
- active orders,
- active positions,
- active workflow state,
- active jobs.

### Historical Data

- deals,
- audit logs,
- API usage,
- market data,
- backtest runs,
- job history,
- notifications.

Historical data memerlukan retention dan archiving strategy.

---

# 25. Partitioning

Partitioning tidak perlu diterapkan ke semua tabel.

Candidate:

- audit logs,
- API usage,
- market data,
- deal history,
- large event tables.

Partition key dapat berupa waktu jika pola query memang time-oriented.

Keputusan partitioning harus berdasarkan benchmark dan query pattern.

---

# 26. Index Governance

Index harus mendukung query nyata.

Terlalu banyak index menyebabkan write overhead, storage overhead, migration overhead, dan maintenance cost.

Minimum review:

- foreign-key lookup,
- status + timestamp,
- user + timestamp,
- account + timestamp,
- provider + timestamp,
- queue state,
- broker correlation.

---

# 27. Unique Constraint Governance

Unique constraint harus mempertimbangkan:

- tenant/user scope,
- broker scope,
- platform scope,
- server scope,
- soft delete.

Contoh account identity dapat memerlukan:

```text
broker_id + account_number
```

atau:

```text
broker_id + server + account_number
```

sesuai broker semantics.

---

# 28. Broker Symbol Mapping

Canonical symbol dan broker symbol harus dapat dibedakan:

```text
Canonical Symbol
       ↓
Broker Symbol Mapping
       ↓
Broker / Platform
```

Ini memungkinkan EURUSD, EURUSDm, dan EURUSD.a dipetakan tanpa kehilangan broker-specific identity.

---

# 29. Platform Capability Matrix

Platform tidak selalu memiliki kemampuan yang sama.

Capability abstraction perlu mencakup:

- order types,
- position model,
- hedging/netting,
- partial close,
- stop types,
- pending orders,
- volume precision,
- symbol naming,
- market hours.

Database tidak boleh memaksakan capability platform A kepada platform B.

---

# 30. Order/Position Semantics

Hubungan Order → Position harus dianggap konseptual, bukan universal one-to-one.

Kemungkinan:

- one order → one fill,
- one order → multiple fills,
- multiple orders → one position,
- one position → multiple deals,
- partial close,
- reversal,
- netting.

Model execution harus mengikuti broker/platform semantics.

---

# 31. Backtest Reproducibility

Backtest result harus dapat direproduksi.

Minimum reference:

- strategy version,
- parameter snapshot,
- dataset identity/version,
- symbol,
- timeframe,
- initial capital,
- fee model,
- spread/slippage assumption,
- execution model,
- engine version.

Parameter strategy yang berubah setelah backtest tidak boleh mengubah histori lama.

---

# 32. Copy Trading

Copy Trading membutuhkan pemisahan:

- source account,
- follower account,
- source strategy/trade,
- copied instruction,
- follower execution,
- mapping/correlation.

Copied order tidak selalu identik dengan source order karena broker, spread, latency, symbol, lot, dan risk rule dapat berbeda.

---

# 33. Risk Management

Risk decision harus dapat diaudit:

```text
Strategy
   ↓
Risk Policy
   ↓
Risk Decision
   ↓
Order Intent
   ↓
Execution
```

Jika order ditolak, alasan penolakan harus dapat direkonstruksi.

---

# 34. Workflow Integration

Workflow execution harus memiliki:

- workflow version,
- execution ID,
- status,
- start/end time,
- trigger source,
- correlation ID,
- error state.

Workflow version yang telah dipakai oleh histori execution sebaiknya immutable.

---

# 35. Plugin Integration

Plugin harus menggunakan version identity.

Plugin installation harus dapat diketahui:

- plugin,
- version,
- installation target,
- status,
- installed_at,
- removed_at bila applicable.

Database inti tidak boleh bergantung pada schema plugin yang tidak stabil.

---

# 36. Licensing & Subscription

Subscription dan License harus dipisahkan.

Subscription menangani plan/entitlement/billing state.

License menangani issued identity, assignment, activation, expiry, dan status.

Expired license tidak boleh menghapus histori.

---

# 37. Data Retention

Retention harus didefinisikan per domain.

| Data | Policy |
|---|---|
| Active trading state | Selama diperlukan |
| Trade history | Jangka panjang |
| Audit logs | Jangka panjang sesuai policy |
| API usage | Sesuai analytics/billing |
| Job history | Terbatas + archive |
| Notifications | Terbatas |
| Market data | Sesuai storage tier |
| Backtest metadata | Jangka panjang |
| Debug logs | Pendek |
| Secrets | Tidak disimpan sebagai histori biasa |

Retention final harus ditetapkan sebelum production.

---

# 38. Backup

Backup metadata harus mendukung:

- backup type,
- storage provider,
- checksum,
- encryption metadata,
- status,
- start/end time,
- creator,
- storage location.

Backup dianggap valid jika file tersedia, checksum valid, metadata konsisten, dan restore dapat dilakukan.

---

# 39. Restore Testing

Backup tanpa restore test bukan recovery strategy lengkap.

Minimum:

- periodic restore,
- integrity verification,
- schema compatibility,
- application connectivity,
- critical data validation.

Hasil restore test harus dicatat.

---

# 40. Disaster Recovery

OHTATS harus memiliki target:

- RPO,
- RTO,
- backup frequency,
- recovery procedure,
- recovery owner,
- failover strategy.

Nilai RPO/RTO final mengikuti deployment tier.

---

# 41. High Availability

High availability bukan hanya database replication.

Perlu mencakup:

- database,
- application,
- worker,
- broker connector,
- scheduler,
- storage,
- secrets,
- network dependency.

Database design hanya memberi fondasi data; HA penuh adalah tanggung jawab architecture/deployment layer.

---

# 42. Migration Governance

Semua perubahan schema wajib melalui migration versioning.

Tidak diperbolehkan:

- edit production schema manual tanpa migration,
- rename column tanpa migration,
- delete table tanpa dependency review,
- mengubah data semantics tanpa migration note.

Migration harus dapat diterapkan, diverifikasi, diaudit, dan dipulihkan bila memungkinkan.

---

# 43. Backward Compatibility

Untuk perubahan besar:

```text
Old Schema
   ↓
Compatible Schema
   ↓
Data Migration
   ↓
Application Migration
   ↓
Old Field Removal
```

Hindari destructive change langsung jika masih ada consumer lama.

---

# 44. ORM Rules

ORM hanya implementation layer.

ORM tidak boleh mengubah business rules blueprint.

Wajib:

- explicit relationships,
- explicit constraints,
- migration files,
- indexes,
- transaction handling,
- timestamp policy.

---

# 45. Database Engine Neutrality

`DATABASE_DESIGN.md` bersifat logical/physical-neutral.

Saat engine dipilih, review:

- UUID support,
- JSON,
- decimal precision,
- enum strategy,
- partial/filtered unique index,
- partitioning,
- transaction isolation,
- locking,
- replication,
- backup,
- migration tooling.

---

# 46. Enum Governance

ENUM cocok untuk state yang benar-benar stabil.

Nilai yang berkembang cepat dapat lebih cocok menggunakan reference table atau controlled vocabulary.

Keputusan final mengikuti database engine dan migration strategy.

---

# 47. JSON Governance

JSON cocok untuk flexible configuration, provider metadata, workflow payload, dan plugin metadata.

JSON tidak boleh menggantikan relational structure yang:

- sering dicari,
- memiliki FK,
- membutuhkan unique constraint,
- membutuhkan referential integrity.

---

# 48. Multi-Tenant Isolation

User ownership adalah security boundary.

Query user-owned resource harus menggunakan ownership scope.

Pola konseptual:

```text
WHERE user_id = ?
AND id = ?
```

atau database-level row security bila dipilih.

---

# 49. Authorization vs Ownership

Foreign key membuktikan hubungan data.

Foreign key tidak otomatis membuktikan authorization.

Authorization tetap harus diperiksa oleh service layer atau database policy.

---

# 50. Privacy

Data user harus memiliki klasifikasi:

- public metadata,
- operational data,
- sensitive data,
- secret data.

Sensitive data tidak boleh muncul dalam log atau error message.

---

# 51. Observability

Database observability harus mencakup:

- query latency,
- slow queries,
- connection usage,
- lock contention,
- transaction duration,
- replication lag bila ada,
- storage usage,
- index usage,
- error rate.

---

# 52. Data Integrity Rules

Business invariant penting harus ditegakkan sedekat mungkin dengan database.

Contoh:

- negative quantity tidak valid,
- negative retry count tidak valid,
- completion time < start time tidak valid,
- invalid state tidak valid,
- FK wajib valid,
- unique identity harus benar.

Application validation tetap diperlukan.

---

# 53. State Transition Governance

Status bukan sekadar label.

Contoh:

```text
PENDING
  ↓
QUEUED
  ↓
RUNNING
  ↓
COMPLETED
```

atau:

```text
RUNNING
  ↓
FAILED
  ↓
RETRY
  ↓
RUNNING
```

State transition ilegal harus ditolak oleh service/domain logic.

---

# 54. Reconciliation

Trading system wajib memiliki reconciliation:

```text
OHTATS State
     ↕
Broker State
```

Reconciliation mendeteksi:

- missing order,
- duplicate order,
- incorrect position,
- missing deal,
- quantity mismatch,
- price mismatch,
- balance mismatch.

---

# 55. Historical Immutability

Data historis trading yang finalized tidak boleh diubah sembarangan.

Contoh:

- executed deal,
- closed position,
- finalized backtest,
- audit event,
- billing/usage event.

Correction dilakukan melalui adjustment/correction event, bukan overwrite histori.

---

# 56. Current State vs Event History

Pisahkan secara konseptual:

### State

Keadaan sekarang.

### Event

Apa yang terjadi.

Contoh:

```text
Position State
```

dan:

```text
Position / Deal Events
```

Keduanya dapat diperlukan untuk reconciliation dan audit.

---

# 57. Documentation Consistency

Dokumen yang harus tetap sinkron:

- `DATABASE_DESIGN.md`
- `DATABASE_REVIEW.md`
- `ERD.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATA_FLOW.md`
- migration files
- ORM models.

Perubahan schema harus memicu dependency documentation review.

---

# 58. ERD Readiness

ERD belum dianggap final hanya karena database design sudah final.

ERD harus merepresentasikan:

- primary key,
- foreign key,
- cardinality,
- nullable relationship,
- major associative entities,
- domain boundaries.

ERD harus diperbarui setelah schema review selesai.

---

# 59. Implementation Gate

Database implementation hanya boleh dimulai setelah:

- [x] Logical database blueprint tersedia.
- [x] Core domains terdefinisi.
- [x] Primary key strategy terdefinisi.
- [x] Foreign key strategy terdefinisi.
- [x] Index strategy tersedia.
- [x] Soft delete policy tersedia.
- [x] Audit requirement tersedia.
- [x] Backup metadata tersedia.
- [x] Job queue model tersedia.
- [x] API usage model tersedia.
- [ ] Database engine dipilih secara resmi.
- [ ] Migration tool dipilih.
- [ ] ORM/data-access standard ditetapkan.
- [ ] UTC policy diterapkan.
- [ ] Idempotency implementation ditetapkan.
- [ ] Secret-management implementation ditetapkan.
- [ ] Tenant isolation implementation ditetapkan.
- [ ] Retention policy ditetapkan.
- [ ] RPO/RTO ditetapkan.
- [ ] ERD disinkronkan dengan implementation schema.
- [ ] Load-test baseline tersedia.

---

# 60. Definition of Ready — Database Implementation

Database dianggap **READY FOR IMPLEMENTATION** jika:

1. engine sudah dipilih,
2. migration strategy sudah dipilih,
3. ORM/data access pattern sudah ditetapkan,
4. security boundary sudah jelas,
5. secret strategy sudah jelas,
6. transaction policy sudah jelas,
7. idempotency strategy sudah jelas,
8. timestamp policy sudah jelas,
9. monetary precision policy sudah jelas,
10. retention policy sudah jelas,
11. backup/restore plan sudah jelas,
12. ERD sudah sinkron.

---

# 61. Definition of Done — Database Implementation

Database implementation dianggap selesai jika:

- semua migration dapat dijalankan dari database kosong,
- migration berjalan berurutan,
- constraints aktif,
- foreign keys valid,
- indexes tersedia,
- seed/reference data valid,
- integrity test lulus,
- authorization test lulus,
- tenant isolation test lulus,
- transaction test lulus,
- idempotency test lulus,
- backup test lulus,
- restore test lulus,
- observability tersedia,
- schema dan documentation sinkron.

---

# 62. Recommended Implementation Order

```text
1. Database Engine
        ↓
2. Migration Framework
        ↓
3. Core Identity
        ↓
4. User / Role / Permission
        ↓
5. Broker / Platform
        ↓
6. Trading Account
        ↓
7. Symbol / Broker Symbol Mapping
        ↓
8. Strategy
        ↓
9. Risk Management
        ↓
10. Orders
        ↓
11. Positions
        ↓
12. Deals / Execution
        ↓
13. Audit
        ↓
14. Workflow
        ↓
15. Job Queue
        ↓
16. AI Provider / AI Session
        ↓
17. Backtest
        ↓
18. Copy Trading
        ↓
19. Notification
        ↓
20. API Usage
        ↓
21. Backup Metadata
        ↓
22. Analytics / Historical Storage
```

---

# 63. Final Risk Register

## CRITICAL

### DBR-001 — Tenant Isolation

**Risk:** User A dapat membaca/menulis data User B.

**Control:** Ownership scope wajib diverifikasi pada service/query layer dan, bila dipilih, database row-level security.

**Gate:** Tidak boleh production sebelum isolation test lulus.

### DBR-002 — Trading Idempotency

**Risk:** Retry dapat menghasilkan duplicate order.

**Control:** Idempotency key + broker correlation + unique scope.

**Gate:** Tidak boleh live trading sebelum retry test lulus.

### DBR-003 — Audit Integrity

**Risk:** Histori aktivitas dapat diubah sehingga investigasi tidak dapat dipercaya.

**Control:** Append-oriented audit model + restricted update/delete.

### DBR-004 — Secret Leakage

**Risk:** Credential masuk database/log/job payload.

**Control:** Secret reference/encryption + sanitization.

---

# 64. High Priority Risks

### DBR-005 — Monetary Precision

Tetapkan decimal precision dan rounding policy sebelum migration final.

### DBR-006 — Timezone

Gunakan UTC sebagai canonical storage.

### DBR-007 — Platform Execution Semantics

Jangan menyamakan model MT4/MT5/TradingView.

### DBR-008 — Historical Data Growth

Rencanakan archival/partitioning/time-series strategy sebelum volume production besar.

### DBR-009 — Job Retry

Retry harus idempotent.

### DBR-010 — Migration Discipline

Semua perubahan schema harus melalui migration.

---

# 65. Acceptance Criteria

`DATABASE_REVIEW.md` dianggap final apabila:

- review mencakup domain utama,
- risk register tersedia,
- implementation gates tersedia,
- security controls tersedia,
- trading integrity controls tersedia,
- backup/recovery controls tersedia,
- performance considerations tersedia,
- migration governance tersedia,
- Definition of Ready tersedia,
- Definition of Done tersedia.

---

# 66. Final Decision

## DATABASE REVIEW RESULT

**APPROVED AS LOGICAL DATABASE BLUEPRINT**

`DATABASE_DESIGN.md` tetap menjadi baseline resmi.

`DATABASE_REVIEW.md` menjadi:

- review record,
- risk register,
- implementation checklist,
- governance reference,
- quality gate.

Tidak ada kebutuhan untuk melakukan redesign total database pada tahap ini.

Perubahan berikutnya harus dilakukan secara **incremental, versioned, dan terdokumentasi**.

---

# 67. Next Phase

Setelah `DATABASE_REVIEW.md` disimpan dan di-commit:

```text
DATABASE_DESIGN.md
        ↓
DATABASE_REVIEW.md
        ↓
ERD.md
        ↓
DATABASE IMPLEMENTATION SPECIFICATION
        ↓
Migration / ORM
        ↓
Database Tests
```

`ERD.md` menjadi langkah berikutnya karena repository saat ini menunjukkan file tersebut masih kosong.

---

# 68. Finalization Record

| Item | Status |
|---|---|
| Database Design | FINAL |
| Database Review | FINAL |
| Logical Integrity Review | COMPLETE |
| Security Review | COMPLETE |
| Trading Integrity Review | COMPLETE |
| Performance Review | COMPLETE |
| Backup/Recovery Review | COMPLETE |
| Migration Governance | COMPLETE |
| Implementation Gates | COMPLETE |
| Risk Register | COMPLETE |
| Definition of Ready | COMPLETE |
| Definition of Done | COMPLETE |
| ERD Synchronization | NEXT PHASE |

---

# END OF DATABASE_REVIEW.md
