# OHTATS Workflow Engine

> Dokumen ini mendefinisikan blueprint teknis Workflow Engine OHTATS sebagai domain orchestration engine. `SYSTEM_DESIGN.md` menjadi sumber fungsi tingkat sistem, `ARCHITECTURE.md` menjadi sumber boundary teknis, `MODULE_SPECIFICATION.md` menjadi sumber ownership modul, `DATABASE_DESIGN.md` menjadi sumber desain data, dan `EVENT_SYSTEM.md` serta `DATA_FLOW.md` menjadi sumber kontrak event dan alur data.

---

# Status

**WORKFLOW ENGINE BASELINE — REVIEW**

**Version:** 1.0.0

**Authority:** Workflow domain reference

**Scope:** Global platform

---

# 1. Tujuan

Workflow Engine mengorkestrasi rangkaian langkah bisnis/platform yang dapat dipicu oleh command, event, schedule, atau kondisi yang telah didefinisikan. Workflow Engine mengelola urutan, state, transition, retry, timeout, failure handling, dan observability tanpa mengambil alih ownership domain lain.

Workflow Engine adalah **orchestrator**, bukan pengganti AI Manager, Risk Manager, Trading Engine, Backtest Engine, Copy Trading Engine, Connector, atau Security/Audit Manager.

---

# 2. Prinsip Utama

Workflow Engine harus mengikuti prinsip berikut:

1. **Single orchestration responsibility** — workflow mengatur proses, bukan memiliki master state domain lain.
2. **Explicit definition** — workflow harus mempunyai definition dan version yang dapat diidentifikasi.
3. **Immutable published version** — version workflow yang sudah dipublikasikan tidak boleh diubah secara in-place.
4. **Deterministic execution state** — setiap execution mempunyai state yang dapat diaudit.
5. **Idempotent execution** — retry tidak boleh menghasilkan duplicate side effect yang tidak diinginkan.
6. **Controlled transitions** — perpindahan state hanya melalui transition yang valid.
7. **Risk-first** — workflow tidak boleh melewati Risk Manager untuk executable trading action.
8. **Canonical trading path** — workflow tidak boleh mengirim broker command secara langsung.
9. **Provider agnostic** — workflow tidak bergantung langsung pada vendor AI, broker, exchange, atau platform tertentu.
10. **Event-driven but bounded** — event dapat memicu workflow, tetapi event bukan jalur eksekusi alternatif yang melewati domain authority.
11. **Tenant isolation** — workflow execution tidak boleh mencampur ownership atau state tenant/account yang berbeda.
12. **Auditable** — command, transition, retry, failure, dan terminal result harus dapat ditelusuri.
13. **Reproducible where required** — workflow version dan input context yang diperlukan untuk operasi kritis harus dapat direkonstruksi.
14. **Fail closed for authorization** — workflow tidak boleh meneruskan executable action ketika authorization atau required control tidak tersedia.
15. **No hidden side effects** — setiap external side effect harus berasal dari step yang eksplisit dan memiliki contract.

---

# 3. System Boundary

```text
Trigger / Client / Event / Scheduler
                |
                v
        Workflow Engine
                |
        Workflow Definition
                |
        Workflow Version
                |
        Execution State
                |
        Step / Transition
                |
        Domain Service Contract
                |
      +---------+---------+
      |         |         |
     AI      Strategy    Risk
      |         |         |
      +---------+---------+
                |
          Trading Engine
                |
            Connector
                |
       Broker / Platform
```

Workflow Engine berada di dalam OHTATS core. External systems tetap berada di luar boundary OHTATS dan hanya diakses melalui contract/adapter/connector yang sesuai.

---

# 4. Ownership

## 4.1 Workflow Engine Owns

Workflow Engine memiliki authority atas:

- workflow definition reference;
- workflow version reference;
- workflow step definition;
- workflow transition definition;
- workflow execution state;
- workflow execution step state;
- retry state;
- timeout state;
- failure handling state;
- orchestration correlation/idempotency context;
- workflow execution audit metadata.

## 4.2 Workflow Engine Does Not Own

Workflow Engine tidak memiliki canonical ownership atas:

- AI model/provider state;
- strategy master/version;
- risk policy/rule/decision;
- trading request/order/execution/deal/position;
- broker account state;
- market data master;
- backtest result;
- copy-trading master/follower/rule state;
- authentication/authorization policy;
- audit ledger owned by Security/Audit Manager.

Workflow hanya menyimpan reference/context yang diperlukan untuk orkestrasi.

---

# 5. Workflow Definition Model

Workflow terdiri dari:

```text
Workflow
  |
  +-- Workflow Version
        |
        +-- Step 1
        +-- Step 2
        +-- Step N
        |
        +-- Transition Rules
```

Workflow version yang telah published harus immutable. Perubahan workflow dilakukan dengan membuat version baru.

Workflow execution selalu menunjuk satu workflow version tertentu sehingga histori execution dapat ditelusuri terhadap definisi yang digunakan saat execution dibuat.

---

# 6. Step Model

Setiap step minimal mempunyai:

- stable step identifier;
- step type;
- input contract;
- output contract;
- timeout policy;
- retry policy;
- failure policy;
- authorization requirement;
- idempotency requirement;
- observability metadata.

Step type dapat mencakup:

- domain service invocation;
- decision/condition evaluation;
- event emission;
- wait/signal;
- scheduled delay;
- notification;
- data transformation;
- human approval;
- terminal success;
- terminal failure.

Step tidak boleh menyimpan atau mengubah canonical master state milik domain lain secara langsung.

---

# 7. Execution State Machine

Workflow execution menggunakan state yang eksplisit.

```text
PENDING
   |
   v
RUNNING
   |
   +----> WAITING
   |          |
   |          +----> RUNNING
   |
   +----> RETRYING
   |          |
   |          +----> RUNNING
   |
   +----> COMPLETED
   |
   +----> FAILED
   |
   +----> CANCELLED
   |
   +----> TIMED_OUT
```

Aturan:

- `PENDING` berarti execution sudah dibuat tetapi belum mulai.
- `RUNNING` berarti step aktif diproses.
- `WAITING` berarti execution menunggu signal, timer, external completion, atau approval yang sah.
- `RETRYING` berarti step yang gagal sedang dijadwalkan untuk retry sesuai policy.
- `COMPLETED` adalah terminal success state.
- `FAILED` adalah terminal failure state setelah failure policy habis atau failure bersifat non-retryable.
- `CANCELLED` adalah terminal state akibat cancellation yang sah.
- `TIMED_OUT` adalah terminal state ketika timeout policy mengharuskan termination.

Tidak boleh ada transition implisit di luar state machine.

---

# 8. Transition Rules

Transition harus:

1. berasal dari state yang valid;
2. menuju state yang valid;
3. mempunyai trigger yang dapat diidentifikasi;
4. mencatat timestamp dan correlation context;
5. dapat diaudit;
6. tidak mengubah ownership domain lain;
7. menghormati authorization dan policy.

Contoh:

```text
RUNNING + step_success  -> RUNNING / COMPLETED
RUNNING + wait_required -> WAITING
RUNNING + retryable_error -> RETRYING
RUNNING + fatal_error -> FAILED
WAITING + valid_signal -> RUNNING
RUNNING + cancellation -> CANCELLED
RUNNING + timeout -> TIMED_OUT
```

---

# 9. Trigger Model

Workflow dapat dimulai melalui:

- explicit application command;
- domain event;
- scheduler/job trigger;
- approved external signal;
- internal workflow chaining.

Trigger harus memiliki:

- trigger type;
- source;
- correlation identifier;
- tenant/user context;
- timestamp;
- authorization context;
- idempotency key bila diperlukan.

Event trigger tidak boleh otomatis dianggap sebagai izin eksekusi trading.

---

# 10. Trading Boundary

Workflow dapat mengorkestrasi trading use case, tetapi **tidak boleh** mengirim broker/platform command secara langsung.

Canonical path:

```text
Workflow
   |
   v
Trading Request
   |
   v
Risk Manager
   |
   +---- DENY / HALT
   |
   +---- APPROVE
           |
           v
     Trading Engine
           |
           v
       Connector
           |
           v
   Broker / Platform
```

Workflow tidak boleh membuat `order`, `execution`, `deal`, atau `position` secara langsung.

Workflow tidak boleh mengubah risk decision setelah Risk Manager menetapkannya.

---

# 11. AI Boundary

Workflow dapat memanggil AI Manager untuk analysis atau decision support.

```text
Workflow
   |
   v
AI Manager
   |
Structured AI Output
   |
Policy / Validation
   |
Risk / Domain Service
```

AI output bukan broker command.

Workflow tidak boleh menggunakan AI response sebagai bypass terhadap authorization, risk, trading, audit, atau security controls.

---

# 12. Copy Trading Boundary

Workflow dapat memulai atau mengorkestrasi proses copy-trading, tetapi tidak boleh membuat follower broker command secara langsung.

```text
Workflow
   |
   v
Copy Trading Engine
   |
Copy Policy / Mapping
   |
Follower Trading Request
   |
Risk Manager
   |
Trading Engine
```

Setiap follower tetap melewati risk evaluation dan canonical trading pipeline.

---

# 13. Backtest Boundary

Workflow dapat memulai backtest, tetapi backtest execution harus tetap berada dalam simulation boundary.

```text
Workflow
   |
   v
Backtest Engine
   |
Simulation State
   |
Backtest Result
```

Backtest workflow tidak boleh menghasilkan live broker command atau mengubah live trading state secara diam-diam.

---

# 14. Retry and Idempotency

Retry wajib mempertimbangkan apakah step mempunyai side effect.

## 14.1 Pure Step

Step tanpa external side effect dapat diulang dengan aman selama input contract sama.

## 14.2 Side-effect Step

Step yang menghasilkan command atau external side effect harus mempunyai idempotency key atau mekanisme deduplication yang setara.

```text
execution_id + step_id + attempt_context
```

Retry tidak boleh menghasilkan duplicate order, duplicate notification yang tidak diinginkan, duplicate copy execution, atau duplicate external command.

Workflow Engine tidak menggantikan idempotency mechanism milik Trading Engine.

---

# 15. Timeout

Setiap long-running atau external step harus memiliki timeout policy.

Timeout harus menghasilkan state yang eksplisit dan tidak boleh dianggap sebagai successful completion.

Untuk trading-related step, timeout pada Workflow tidak boleh secara otomatis diasumsikan sebagai broker rejection atau broker success. Status canonical harus diperoleh dari Trading Engine/Connector reconciliation.

---

# 16. Failure Handling

Failure diklasifikasikan minimal sebagai:

- validation failure;
- authorization failure;
- policy failure;
- transient failure;
- dependency failure;
- timeout;
- non-retryable business failure;
- system failure;
- external reconciliation required.

Workflow harus menerapkan failure policy yang sesuai:

```text
Failure
  |
  +-- retry
  |
  +-- wait/recover
  |
  +-- compensate
  |
  +-- fail execution
  |
  +-- escalate
```

Compensation bukan rollback database lintas domain secara otomatis. Compensation harus menggunakan contract domain yang sah.

---

# 17. Cancellation

Cancellation harus:

- memverifikasi authorization;
- mencatat actor/source;
- menghentikan step yang dapat dihentikan secara aman;
- tidak menghapus histori execution;
- tidak membatalkan external side effect tanpa domain-specific cancellation contract.

Cancellation terhadap workflow trading tidak sama dengan cancellation terhadap order broker. Order cancellation tetap merupakan tanggung jawab Trading Engine dan connector flow.

---

# 18. Concurrency

Workflow Engine harus mencegah dua execution/attempt yang tidak kompatibel memodifikasi workflow state yang sama secara bersamaan.

Concurrency control dapat menggunakan:

- optimistic locking/version number;
- atomic state transition;
- execution lease/lock;
- idempotency key;
- queue serialization bila diperlukan.

Mekanisme konkret implementasi dapat ditentukan pada tahap implementation design tanpa mengubah ownership blueprint.

---

# 19. Persistence Mapping

Workflow Engine menggunakan entity yang sudah didefinisikan oleh Database Design dan ERD:

```text
workflows
workflow_versions
workflow_steps
workflow_executions
workflow_execution_steps
```

Module tidak otomatis berarti table baru.

Workflow Engine tidak boleh membuat duplicate entity untuk trading, risk, AI, market data, backtest, atau copy trading hanya karena workflow membutuhkan reference terhadap entity tersebut.

---

# 20. Event Integration

Workflow Engine dapat menjadi producer dan consumer event sesuai contract Event System.

Contoh event:

```text
workflow.started
workflow.step.started
workflow.step.completed
workflow.step.failed
workflow.waiting
workflow.retry.scheduled
workflow.completed
workflow.failed
workflow.cancelled
workflow.timed_out
```

Event harus membawa correlation/causation context yang diperlukan untuk tracing.

Event publication tidak boleh dianggap sebagai atomic guarantee terhadap external side effect kecuali contract domain menyatakannya demikian.

---

# 21. Security and Authorization

Workflow execution harus menghormati:

- authentication;
- authorization;
- tenant isolation;
- role/policy restrictions;
- secret access policy;
- audit requirements.

Workflow tidak boleh menyimpan secret plaintext dalam workflow definition atau execution payload.

Workflow step yang membutuhkan privileged operation harus meminta domain/service yang mempunyai authority tersebut.

---

# 22. Observability

Minimal observability:

- workflow execution id;
- workflow version;
- step id;
- attempt number;
- correlation id;
- causation id bila tersedia;
- start/end timestamp;
- duration;
- state transition;
- error classification;
- terminal result.

Observability tidak boleh mengubah business truth atau canonical transaction state.

---

# 23. Auditability

Operasi kritis harus dapat ditelusuri:

```text
Trigger
  ↓
Workflow Execution
  ↓
Step
  ↓
Transition
  ↓
Domain Service Call
  ↓
Domain Result / Event
```

Untuk trading-related workflow, audit chain harus dapat menghubungkan workflow execution dengan trading request dan risk decision tanpa membuat duplicate transaction owner.

---

# 24. Tenant and Account Isolation

Workflow execution harus mempertahankan context:

- tenant;
- user/actor bila relevan;
- account context bila relevan;
- authorization scope;
- correlation context.

Workflow tidak boleh menggunakan execution milik tenant/account lain sebagai input tanpa authorization dan contract yang sah.

---

# 25. Acceptance Criteria

Workflow Engine baseline dianggap memenuhi requirement apabila:

- workflow definition/version mempunyai ownership jelas;
- published version immutable;
- execution state eksplisit;
- transition tervalidasi;
- retry mempunyai idempotency policy;
- timeout mempunyai state yang jelas;
- failure handling terdokumentasi;
- cancellation terdokumentasi;
- concurrency control didefinisikan;
- event integration mempunyai boundary;
- trading tidak dapat bypass Risk/Trading Engine;
- AI tidak menjadi privileged execution path;
- Copy Trading tetap melewati normal risk/trading pipeline;
- Backtest tetap terisolasi dari live execution;
- persistence menggunakan entity workflow canonical;
- tenant/security boundary terdokumentasi;
- auditability dan observability tersedia;
- tidak ada duplicate master ownership.

---

# 26. Cross-Document Consistency

Workflow Engine harus konsisten dengan:

- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `ERD.md`
- `EVENT_SYSTEM.md`
- `DATA_FLOW.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`

Jika terjadi konflik ownership, dokumen canonical yang lebih tinggi harus menjadi sumber penyelesaian sesuai governance OHTATS. Workflow Engine tidak boleh memperkenalkan authority baru yang bertentangan dengan domain owner.

---

# 27. Finalization Gate

Dokumen ini **belum final** pada saat dibuat.

Status final hanya dapat diberikan setelah:

1. cross-document audit selesai;
2. database/ERD consistency diverifikasi;
3. event/data-flow consistency diverifikasi;
4. trading/risk/backtest/copy boundaries diverifikasi;
5. security/audit/tenant boundary diverifikasi;
6. acceptance criteria terpenuhi;
7. perubahan dilakukan melalui branch kerja;
8. Pull Request dibuat;
9. independent review dilakukan oleh reviewer yang berbeda dari pembuat PR;
10. approval dan merge dilakukan sesuai governance repository.

---

# 28. Change Control

Perubahan terhadap workflow blueprint harus dilakukan melalui Pull Request.

Tidak ada perubahan langsung ke `master` sebagai bagian dari workflow finalization.

Setiap perubahan harus menjelaskan:

- alasan perubahan;
- dokumen yang terdampak;
- ownership yang terdampak;
- database/ERD impact;
- event/data-flow impact;
- backward compatibility impact;
- risk/security/audit impact.

---

# End of Document
