# OHTATS Testing Strategy

> Dokumen ini mendefinisikan strategi pengujian canonical OHTATS.
> Status: **REVIEW**
>
> Dokumen ini harus konsisten dengan `PROJECT_CONSTITUTION.md`,
> `ARCHITECTURE.md`, `MODULE_SPECIFICATION.md`, `TRADING_ENGINE.md`,
> `RISK_MANAGEMENT.md`, `WORKFLOW_ENGINE.md`, `AI_ARCHITECTURE.md`,
> `DATABASE_DESIGN.md`, dan `ERD.md`.

---

# 1. Purpose

Testing Strategy memastikan setiap komponen OHTATS dapat diverifikasi
secara sistematis, dapat direproduksi, dan tidak membahayakan live trading
atau data produksi.

Tujuan utama:

- menjamin correctness behavior modul;
- melindungi boundary arsitektur;
- mencegah bypass Risk Manager, Trading Engine, Authorization, dan Audit;
- memastikan isolasi simulation dari live environment;
- menyediakan quality gate sebelum release.

---

# 2. Scope

Strategi ini mencakup:

- Unit Testing
- Integration Testing
- Contract Testing
- System / End-to-End Testing
- Security Testing
- Trading Simulation Testing
- Backtest Validation
- Paper Trading
- Forward Testing
- Connector Testing
- API Testing
- Database / Migration Testing
- Workflow Testing
- AI Boundary Testing
- Risk Gate Testing
- Idempotency Testing
- Failure / Recovery Testing
- Data Integrity Testing
- Performance Testing
- CI Quality Gates

Strategi ini **tidak** mencakup redesign architecture, perubahan schema
canonical, atau pelaksanaan live trading di environment uji.

---

# 3. Testing Principles

1. **Documentation First** — acceptance criteria di blueprint menjadi dasar test.
2. **Risk First** — setiap jalur executable trading harus melewati Risk Gate.
3. **No Live Bypass** — test tidak boleh menghasilkan live broker command.
4. **Isolation** — simulation, paper, dan live environment dipisahkan.
5. **Reproducibility** — test hasil harus dapat diulang dengan input yang sama.
6. **Determinism where required** — Risk Gate, state machine, dan pure logic harus deterministic.
7. **Idempotency** — retry tidak menghasilkan side effect ganda yang tidak diinginkan.
8. **Fail Closed** — authorization / policy / risk yang tidak tersedia menghentikan executable action.
9. **No Secret in Repo** — credential, API key, dan secret tidak disimpan di source control.
10. **Auditability** — evidence test dan hasil penting harus dapat ditelusuri.
11. **Boundary Respect** — AI, Workflow, Plugin, API, dan Connector tidak boleh membuat jalur trading alternatif.
12. **Canonical Path** — Trading Request → Validation → Authorization → Risk → Order → Connector → Execution → Deal → Position → Audit/Reconciliation.

---

# 4. Test Pyramid

```text
                   /\\n                  /  \\
                 / E2E \\
                /------\\
               / System  \\
              /----------\\
             / Integration \\
            /--------------\\
           /   Unit Tests   \\
          /------------------\\
```

- **Unit** — mayoritas, cepat, fokus logic murni.
- **Integration** — interaksi modul dengan dependency terkontrol.
- **System / E2E** — jalur bisnis end-to-end di environment non-live.
- **Live / Paper / Forward** — sangat terbatas, terisolasi, dan berizin khusus.

---

# 5. Unit Testing

Fokus:

- pure domain logic;
- state machine transition;
- validation rules;
- risk rule evaluation (dengan input deterministic);
- payload transformation;
- error classification;
- idempotency key generation logic.

Aturan:

- tidak mengakses broker live;
- tidak mengakses production database;
- tidak memanggil AI provider eksternal secara default;
- mock/stub dependency external.

---

# 6. Integration Testing

Fokus:

- modul ↔ modul contract;
- service ↔ database (test DB);
- event producer/consumer;
- outbox / message handling;
- workflow step orchestration dengan domain service mock;
- trading request creation + risk evaluation + order path (non-live).

Aturan:

- gunakan test database / container terisolasi;
- jangan memakai production credentials;
- jangan submit order ke broker live.

---

# 7. Contract Testing

Fokus:

- API request/response schema;
- event payload contract;
- module interface contract;
- connector adapter contract (request/response shape);
- AI structured output schema validation.

Contract test mencegah drift antar modul tanpa harus menjalankan full system.

---

# 8. System / E2E Testing

Fokus:

- alur bisnis lengkap di environment non-live;
- user → API → domain → risk → trading request → simulated execution;
- workflow orchestration end-to-end;
- backtest run end-to-end;
- copy-trading mapping + risk path (simulated).

Aturan:

- hanya environment dedicated test / staging non-production;
- tidak menggunakan live broker account;
- hasil harus reproducible sejauh mungkin.

---

# 9. Security Testing

Minimal mencakup:

- authentication failure cases;
- authorization / permission denial;
- tenant isolation checks;
- secret leakage prevention;
- input validation / injection resistance;
- privilege escalation attempts;
- audit log generation untuk aksi sensitif.

Security test wajib fail-closed pada authorization yang tidak valid.

---

# 10. Trading Simulation Testing

Simulation testing memverifikasi trading lifecycle tanpa broker live.

Cakupan:

- trading request lifecycle;
- order state transitions;
- partial fill / multiple execution;
- deal → position aggregation;
- cancellation path;
- reconciliation after simulated timeout/network failure.

Simulation **tidak boleh** mengirim command ke broker produksi.

---

# 11. Backtest Validation

Backtest harus:

- menggunakan strategy version + dataset version;
- reproducible (engine version + configuration + checksum bila tersedia);
- terisolasi dari live connector;
- tidak menghasilkan live broker command;
- tidak mengubah live trading state.

Validasi mencakup look-ahead bias control, data leakage control, dan metric consistency.

---

# 12. Paper Trading

Paper trading adalah environment quasi-real yang:

- menggunakan market data realistis bila tersedia;
- tidak menempatkan order live;
- tetap melewati Risk Gate dan Trading Engine path;
- menghasilkan audit trail yang dapat dibandingkan dengan live behavior.

Paper trading memerlukan konfigurasi environment yang eksplisit dan terpisah.

---

# 13. Forward Testing

Forward testing berjalan di masa depan dengan data real-time atau near-real-time,
namun tetap non-live execution kecuali diizinkan secara eksplisit oleh governance
dan environment control.

Forward testing tidak menggantikan Risk Gate atau authorization.

---

# 14. Connector Testing

Connector diuji melalui:

- contract tests terhadap adapter interface;
- simulated broker responses;
- error/timeout/retry behavior;
- capability detection (order types, symbols, sessions);
- reconciliation hooks.

Connector **tidak** boleh menjadi jalur trading alternatif yang melewati
Trading Engine atau Risk Manager.

---

# 15. API Testing

Cakupan:

- authentication & authorization;
- request validation;
- response schema;
- error mapping;
- rate limiting behavior (bila ada);
- idempotency headers/keys bila diterapkan;
- tenant isolation pada resource access.

API tidak boleh mengekspos broker command langsung.

---

# 16. Database / Migration Testing

Cakupan:

- migration up/down (bila didukung);
- constraint & foreign key integrity;
- uniqueness rules;
- append-only behavior untuk historical tables;
- soft-delete vs hard lifecycle rules;
- data integrity setelah migration.

Migration test dijalankan pada database test terisolasi.

Tidak mengubah `DATABASE_DESIGN.md` / `ERD.md` tanpa change-control formal.

---

# 17. Workflow Testing

Cakupan:

- definition / version immutability;
- execution state machine transitions;
- retry / timeout / failure / cancellation policies;
- step contract invocation;
- event emission;
- authorization pada trigger dan human approval step.

Workflow tidak boleh mengirim broker command secara langsung dan tidak boleh
membypass Risk Manager atau Trading Engine.

---

# 18. AI Boundary Testing

Cakupan:

- AI output schema validation;
- AI decision tidak menjadi broker command;
- AI path tetap melewati policy / validation / risk / trading pipeline;
- provider failure handling;
- prompt/version reproducibility bila relevan.

AI tidak memperoleh execution privilege bypass.

---

# 19. Risk Gate Testing

Risk Gate harus diuji secara deterministic dengan input terkontrol.

Cakupan:

- approve / deny / halt decisions;
- policy version behavior;
- rule priority;
- revalidation requirements;
- circuit breaker / emergency halt;
- fail-closed when risk service unavailable.

Setiap executable trading path harus dapat dibuktikan melewati Risk Gate.

---

# 20. Idempotency Testing

Cakupan:

- duplicate request dengan idempotency key yang sama;
- retry setelah transient failure;
- exactly-once / at-least-once semantics sesuai domain contract;
- tidak menghasilkan duplicate order / notification / copy execution yang tidak diinginkan.

Idempotency canonical untuk trading tetap menjadi tanggung jawab domain Trading Engine.

---

# 21. Failure / Recovery Testing

Cakupan:

- transient dependency failure;
- timeout handling;
- compensation / safe retry;
- recovery setelah crash mid-execution;
- reconciliation setelah external uncertainty;
- dead-letter / poison message handling (bila message queue digunakan).

Timeout tidak boleh otomatis dipetakan sebagai success external.

---

# 22. Data Integrity Testing

Cakupan:

- referential integrity;
- monetary/price/quantity precision;
- append-only historical records;
- no silent mutation of published versions (strategy, workflow, prompt, dataset);
- tenant data isolation.

---

# 23. Performance Testing

Dilakukan secara bertahap sesuai kebutuhan phase:

- latency critical path (risk + order decision);
- throughput API;
- backtest engine performance pada dataset besar;
- message/event processing lag;
- database query hotspots.

Performance test tidak menggantikan correctness test.

---

# 24. CI Quality Gates

Minimal quality gate sebelum merge ke branch utama:

- lint / static analysis sesuai standar project;
- unit tests lulus;
- integration tests relevan lulus;
- contract tests relevan lulus;
- no secret detected in changes;
- required reviewers / governance checks terpenuhi.

Gate dapat diperluas per phase roadmap tanpa mengubah prinsip isolasi live.

---

# 25. Test Environment Isolation

Environment wajib dipisahkan:

| Environment | Live Broker | Production DB | Production Secrets |
|-------------|-------------|---------------|--------------------|
| Unit        | No          | No            | No                 |
| Integration | No          | No (test DB)  | No                 |
| System/E2E  | No          | No            | No                 |
| Paper       | No          | Dedicated     | Dedicated non-prod |
| Forward     | Controlled  | Dedicated     | Dedicated          |
| Live        | Yes         | Yes           | Yes (controlled)   |

Production credentials tidak boleh digunakan di unit/integration/system tests.

---

# 26. Live Trading Safety Rules

1. Live trading hanya diizinkan di environment live yang dikontrol.
2. Tidak ada automated test yang menempatkan live order tanpa explicit controlled harness dan approval.
3. Kill-switch / emergency halt harus dapat diuji di non-live dan diverifikasi ketersediaannya di live.
4. Setiap live action harus meninggalkan audit trail.
5. Risk Gate tetap wajib di live.

---

# 27. Definition of Done (Testing Perspective)

Sebuah perubahan dianggap done dari sisi testing jika:

- acceptance criteria blueprint terkait terpetakan ke test;
- unit/integration/contract yang relevan lulus;
- boundary safety (Risk / Trading / AI / Workflow) tidak dilanggar;
- tidak ada secret yang ter-commit;
- evidence test tersedia di CI atau artefak yang disepakati;
- regression penting tidak rusak.

---

# 28. Acceptance Criteria

Testing Strategy diterima sebagai baseline REVIEW jika:

- prinsip isolasi live jelas;
- canonical trading path dijaga;
- Risk Gate dapat diuji deterministic;
- AI / Workflow / Connector tidak diberi bypass;
- backtest dan simulation terisolasi;
- CI quality gates didefinisikan;
- tidak bertentangan dengan Constitution dan Architecture.

---

# 29. Test Evidence / Reporting

Evidence minimal:

- CI pipeline result;
- test report (pass/fail counts);
- coverage summary bila diaktifkan;
- artifact untuk system/backtest runs yang relevan;
- catatan failure triage bila gate gagal.

Evidence disimpan sesuai kebijakan retensi project, bukan di source control sebagai secret.

---

# 30. Future Extension Rules

Perluasan testing (chaos, advanced performance, formal verification, dsb.)
harus:

- tidak mengubah ownership domain;
- tidak membuka jalur broker langsung;
- melalui review bila mengubah quality gate wajib;
- tetap menghormati status governance dokumen terkait.

---

# Related Documents

- `PROJECT_CONSTITUTION.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `WORKFLOW_ENGINE.md`
- `AI_ARCHITECTURE.md`
- `BACKTEST_ENGINE.md`
- `DATABASE_DESIGN.md`
- `ERD.md`
- `ERROR_HANDLING.md`
- `SECURITY.md` (bila telah diisi)

---

# END OF TESTING_STRATEGY.md
