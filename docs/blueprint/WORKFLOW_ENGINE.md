# OHTATS Workflow Engine

> Dokumen ini mendefinisikan blueprint teknis Workflow Engine OHTATS sebagai domain orchestration engine. `SYSTEM_DESIGN.md` menjadi sumber fungsi tingkat sistem, `ARCHITECTURE.md` menjadi sumber boundary teknis, `MODULE_SPECIFICATION.md` menjadi sumber ownership modul, `DATABASE_DESIGN.md` menjadi sumber desain data, dan `EVENT_SYSTEM.md` serta `DATA_FLOW.md` menjadi sumber kontrak event dan alur data.

---

# Status

**WORKFLOW ENGINE BASELINE — REVIEW**

**Version:** 1.0.1

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
2. **Explicit definition** — workflow mempunyai definition dan version yang dapat diidentifikasi.
3. **Immutable published version** — published version tidak boleh diubah in-place.
4. **Deterministic execution state** — setiap execution mempunyai state yang dapat ditelusuri.
5. **Idempotent execution** — retry tidak boleh menghasilkan duplicate side effect yang tidak diinginkan.
6. **Controlled transitions** — perpindahan state hanya melalui transition yang valid.
7. **Risk-first** — executable trading action tidak boleh melewati Risk Manager.
8. **Canonical trading path** — workflow tidak mengirim broker command secara langsung.
9. **Provider agnostic** — workflow tidak bergantung langsung pada vendor AI, broker, exchange, atau platform tertentu.
10. **Event-driven but bounded** — event dapat memicu workflow, tetapi bukan jalur bypass domain authority.
11. **Tenant isolation** — execution tidak boleh mencampur ownership tenant/account.
12. **Auditable** — command, transition, retry, failure, dan terminal result harus dapat ditelusuri.
13. **Reproducible where required** — workflow version dan input context kritis harus dapat direkonstruksi.
14. **Fail closed for authorization** — executable action berhenti ketika authorization/control wajib tidak tersedia.
15. **No hidden side effects** — setiap external side effect berasal dari step eksplisit dengan contract.
16. **Database alignment** — blueprint tidak boleh mengasumsikan kolom/entity persistence yang belum ditetapkan oleh `DATABASE_DESIGN.md`.

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
- orchestration control state;
- correlation/idempotency handling context;
- workflow execution observability metadata.

Retry, timeout, failure, dan idempotency **adalah orchestration responsibilities**, tetapi persistence detailnya dibatasi oleh schema canonical yang telah ditetapkan `DATABASE_DESIGN.md`.

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
RUNNING + step_success       -> RUNNING / COMPLETED
RUNNING + wait_required      -> WAITING
RUNNING + retryable_error    -> RETRYING
RUNNING + fatal_error        -> FAILED
WAITING + valid_signal       -> RUNNING
RUNNING + cancellation       -> CANCELLED
RUNNING + timeout            -> TIMED_OUT
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

`workflow_executions` menyimpan `trigger_type`, `triggered_by`, dan `correlation_id` sesuai schema canonical. Jika runtime membutuhkan metadata trigger tambahan, metadata tersebut harus berada pada contract/event context yang sah dan tidak boleh diasumsikan sebagai kolom database baru tanpa perubahan resmi pada `DATABASE_DESIGN.md`.

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

Deterministic idempotency context dapat dibentuk dari execution/step/attempt context, tetapi **attempt counter dan idempotency key tidak dianggap persisted database columns** karena schema canonical saat ini belum mendefinisikannya.

Untuk side effect trading, Workflow Engine harus menyerahkan idempotency dan deduplication canonical kepada Trading Engine/Copy Trading Engine/domain owner yang bersangkutan.

Retry tidak boleh menghasilkan duplicate order, duplicate notification yang tidak diinginkan, duplicate copy execution, atau duplicate external command.

Workflow Engine tidak menggantikan idempotency mechanism milik Trading Engine.

---

# 15. Timeout

Setiap long-running atau external step harus memiliki timeout policy.

Timeout harus menghasilkan state yang eksplisit dan tidak boleh dianggap sebagai successful completion.

`workflow_executions.status` atau `workflow_execution_steps.status` digunakan sebagai canonical persisted state sesuai lifecycle yang relevan. Timeout policy/configuration berasal dari workflow version/step definition. Tidak diasumsikan adanya dedicated timeout column yang belum ditetapkan database blueprint.

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

Failure evidence yang membutuhkan audit ledger tetap menjadi tanggung jawab Security/Audit Manager sesuai Event System.

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

Concurrency mechanism tidak boleh diasumsikan sebagai schema column baru tanpa perubahan resmi pada database blueprint.

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

Mapping canonical:

| Workflow concern | Canonical persistence |
|---|---|
| workflow definition | `workflows` |
| immutable version | `workflow_versions` |
| step definition | `workflow_steps` |
| execution lifecycle | `workflow_executions.status` + timestamps |
| execution trigger | `workflow_executions.trigger_type` / `triggered_by` / `correlation_id` |
| step lifecycle | `workflow_execution_steps.status` + timestamps |
| step input/output | `workflow_execution_steps.input_payload` / `output_payload` |
| step failure evidence | `workflow_execution_steps.error_code` plus event/audit contract bila diperlukan |
| retry policy | workflow version / step configuration |
| timeout policy | workflow version / step configuration |
| idempotency handling | runtime/domain contract; tidak mengasumsikan kolom baru |

Module tidak otomatis berarti table.

Workflow Engine tidak boleh membuat duplicate entity untuk trading, risk, AI, market data, backtest, atau copy trading hanya karena workflow membutuhkan reference terhadap entity tersebut.

Jika implementation design membuktikan persistence requirement baru yang tidak dapat dipenuhi oleh schema canonical, perubahan harus diproses sebagai database change-control tersendiri dan tidak boleh disisipkan diam-diam ke implementation.

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

Event harus membawa correlation/causation context yang diperlukan untuk tracing. Event lifecycle mengikuti Event System:

```text
State Change
   ↓
Persist State
   ↓
Create Event
   ↓
Publish / Outbox
   ↓
Transport
   ↓
Consumer
   ↓
Ack / Retry / Dead Letter
```

Workflow event tidak menjadi source-of-record pengganti `workflow_executions` atau `workflow_execution_steps`.

Consumer workflow harus idempotent dan tidak boleh mengubah historical event.

---

# 21. Security and Authorization

Workflow execution harus mematuhi:

- tenant isolation;
- role/permission policy;
- resource ownership;
- authorization context;
- secret reference policy;
- audit requirements.

Workflow tidak boleh menyimpan plaintext credentials.

Workflow tidak boleh menaikkan privilege melalui step transition.

Human approval step hanya memberikan keputusan sesuai authorization scope; human approval juga tidak boleh bypass Risk Manager, Security, atau Trading Engine.

---

# 22. Observability and Audit

Minimal observability:

- execution identifier;
- workflow/version identifier;
- step identifier;
- state transition;
- correlation/causation context;
- timestamp;
- duration;
- error classification;
- terminal result.

Audit ledger tetap dimiliki Security/Audit Manager. Workflow hanya menghasilkan evidence/context yang diperlukan dan event yang sesuai.

---

# 23. Reconciliation

Untuk external side effect, terutama trading, Workflow tidak boleh menyimpulkan final external state hanya berdasarkan step completion.

```text
Workflow Step
     ↓
Domain Command
     ↓
External System
     ↓
Connector / Trading Engine
     ↓
Canonical Result / Reconciliation
     ↓
Workflow Continues
```

Timeout atau network failure tidak boleh dipetakan secara otomatis menjadi success/failure external tanpa reconciliation yang sesuai.

---

# 24. Change Control

Perubahan Workflow definition setelah published dilakukan melalui workflow version baru.

Perubahan terhadap ownership, persistence contract, trading boundary, risk boundary, event contract, atau security boundary wajib melalui review lintas blueprint terkait.

Workflow Engine tidak boleh mengubah `DATABASE_DESIGN.md`, `ERD.md`, `ARCHITECTURE.md`, atau `MODULE_SPECIFICATION.md` secara implisit.

---

# 25. Acceptance Criteria

Workflow Engine baseline dapat diajukan ke final review hanya jika:

- ownership workflow jelas;
- state machine eksplisit;
- transition rules terdokumentasi;
- trigger model terdokumentasi;
- retry/idempotency boundary jelas;
- timeout boundary jelas;
- failure/cancellation policy jelas;
- persistence mapping konsisten dengan database canonical;
- event integration konsisten dengan Event System;
- data flow tidak memiliki alternate execution path;
- trading action tetap melewati Risk Manager dan Trading Engine;
- AI tidak menjadi privileged execution path;
- Backtest tetap terisolasi;
- Copy Trading tetap melalui canonical pipeline;
- tenant/security boundary jelas;
- audit ownership tidak tumpang tindih;
- external side effect mempunyai reconciliation contract;
- tidak ada duplicate canonical entity ownership;
- implementation requirement baru tidak diasumsikan sebagai schema tanpa change-control.

---

# 26. Related Blueprints

- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `ERD.md`
- `EVENT_SYSTEM.md`
- `DATA_FLOW.md`
- `MESSAGE_QUEUE.md`
- `ERROR_HANDLING.md`
- `SECURITY.md`
- `AUDIT_LOG.md` bila tersedia sebagai blueprint terpisah

# END OF WORKFLOW_ENGINE.md
