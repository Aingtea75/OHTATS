# OHTATS Security Foundation

> Dokumen ini mendefinisikan security foundation canonical OHTATS sebagai cross-cutting control.
> Security melindungi identity, authorization, secrets, tenant isolation, trading controls,
> AI/plugin boundaries, auditability, dan environment isolation.
>
> Security **bukan** pengganti domain owner. Risk Manager tetap authority untuk risk decision.
> Trading Engine tetap owner trading lifecycle. Connector tetap vendor boundary.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** Security foundation reference

---

# 1. Purpose

Security Foundation memastikan OHTATS dapat dioperasikan secara aman dengan:

- authentication dan authorization yang jelas;
- isolasi tenant, user, dan account;
- perlindungan secret dan credential;
- pencegahan bypass terhadap Risk Manager dan Trading Engine;
- audit trail untuk aksi kritis;
- isolasi backtest/simulation dari live;
- kontrol terhadap AI, workflow, plugin, API, dan connector.

---

# 2. Security Principles

1. **Secure by Design** — kontrol keamanan tertanam di boundary, bukan afterthought.
2. **Least Privilege** — akses hanya sesuai role, capability, dan entitlement.
3. **Fail Closed** — kondisi authorization/security yang tidak tersedia menghentikan aksi executable.
4. **Defense in Depth** — autentikasi, otorisasi, policy, risk, audit berlapis.
5. **No Secret in Repository** — credential, API key, token, dan secret tidak disimpan di source control.
6. **Tenant Isolation** — data dan aksi satu tenant tidak boleh bocor ke tenant lain.
7. **Canonical Control Path** — tidak ada jalur alternatif ke broker.
8. **Auditability** — aksi kritis harus dapat ditelusuri.
9. **Separation of Duties** — domain ownership tidak digabung secara tidak sah.
10. **Reproducible Security Evidence** — keputusan dan event keamanan dapat direkonstruksi.

---

# 3. Security Boundary

```text
Client / API / MCP / Plugin / AI / Workflow
                |
                v
        Authentication
                |
                v
        Authorization / Policy
                |
                v
        Domain Action (Risk / Trading / ...)
                |
                v
        Audit / Observability
```

Security controls bersifat cross-cutting dan diterapkan melalui komponen serta boundary yang ditetapkan oleh Architecture dan domain blueprint terkait.

Dokumen ini tidak memperkenalkan Security & Audit Manager sebagai module atau domain owner baru.

Domain engines tetap memiliki ownership domain masing-masing.

---

# 4. Trust Boundaries

Trust boundary utama:

| Boundary | Inside | Outside |
|---|---|---|
| Platform core | OHTATS domain/services | External brokers, AI providers, market data, notification providers |
| Tenant | Tenant-owned resources | Other tenants |
| User session | Authenticated principal + grants | Unauthenticated callers |
| Live trading | Live environment + live credentials | Test/paper/backtest environments |
| Plugin runtime | Granted capabilities | Ungranted system privileges |
| Secret store | Secret manager references | Application logs, business tables, source repo |

Data dan command yang melewati trust boundary harus divalidasi, diotorisasi, dan diaudit sesuai sensitivitasnya.

---

# 5. Authentication

Authentication menetapkan identity pemanggil.

Persyaratan minimal:

- identity unik per user/service principal;
- credential policy (password/token/key) sesuai konfigurasi aman;
- session/token lifecycle yang eksplisit;
- invalidasi session pada logout, revoke, atau compromise;
- dukungan multi-factor bila diaktifkan oleh policy;
- service-to-service authentication untuk internal/automation paths.

Authentication gagal harus fail closed dan menghasilkan security event yang relevan.

---

# 6. Authorization

Authorization menetapkan apakah identity berhak melakukan aksi pada resource.

Aturan:

- setiap aksi sensitif memerlukan authorization check;
- authorization mengacu role, permission, entitlement, resource ownership, dan tenant scope;
- deny by default untuk aksi yang tidak secara eksplisit diizinkan;
- elevation of privilege dilarang tanpa governance path;
- human approval tidak boleh menggantikan Risk Manager atau Trading Engine.

---

# 7. RBAC / Permission Model

Model akses berbasis role dan permission (RBAC), dapat dilengkapi capability/entitlement.

Konsep minimal:

- **Role** — kumpulan permission;
- **Permission** — aksi terhadap resource type;
- **Resource scope** — tenant/account/strategy/dll.;
- **Entitlement** — hak berbasis license/subscription bila berlaku.

Permission trading, risk, configuration, admin, dan audit harus dipisahkan.
Role admin tidak otomatis berarti boleh bypass risk/trading controls.

---

# 8. Tenant Isolation

Setiap tenant adalah security and data boundary.

Wajib:

- query dan command selalu scoped ke tenant yang sah;
- tidak ada cross-tenant read/write tanpa explicit authorized admin path yang diaudit;
- secret, connection, strategy, trading account, dan audit history terikat tenant;
- plugin dan AI context tidak boleh mencampur data tenant.

Pelanggaran tenant isolation adalah security incident kelas tinggi.

---

# 9. User / Account Isolation

Selain tenant isolation:

- user hanya mengakses resource yang diizinkan role/ownership-nya;
- trading account isolation harus dijaga antar user dalam tenant yang sama bila policy mengharuskan;
- shared access harus eksplisit, least privilege, dan auditable;
- service accounts tidak memakai credential user manusia untuk aksi otomatis bila dapat dihindari.

---

# 10. API Security

API adalah entry point utama dan harus:

- mengautentikasi pemanggil;
- mengotorisasi setiap operasi;
- memvalidasi input/schema;
- menerapkan rate limiting dan abuse controls;
- menghindari verbose error yang membocorkan secret/internal detail;
- mendukung request correlation identifiers;
- tidak mengekspos broker command langsung.

API versioning tidak boleh melemahkan kontrol keamanan yang sudah ada tanpa review.

---

# 11. Trading Command Security

Setiap executable trading action harus melewati canonical path:

```text
User / API / AI / Workflow / Copy
        ↓
Trading Request
        ↓
Authorization
        ↓
Validation
        ↓
Risk Manager
        ↓
Trading Engine
        ↓
Connector
        ↓
Broker / Platform
```

Dilarang:

- API → Broker langsung;
- AI → Broker langsung;
- Workflow → Broker langsung;
- Plugin → Broker langsung;
- Copy Trading → Connector langsung.

Trading command security memastikan identity, authorization, validation, risk decision, dan audit context hadir sebelum submission.

---

# 12. Risk Gate Security

Risk Manager adalah mandatory gate.

Security requirements:

- risk deny/halt tidak boleh di-override diam-diam oleh layer lain;
- risk policy changes harus authorized dan auditable;
- risk evaluation yang gagal/unavailable harus fail closed untuk executable actions;
- AI/strategy/workflow/copy tidak memiliki risk authority.

Security melindungi integritas risk gate; Risk Manager tetap domain owner untuk risk decision.

---

# 13. AI Security

AI adalah capability provider, bukan privileged execution channel.

Kontrol:

- AI output divalidasi (schema/structure) sebelum dipakai domain;
- AI output bukan broker command;
- prompt/context tidak boleh menyertakan secret;
- provider credentials hanya via secret reference;
- untrusted model output diperlakukan sebagai untrusted input;
- AI usage dan keputusan relevan harus auditable bila memengaruhi aksi executable.

Provider-agnostic abstraction tidak mengurangi kewajiban authorization dan risk.

---

# 14. Workflow Security

Workflow Engine adalah orchestrator.

Kontrol:

- trigger workflow memerlukan authorization;
- step yang menghasilkan side effect harus idempotent/authorized;
- workflow tidak boleh mengirim broker command langsung;
- human approval step tidak bypass Risk Manager/Trading Engine/Security;
- workflow version published immutable untuk traceability.

---

# 15. Connector Security

Connector berada di integration boundary.

Kontrol:

- hanya menerima canonical command dari Trading Engine / authorized integration path;
- tidak mengimplementasikan business risk policy sebagai pengganti Risk Manager;
- credential broker/platform hanya melalui secret reference;
- capability detection tidak menjadi backdoor execution;
- error/timeout ditangani tanpa blind retry yang menduplikasi order;
- vendor-specific data tidak boleh membocorkan secret ke log.

---

# 16. Broker Credential / Secret Handling

Broker credentials adalah high-sensitivity secrets.

Aturan:

- disimpan di secret manager / secure secret boundary;
- direferensikan oleh reference/id, bukan plaintext di business tables;
- tidak di-commit ke repository;
- tidak di-log;
- rotasi dan revoke harus didukung;
- akses secret least privilege dan diaudit.

---

# 17. Plugin Security

Plugin berjalan dengan capability grants.

Kontrol:

- plugin identity/version diketahui;
- permission/capability eksplisit;
- plugin tidak memperoleh privilege di luar grant;
- plugin tidak boleh bypass security, risk, trading, atau audit;
- plugin tidak boleh mengakses secret di luar grant;
- installation/activation/deactivation diaudit.

---

# 18. Plugin Marketplace Security

Marketplace mendistribusikan komponen, bukan mengeksekusi trading.

Kontrol:

- metadata dan compatibility diverifikasi;
- publication memerlukan authorization;
- paket diperlakukan sebagai untrusted input hingga divalidasi;
- entitlement marketplace tidak menggantikan trading authorization;
- supply-chain checks (integrity/signature bila diterapkan) sebelum aktivasi.

---

# 19. Webhook Security

Webhook inbound/outbound harus:

- mengautentikasi sumber (signature/token/mTLS sesuai desain);
- memvalidasi payload;
- melindungi dari replay;
- menerapkan authorization sebelum side effect;
- tidak mengeksekusi broker command di luar canonical path;
- mencatat security-relevant failures.

---

# 20. Event Security

Event mendukung integrasi dan audit, tetapi:

- event bukan pengganti authoritative financial state;
- consumer harus idempotent;
- event sensitif tidak boleh berisi secret;
- publish/consume mengikuti authorization dan tenant scope;
- historical event tidak diubah diam-diam.

---

# 21. Message / Queue Security

Bila message queue digunakan:

- akses queue terautentikasi dan terotorisasi;
- payload tidak menyimpan plaintext secrets;
- poison/dead-letter handling tidak boleh me-replay aksi berbahaya tanpa kontrol;
- ordering/idempotency dihormati untuk aksi finansial;
- transport diamankan (encryption in transit).

---

# 22. Database Security

Database mengikuti canonical schema (`DATABASE_DESIGN.md` / `ERD.md`).

Kontrol:

- credentials database via secret boundary;
- least privilege DB roles;
- tenant isolation enforced di application queries dan, bila memungkinkan, di kontrol tambahan;
- historical financial records immutable sesuai aturan database;
- tidak menyimpan secret broker sebagai kolom business plaintext;
- migration hanya melalui change-control resmi.

Security blueprint **tidak** membuat schema baru.

---

# 23. Encryption at Rest

Data sensitif at rest dilindungi sesuai environment policy:

- volume/disk encryption di infrastructure bila tersedia;
- field-level protection untuk secret material melalui secret manager;
- backup encryption sesuai backup security policy.

Implementasi konkret mengikuti configuration dan infrastructure standards, tanpa mengubah ownership domain.

---

# 24. Encryption in Transit

Semua komunikasi eksternal dan antar-komponen sensitif menggunakan saluran terenkripsi (TLS atau setara) sesuai standar deployment.

Dilarang mengirim credential atau token melalui saluran jelas di production.

---

# 25. Secret Management

Secret management adalah boundary tersendiri.

Aturan:

- centralize secrets di secret store;
- application hanya menyimpan reference;
- rotation, revocation, dan access audit didukung;
- environment separation (dev/test/stage/prod) wajib;
- larangan hardcode di source, container image, atau ticket.

---

# 26. Token / Session Security

Token/session harus:

- memiliki expiry;
- dapat di-revoke;
- terikat identity dan scope;
- dilindungi dari theft (secure storage client-side, HttpOnly/Secure attributes bila web cookie);
- tidak dilog dalam bentuk penuh;
- diputar pada privilege change bila policy mengharuskan.

---

# 27. Audit Security

Audit trail untuk aksi kritis harus:

- append-only dari sudut pandang aplikasi;
- mengidentifikasi actor, aksi, resource, hasil, timestamp, correlation id;
- mencakup authentication failures, authorization denials, configuration changes, risk policy changes, trading actions, AI decisions yang relevan, plugin lifecycle, dan admin actions;
- dilindungi dari tampering oleh role biasa.

Logging operasional tidak menggantikan audit records.

---

# 28. Logging Security

Log harus:

- structured bila memungkinkan;
- redaction terhadap secrets, tokens, passwords, raw credentials;
- menghindari PII berlebih di luar kebutuhan operasional;
- memiliki retensi sesuai policy;
- tidak menjadi saluran exfiltration.

---

# 29. Sensitive Data Handling

Klasifikasikan data minimal:

- public;
- internal;
- confidential (account, strategy proprietary, trading state);
- secret (credentials, API keys);
- restricted financial/PII.

Penanganan mengikuti klasifikasi: akses least privilege, encryption, audit, dan retensi.

---

# 30. PII / Financial Data Protection

PII dan data finansial:

- dikumpulkan seminimal mungkin;
- diakses hanya oleh role berwenang;
- tidak diekspos ke AI provider tanpa kebutuhan dan kontrol;
- tidak dikirim ke plugin untrusted tanpa grant;
- dilindungi pada backup dan export.

---

# 31. Rate Limiting

Rate limiting diterapkan pada:

- authentication endpoints;
- public/API endpoints;
- trading request submission (policy-dependent);
- AI provider calls;
- webhook ingress.

Tujuan: mengurangi abuse, brute force, dan overload — bukan menggantikan risk limits finansial.

---

# 32. Replay Protection

Mekanisme anti-replay untuk:

- webhook signatures/timestamps;
- idempotency keys pada trading requests;
- one-time tokens bila digunakan;
- authentication challenges.

Replay trading request harus aman karena idempotency domain, bukan karena diizinkan menduplikasi order.

---

# 33. Idempotency Security

Idempotency melindungi dari duplicate side effects.

Security aspects:

- idempotency keys tidak boleh dapat ditebak untuk merebut request orang lain;
- scope key terikat tenant/account/actor sesuai desain;
- konflik idempotency diaudit;
- Trading Engine tetap canonical owner idempotency trading executable commands.

---

# 34. Abuse Prevention

Kontrol abuse mencakup:

- rate limits;
- anomaly detection hooks;
- CAPTCHA/MFA challenges bila relevan pada entry points;
- pemblokiran bot/pattern berbahaya sesuai policy;
- pembatasan resource untuk backtest/AI/jobs.

---

# 35. Brute Force Protection

Authentication dan sensitive endpoints dilindungi dari brute force melalui:

- attempt limiting;
- progressive delay/lockout policy;
- alert pada pola mencurigakan;
- tidak mengungkapkan apakah username atau password yang salah secara berlebihan bila policy mengharuskan.

---

# 36. Account Lock / Recovery

Account lock dan recovery harus:

- authorized dan auditable;
- memiliki jalur recovery yang terverifikasi;
- tidak melemahkan authentication guarantees;
- mendukung revoke session/token terkait;
- membedakan lock keamanan vs lock administratif/trading halt.

Trading halt (risk/ops) berbeda dari account authentication lock, meski keduanya dapat berinteraksi.

---

# 37. AI Prompt Injection / Untrusted Input Handling

Input ke AI dan output dari AI adalah untrusted kecuali dibuktikan sebaliknya.

Kontrol:

- separasi instruction vs untrusted content bila memungkinkan;
- validasi structured output;
- larangan mengeksekusi tool/broker call langsung dari raw model text;
- filter/secret redaction pada context;
- monitoring untuk pola injection yang dikenal.

---

# 38. External Provider Security

External providers (AI, broker, market data, notification):

- diakses via adapter/connector;
- diautentikasi dengan secret reference;
- dibatasi timeout/retry policy;
- tidak dipercaya sebagai source of authorization OHTATS;
- kegagalan provider tidak boleh menjadi implicit allow untuk aksi berbahaya.

---

# 39. Supply Chain / Dependency Security

Kontrol supply chain:

- dependency pin/lock sesuai praktik project;
- review dependency baru yang menyentuh security boundary;
- tidak menjalankan untrusted install scripts di production tanpa kontrol;
- image/artifact integrity bila digunakan;
- plugin/marketplace packages divalidasi sebelum aktivasi.

---

# 40. Security Monitoring

Monitoring keamanan mencakup:

- authentication failure rates;
- authorization denials;
- secret access anomalies;
- privilege changes;
- trading control bypass attempts;
- connector authentication failures;
- plugin permission violations;
- rate-limit triggers.

Alerting diarahkan ke operational/security response paths yang ditentukan.

---

# 41. Security Incident Response

Incident response minimal:

1. detect;
2. contain (revoke tokens, disable connector, halt trading scope bila perlu);
3. eradicate;
4. recover;
5. post-incident review;
6. audit evidence preservation.

Kill-switch/emergency halt dapat digunakan sebagai containment untuk trading scope sesuai policy Risk/Operations — bukan pengganti forensik.

---

# 42. Kill Switch / Emergency Security Controls

Emergency controls mendukung:

- platform/tenant/account trading halt;
- connector disable;
- plugin disable;
- API key/session revoke;
- secret rotation.

Aktivasi harus authorized, auditable, dan memiliki clear recovery criteria.
Risk Manager / authorized operational control memiliki authority atas trading halt policy sebagaimana blueprint risk.

---

# 43. Backtest vs Live Isolation

Backtest/simulation:

- tidak memiliki live credentials;
- tidak memanggil live connector;
- tidak memutasi live trading state;
- ditandai environment/context eksplisit;
- diuji isolation-nya.

Pelanggaran isolasi dianggap defect keamanan kelas tinggi.

---

# 44. Environment Isolation

| Environment | Live Broker | Production Secrets | Production Data |
|---|---|---|---|
| Development | No | No | No |
| Test/CI | No | No | No |
| Staging | No / controlled non-prod | Non-prod | Non-prod |
| Paper/Forward | No | Non-prod dedicated | Dedicated |
| Production | Yes (controlled) | Yes (controlled) | Yes |

Production secrets tidak digunakan di non-production tests.

---

# 45. Production Security

Production mengharuskan:

- encryption in transit;
- secret management aktif;
- least privilege access;
- audit logging aktif;
- monitoring/alerting;
- backup/recovery teruji;
- change control untuk konfigurasi kritis;
- no debug backdoors.

---

# 46. Secure Configuration

Konfigurasi:

- dipisahkan dari code;
- divalidasi sebelum apply;
- environment-specific;
- tidak mengandung plaintext secrets di file yang di-commit;
- perubahan konfigurasi sensitif diaudit.

Mengikuti `CONFIGURATION_STANDARD.md` bila tersedia.

---

# 47. Security Testing

Selaras `TESTING_STRATEGY.md`:

- authn/authz tests;
- tenant isolation tests;
- secret leakage checks di CI;
- negative tests untuk bypass attempts (AI/workflow/plugin/API → broker);
- connector credential handling tests (non-live);
- permission/capability tests untuk plugin.

Security tests tidak menempatkan live order.

---

# 48. Vulnerability Management

Proses:

- track known vulnerabilities pada dependency/runtime;
- prioritaskan fix berdasarkan severity dan exposure;
- temporary mitigations didokumentasikan;
- evidence remediasi disimpan sesuai policy.

---

# 49. Backup / Recovery Security

Backup:

- terenkripsi sesuai policy;
- akses least privilege;
- diuji restore secara berkala;
- tidak menjadi saluran recovery credential yang tidak terkontrol;
- retention selaras compliance/ops needs.

---

# 50. Compliance Boundary

Security foundation mendukung kebutuhan compliance generik (audit trail, access control, data protection) tanpa mengklaim sertifikasi spesifik di dokumen ini.

Requirement compliance yurisdiksi tertentu harus ditambahkan melalui change-control terpisah bila diperlukan.

---

# 51. Security Auditability

Minimal event yang harus dapat diaudit:

- login/logout/failures;
- permission/role changes;
- secret access/use (metadata, bukan nilai secret);
- configuration security changes;
- trading request authorization outcomes;
- risk policy changes;
- connector credential updates;
- plugin install/activate/deactivate;
- emergency halt activation/clear;
- administrative overrides (jika ada, harus jarang dan berizin).

---

# 52. Security Failure Modes

Contoh failure mode dan respons:

| Failure | Expected behavior |
|---|---|
| Auth service unavailable | Fail closed untuk aksi terlindungi |
| Authorization data stale/unknown | Deny |
| Secret store unavailable | Jangan submit broker command yang butuh secret |
| Risk service unavailable | Deny executable trading |
| Connector auth failure | No blind retry storm; alert + controlled recovery |
| Suspected credential leak | Revoke/rotate + incident response |
| Tenant isolation breach attempt | Deny + security event |

---

# 53. Security Acceptance Criteria

Security foundation siap diajukan ke review lanjutan bila:

- principles dan trust boundaries jelas;
- authentication/authorization/RBAC didefinisikan;
- tenant/user/account isolation eksplisit;
- canonical trading path dilindungi dari bypass;
- Risk Manager dan Trading Engine ownership tidak digeser;
- AI/Workflow/Plugin/API tidak mendapat broker direct access;
- secret handling melarang repo/plaintext business storage;
- backtest/live isolation tegas;
- audit/logging security didefinisikan;
- emergency controls dan incident response ada;
- tidak ada schema database baru yang diperkenalkan dokumen ini;
- status governance = REVIEW (bukan APPROVED/LOCKED tanpa human approval).

---

# 54. Future Security Extension Rules

Perluasan (WAF, advanced SIEM, formal compliance packs, hardware key support, dsb.) harus:

- tidak mengubah canonical trading path;
- tidak memindahkan risk authority keluar Risk Manager;
- tidak memindahkan trading lifecycle keluar Trading Engine;
- melalui review bila mengubah control wajib;
- menghormati status governance Constitution.

---

# Related Documents

- `PROJECT_CONSTITUTION.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `ERD.md`
- `API_DESIGN.md`
- `AI_ARCHITECTURE.md`
- `AI_PROVIDER.md`
- `PLUGIN_SYSTEM.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `WORKFLOW_ENGINE.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`
- `TESTING_STRATEGY.md`
- `CONFIGURATION_STANDARD.md`
- `ERROR_HANDLING.md`
- `EVENT_SYSTEM.md`

---

# END OF SECURITY.md
