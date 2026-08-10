# OHTATS Implementation Roadmap

> Dokumen ini menjadi jembatan dari Blueprint menuju Implementation,
> Testing, dan Release.
>
> Status: **REVIEW**
>
> Roadmap **bukan** architecture document. Architecture tetap berada di
> `ARCHITECTURE.md`, `SYSTEM_DESIGN.md`, dan dokumen domain terkait.

---

# 1. Purpose

Roadmap mengatur urutan kerja implementasi agar:

- menghormati dependency arsitektur;
- menjaga canonical trading path;
- tidak membuka bypass Risk / Trading / AI / Workflow;
- memiliki testing gate di setiap phase;
- dapat diaudit dan dihentikan dengan aman bila diperlukan.

---

# 2. Canonical Constraints (Non-Negotiable)

1. **Canonical Trading Path**

```text
Trading Request
  → Validation
  → Authorization / Policy
  → Risk
  → Order
  → Connector
  → Execution / Deal
  → Position
  → Audit / Reconciliation
```

2. AI **tidak** boleh mengirim broker command secara langsung.
3. Workflow **tidak** boleh mengirim broker command secara langsung.
4. API **tidak** boleh mengirim broker command secara langsung.
5. Connector **tidak** boleh menjadi jalur trading alternatif di luar Trading Engine.
6. Backtest / Simulation **tidak** boleh menggunakan production credentials atau mengubah live state.
7. Perubahan schema canonical hanya melalui change-control formal terhadap `DATABASE_DESIGN.md` / `ERD.md`.

---

# 3. Phase Overview

| Phase | Name |
|------:|------|
| 0 | Governance & Baseline |
| 1 | Engineering Foundation |
| 2 | Persistence & Core Data |
| 3 | Strategy & Risk |
| 4 | Trading Core |
| 5 | Connector Layer |
| 6 | Workflow & AI |
| 7 | Backtest |
| 8 | Copy Trading |
| 9 | Plugin System |
| 10 | Reporting / Notification / Operations |
| 11 | Client Layer |
| 12 | Production Readiness |

---

# PHASE 0 — Governance & Baseline

**Objective**  
Mengunci fondasi dokumentasi dan aturan kerja sebelum coding besar.

**Scope**  
- Constitution, Index, Vision, Architecture, Module Spec  
- Database Design / ERD baseline  
- Testing Strategy & Roadmap (dokumen ini)  
- Coding & Configuration standards

**Dependencies**  
Tidak ada (fase awal).

**Deliverables**  
- Blueprint foundation lengkap dan berstatus jelas  
- Testing Strategy (REVIEW/APPROVED sesuai proses)  
- Roadmap (REVIEW/APPROVED sesuai proses)

**Acceptance Criteria**  
- Source of truth = Git repository  
- Status governance hanya: DRAFT / REVIEW / APPROVED / LOCKED / DEPRECATED  
- Tidak ada implementasi fitur besar tanpa blueprint

**Testing Gate**  
- Review dokumentasi  
- Konsistensi cross-document

**Exit Criteria**  
Foundation documents tersedia dan dapat dijadikan acuan implementasi.

**Risks / Constraints**  
Mengubah dokumen LOCKED tanpa review formal dilarang.

---

# PHASE 1 — Engineering Foundation

**Objective**  
Menyiapkan skeleton repositori, tooling, dan standar engineering.

**Scope**  
- Repository structure  
- Lint, formatter, pre-commit  
- CI skeleton  
- Config loading pattern  
- Logging skeleton  
- Error type conventions  
- Secret handling pattern (no plaintext secrets)

**Dependencies**  
Phase 0.

**Deliverables**  
- Runnable project skeleton  
- CI yang menjalankan lint + unit placeholder  
- `.env.example` tanpa secret nyata

**Acceptance Criteria**  
- CI hijau untuk quality gate dasar  
- Tidak ada secret di repository  
- Struktur folder selaras module ownership

**Testing Gate**  
- Lint  
- Unit smoke tests

**Exit Criteria**  
Developer dapat menjalankan test pipeline lokal dan CI.

**Risks / Constraints**  
Jangan mengimplementasikan trading logic di fase ini.

---

# PHASE 2 — Persistence & Core Data

**Objective**  
Membangun persistence layer sesuai DATABASE_DESIGN / ERD tanpa drift schema.

**Scope**  
- Migration framework  
- Core identity & security tables  
- Instrument / broker / platform masters  
- Basic repository/DAO patterns  
- Migration testing

**Dependencies**  
Phase 1.

**Deliverables**  
- Migrations untuk domain inti  
- Test DB setup  
- Data access patterns yang konsisten

**Acceptance Criteria**  
- Schema mengikuti `DATABASE_DESIGN.md`  
- FK/unique constraints dihormati  
- Migration test lulus di environment test

**Testing Gate**  
- Migration tests  
- Integrity tests

**Exit Criteria**  
Core data dapat di-create/read secara aman di test environment.

**Risks / Constraints**  
Dilarang menambah table/column canonical tanpa change-control.

---

# PHASE 3 — Strategy & Risk

**Objective**  
Mengimplementasikan strategy versioning dan Risk Manager sebagai gate wajib.

**Scope**  
- Strategy identity + immutable versions  
- Risk policies / rules  
- Deterministic risk evaluation service  
- Risk events (append-only)

**Dependencies**  
Phase 2.

**Deliverables**  
- Strategy version lifecycle  
- Risk Gate API/service  
- Unit + integration tests untuk risk decisions

**Acceptance Criteria**  
- Published strategy version immutable  
- Risk Gate menghasilkan decision deterministic untuk input yang sama  
- Fail-closed bila risk dependency tidak tersedia

**Testing Gate**  
- Unit tests risk rules  
- Integration tests risk path  
- Authorization tests pada perubahan policy

**Exit Criteria**  
Risk Gate siap dipanggil oleh Trading Core.

**Risks / Constraints**  
Risk tidak boleh di-bypass oleh AI/Workflow/API.

---

# PHASE 4 — Trading Core

**Objective**  
Mengimplementasikan trading lifecycle canonical tanpa connector live.

**Scope**  
- Trading Request  
- Order / Order Events  
- Execution / Deal / Position  
- Idempotency keys  
- Reconciliation hooks (internal)  
- Audit evidence generation

**Dependencies**  
Phase 3.

**Deliverables**  
- Trading domain services  
- State machines  
- Simulation execution path

**Acceptance Criteria**  
- Semua executable path melewati Risk Gate  
- Tidak ada direct broker call dari domain core  
- Idempotent request handling teruji

**Testing Gate**  
- Unit + integration trading lifecycle  
- Simulation tests  
- Idempotency tests  
- Failure/recovery tests

**Exit Criteria**  
Trading Core stabil di simulation environment.

**Risks / Constraints**  
Jangan menghubungkan live broker di fase ini.

---

# PHASE 5 — Connector Layer

**Objective**  
Menyediakan adapter boundary ke platform eksternal tanpa mengubah core model.

**Scope**  
- Connector interface  
- MT4 / MT5 / REST / lainnya sebagai adapter  
- Capability detection  
- Timeout / retry / error mapping  
- Reconciliation dengan Trading Core

**Dependencies**  
Phase 4.

**Deliverables**  
- Connector contracts  
- Minimal one simulated or sandbox adapter  
- Connector tests

**Acceptance Criteria**  
- Connector tidak menerima command di luar Trading Engine  
- External uncertainty ditangani via reconciliation  
- Secrets hanya via secret reference

**Testing Gate**  
- Contract tests  
- Simulated broker response tests  
- Timeout/failure tests

**Exit Criteria**  
Satu jalur connector non-live terhubung end-to-end dengan Trading Core.

**Risks / Constraints**  
Vendor-specific model tidak boleh menjadi canonical core.

---

# PHASE 6 — Workflow & AI

**Objective**  
Mengorkestrasi proses bisnis dan AI decision support tanpa execution bypass.

**Scope**  
- Workflow Engine orchestration  
- AI provider abstraction  
- Structured AI output validation  
- Human approval step (opsional)  
- Event integration

**Dependencies**  
Phase 4 (dan Phase 5 bila workflow membutuhkan connector status).

**Deliverables**  
- Workflow definition/version/execution  
- AI request/response/decision pipeline  
- Boundary tests

**Acceptance Criteria**  
- Workflow tidak mengirim broker command langsung  
- AI decision bukan broker command  
- Semua executable tetap melalui Risk + Trading path

**Testing Gate**  
- Workflow state machine tests  
- AI boundary tests  
- Authorization tests

**Exit Criteria**  
Workflow + AI dapat dijalankan di non-live dengan audit trail.

**Risks / Constraints**  
Dilarang AI → Broker atau Workflow → Broker langsung.

---

# PHASE 7 — Backtest

**Objective**  
Menyediakan historical simulation yang reproducible dan terisolasi.

**Scope**  
- Backtest engine  
- Dataset versioning references  
- Strategy version binding  
- Metrics  
- Isolation dari live connector

**Dependencies**  
Phase 3 dan data market (Phase 2+).

**Deliverables**  
- Backtest run pipeline  
- Reproducibility metadata  
- Validation tests

**Acceptance Criteria**  
- Backtest tidak menempatkan live order  
- Run menunjuk strategy version + dataset version  
- Hasil dapat dibandingkan antar run dengan input sama

**Testing Gate**  
- Backtest validation tests  
- Isolation tests

**Exit Criteria**  
Backtest dapat dijalankan secara mandiri dan aman.

**Risks / Constraints**  
Look-ahead bias dan data leakage harus dikontrol.

---

# PHASE 8 — Copy Trading

**Objective**  
Mengimplementasikan copy trading yang tetap melewati Risk + Trading path.

**Scope**  
- Master/follower mapping  
- Rules  
- Symbol mapping  
- Copy execution → target trading request

**Dependencies**  
Phase 4 dan Phase 5.

**Deliverables**  
- Copy trading domain  
- Mapping + rule evaluation  
- Tests

**Acceptance Criteria**  
- Follower order tetap melalui Risk Gate  
- Tidak insert deal target secara langsung  
- Isolation tenant terjaga

**Testing Gate**  
- Mapping tests  
- Risk path tests  
- Failure tests

**Exit Criteria**  
Copy path non-live teruji end-to-end.

**Risks / Constraints**  
Copy trading bukan jalur trading paralel yang independen risk.

---

# PHASE 9 — Plugin System

**Objective**  
Memungkinkan ekstensi modular dengan capability boundary ketat.

**Scope**  
- Plugin identity/version  
- Installation lifecycle  
- Capability grants  
- Sandbox/permission rules

**Dependencies**  
Phase 1–2; integrasi domain sesuai kebutuhan.

**Deliverables**  
- Plugin loader/lifecycle  
- Permission model  
- Tests

**Acceptance Criteria**  
- Plugin tidak memperoleh privilege di luar grant  
- Plugin tidak dapat bypass risk/trading/audit

**Testing Gate**  
- Capability tests  
- Isolation tests

**Exit Criteria**  
Plugin sample dapat dimuat dengan aman.

**Risks / Constraints**  
Plugin marketplace (jika ada) tidak melemahkan security boundary.

---

# PHASE 10 — Reporting / Notification / Operations

**Objective**  
Menyediakan observasi, notifikasi, dan operasional dasar.

**Scope**  
- Notifications  
- Basic reporting  
- Jobs / scheduler  
- Monitoring hooks  
- Backup metadata (bukan policy penuh)

**Dependencies**  
Core domains yang relevan.

**Deliverables**  
- Notification pipeline  
- Job execution records  
- Operational endpoints/scripts dasar

**Acceptance Criteria**  
- Tidak ada secret di log  
- Job failures tercatat  
- Notification delivery status terlacak

**Testing Gate**  
- Notification tests  
- Job failure/recovery tests

**Exit Criteria**  
Operasional dasar dapat dijalankan di staging.

**Risks / Constraints**  
Jangan mencampur operational transient state ke canonical business tables tanpa desain.

---

# PHASE 11 — Client Layer

**Objective**  
Menyediakan antarmuka klien (API consumers / dashboard) tanpa memecah boundary.

**Scope**  
- API clients  
- Dashboard minimal (bila diprioritaskan)  
- Auth flows  
- Read models yang aman

**Dependencies**  
API contracts dan domain phases terkait.

**Deliverables**  
- Client integration  
- UI/API smoke flows (non-live)

**Acceptance Criteria**  
- Client tidak memanggil broker langsung  
- Authorization ditegakkan  
- Tenant isolation di UI/API

**Testing Gate**  
- API e2e non-live  
- Authz tests

**Exit Criteria**  
Alur klien utama berjalan di staging.

**Risks / Constraints**  
UI tidak menjadi sumber otoritas trading.

---

# PHASE 12 — Production Readiness

**Objective**  
Menyiapkan rilis produksi yang aman dan dapat dioperasikan.

**Scope**  
- Hardening security  
- Observability lengkap  
- Backup/restore drills  
- Runbooks  
- Load/performance sesuai target  
- Go-live checklist  
- Kill-switch verification

**Dependencies**  
Phases sebelumnya yang masuk scope rilis.

**Deliverables**  
- Production checklist  
- Verified backup/restore  
- Incident response basics  
- Final security review

**Acceptance Criteria**  
- Live safety rules terpenuhi  
- Risk Gate dan audit aktif  
- Secrets managed di luar repo  
- Rollback plan ada

**Testing Gate**  
- Full CI gates  
- Staging e2e  
- Security checks  
- Controlled paper/forward evidence bila disyaratkan

**Exit Criteria**  
Go-live decision oleh human governance, bukan otomatis.

**Risks / Constraints**  
Tidak ada auto-merge ke produksi tanpa approval manusia.

---

# 4. Cross-Phase Testing Gates (Summary)

Setiap phase wajib memiliki:

- unit tests untuk logic baru;
- integration tests bila menyentuh boundary;
- contract tests bila mengubah interface;
- bukti bahwa Risk / Trading / AI / Workflow boundary tidak dilanggar;
- larangan penggunaan production secrets di non-live tests.

---

# 5. Change Control Reminder

- Status dokumen: DRAFT → REVIEW → APPROVED → LOCKED → DEPRECATED.
- Jangan menaikkan status ke APPROVED/LOCKED tanpa human approval.
- Perubahan architecture/schema canonical memerlukan review lintas dokumen.

---

# 6. Related Documents

- `PROJECT_CONSTITUTION.md`
- `INDEX.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `ERD.md`
- `TESTING_STRATEGY.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `WORKFLOW_ENGINE.md`
- `AI_ARCHITECTURE.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`

---

# END OF ROADMAP.md
