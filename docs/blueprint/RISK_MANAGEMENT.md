# OHTATS Risk Management

> Dokumen ini mendefinisikan canonical risk-control contract OHTATS yang wajib dilalui setiap executable trading action sebelum mencapai connector/platform.
>
> `TRADING_ENGINE.md` adalah sumber lifecycle execution. `DATABASE_DESIGN.md` dan `ERD.md` adalah sumber canonical persistent entities. Risk Management memiliki authority atas risk policy, risk evaluation, risk decision, risk events, limits, and trading halt policy; Risk Management tidak mengambil alih order/execution/position lifecycle.

---

# Status

**RISK MANAGEMENT BLUEPRINT — BASELINE**

**Version:** 1.0.0

**Authority:** Risk-control domain reference

---

# 1. Tujuan

Risk Management melindungi account, user, tenant, strategy, portfolio, dan platform dari executable trading actions yang melampaui policy atau kondisi risiko yang diizinkan.

Risk control bersifat **mandatory gate**. Tidak ada modul, AI provider, strategy, workflow, copy-trading engine, API client, atau connector yang boleh melewati gate ini untuk menghasilkan executable order.

---

# 2. Canonical Risk Flow

```text
Trading Request
      |
      v
Risk Context Resolution
      |
      v
Policy / Limit Resolution
      |
      v
Risk Evaluation
      |
      +---- DENY / HALT ----> Risk Event + Audit
      |
      v
ALLOW / CONDITIONAL ALLOW
      |
      v
Trading Engine
      |
      v
Connector
```

Risk decision harus tersedia sebagai durable, auditable decision context sebelum executable action diteruskan.

---

# 3. Ownership

| Capability | Owner |
|---|---|
| Risk policy | Risk Manager |
| Risk rules | Risk Manager |
| Risk limits | Risk Manager |
| Risk evaluation | Risk Manager |
| Risk decision | Risk Manager |
| Risk events | Risk Manager |
| Trading halt policy | Risk Manager / authorized operational control |
| Order lifecycle | Trading Engine |
| Execution / deal lifecycle | Trading Engine |
| Position lifecycle | Trading Engine |
| Strategy identity/version | Strategy Manager |
| Connector/vendor translation | Connector Manager / Connector |
| Audit persistence | Security & Audit Manager / audit contract |

Trading Engine consumes the risk decision. It must not silently override, reinterpret, or downgrade a deny decision.

---

# 4. Risk Context

Risk evaluation must resolve the context required by the applicable policy, including when relevant:

- tenant;
- user/actor;
- trading account;
- broker/platform connection;
- instrument;
- canonical and broker-specific symbol mapping;
- strategy and immutable strategy version;
- order action and side;
- quantity and requested price;
- order type;
- current balance/equity/margin information;
- open positions and exposure;
- portfolio exposure;
- existing pending orders;
- leverage and broker/platform restrictions;
- market/session state when available;
- daily loss and drawdown state;
- configured account/strategy/user limits;
- emergency halt/circuit-breaker state;
- entitlement/licensing constraints where applicable.

A risk decision must not be based on stale or incomplete context when the applicable policy requires current information.

---

# 5. Risk Decision Contract

The canonical decision is explicit and auditable.

```text
Risk Decision
 ├── decision: ALLOW | DENY | HALT | CONDITIONAL
 ├── policy_reference
 ├── policy_version
 ├── evaluated_at
 ├── expires_at (when applicable)
 ├── correlation_id
 ├── request_id
 ├── account_id
 ├── strategy_version_id (when applicable)
 ├── reason_codes
 └── evaluation_context_reference
```

`DENY` means the requested executable action cannot proceed.

`HALT` means the applicable scope is prohibited from creating new executable actions until the halt condition is cleared according to policy.

`CONDITIONAL` may only be used when the required conditions are deterministic, explicit, and revalidated before execution.

---

# 6. Mandatory Pre-Trade Controls

At minimum, applicable policies must be able to evaluate:

- account active/suspended state;
- authorization and entitlement;
- maximum order quantity/notional;
- maximum position size;
- symbol exposure;
- portfolio exposure;
- leverage/margin constraints;
- daily loss limit;
- drawdown limit;
- strategy-specific limits;
- user/account risk limits;
- broker/platform constraints;
- trading session restrictions;
- instrument restrictions;
- emergency halt/circuit breaker;
- duplicate/idempotent request conditions;
- stale market or account state where relevant.

A rule may be disabled only through an authorized policy change with an auditable version transition.

---

# 7. Exposure Model

Risk must distinguish at least:

```text
Account Exposure
      |
      +-- Instrument Exposure
      |
      +-- Strategy Exposure
      |
      +-- Portfolio Exposure
      |
      +-- Pending Order Exposure
      |
      +-- Realized / Unrealized Loss
      |
      +-- Margin / Leverage Exposure
```

Exposure calculations must use canonical instrument/account identities and documented quantity, price, currency, and conversion semantics.

---

# 8. Loss, Drawdown, and Circuit Breakers

The risk system must support configurable controls for:

- per-order loss/exposure;
- per-symbol loss/exposure;
- strategy loss;
- account daily loss;
- account drawdown;
- portfolio drawdown;
- consecutive-loss conditions where configured;
- abnormal execution conditions;
- connector/platform incidents;
- operational emergency halt.

A triggered circuit breaker creates an auditable risk event and applies the configured scope. It must not silently alter historical trading records.

---

# 9. Position and Order Interaction

Risk evaluation must consider both existing positions and pending orders.

```text
Current Position
       +
Pending Exposure
       +
Requested Exposure
       ↓
Projected Exposure
       ↓
Risk Policy Evaluation
```

The system must avoid approving an order merely because current exposure is within limits when the resulting projected exposure would exceed those limits.

---

# 10. Risk Gate and Trading Engine

The mandatory relationship is:

```text
Trading Request
      |
      v
Validation / Idempotency
      |
      v
Risk Manager
      |
   +--+--+
   |     |
 ALLOW  DENY/HALT
   |     |
   v     +--> Risk Event / Audit
Trading Engine
   |
   v
Connector
```

Risk approval is not a broker submission acknowledgement. The Trading Engine remains responsible for execution lifecycle after the risk gate.

---

# 11. Revalidation

Risk approval must be revalidated when material conditions change before execution, including when:

- approval expires;
- account state changes;
- exposure changes materially;
- requested quantity/price changes;
- strategy version changes;
- risk policy version changes;
- emergency halt is activated;
- connector/platform capability changes;
- required market/account context becomes stale.

A stale approval must not be treated as permanent authorization.

---

# 12. AI and Strategy Boundary

AI and strategy modules may propose trading intent or decision context.

They do not own risk authority.

```text
AI / Strategy
      |
      v
Trading Request
      |
      v
Risk Manager
      |
      v
Trading Engine
```

An AI recommendation cannot override a risk deny, limit, halt, or authorization rule.

---

# 13. Workflow and Copy Trading Boundary

Workflow-triggered and copied trades enter the same risk pipeline as ordinary trades.

```text
Workflow / Copy Trading
          |
          v
Follower / Target Trading Request
          |
          v
Normal Risk Evaluation
          |
          v
Trading Engine
```

Copy-trading master approval does not imply follower-account risk approval.

---

# 14. Backtest Boundary

Backtest risk evaluation must be isolated from live risk state and live connectors.

```text
LIVE
Risk Manager -> Trading Engine -> Live Connector

BACKTEST
Backtest Risk Model -> Simulation Adapter
```

Backtest results must identify the risk-policy/version assumptions used for reproducibility. Backtest execution must never mutate live risk state.

---

# 15. Multi-Platform Risk

Risk policy is canonical at OHTATS level while platform-specific capability and constraint data are supplied by connectors/platform adapters.

Examples include:

- netting vs hedging;
- minimum/maximum volume;
- volume step;
- price precision;
- stop-distance rules;
- margin requirements;
- market/session restrictions;
- supported order types.

The connector may reject an unsupported representation, but it must not bypass the OHTATS risk gate.

---

# 16. Fail-Closed Rules

Risk control must fail closed for security-critical and financially material unknown conditions unless an explicitly documented policy says otherwise.

Examples:

- unavailable mandatory risk context;
- unknown account state;
- invalid policy version;
- expired risk decision;
- unresolved emergency halt;
- ambiguous authorization;
- corrupted or inconsistent risk state.

A system must never convert an unknown risk condition into an implicit ALLOW.

---

# 17. Risk Events and Audit

Minimum event families include:

- `risk.evaluation_started`
- `risk.allowed`
- `risk.denied`
- `risk.conditional`
- `risk.halted`
- `risk.limit_breached`
- `risk.circuit_breaker_triggered`
- `risk.revalidation_required`
- `risk.context_unavailable`
- `risk.policy_changed`

Critical risk decisions must be auditable with correlation/request identifiers, account, strategy/version where applicable, policy/version, decision, reason codes, evaluation timestamp, and relevant context reference.

Risk events are historical records and must not be silently rewritten.

---

# 18. Persistence Contract

Risk Management must use the canonical entities defined by `DATABASE_DESIGN.md` and `ERD.md` where applicable, including risk policies, risk rules, and risk events.

Risk Management must not create duplicate canonical trading tables for orders, executions, deals, or positions.

Runtime caches and transient evaluation state do not automatically become persistent tables.

---

# 19. Concurrency and Race Conditions

Risk evaluation must account for concurrent executable requests against the same account/portfolio.

The design must prevent a race where two individually valid requests together exceed a shared limit.

Controls may include durable reservation/state, serialized decision scope, optimistic concurrency with deterministic retry/revalidation, or equivalent mechanisms documented by implementation design.

The chosen mechanism must preserve auditability and deterministic risk semantics.

---

# 20. Emergency Halt

Emergency halt is a first-class control.

```text
NORMAL
  |
  v
HALT TRIGGER
  |
  v
HALTED SCOPE
  |
  +--> reject new executable requests
  +--> preserve existing state
  +--> emit audit/risk events
  +--> allow only explicitly permitted recovery actions
```

The policy must explicitly define whether cancellation, position close, reconciliation, or protective actions remain permitted during a halt.

---

# 21. Observability

Risk telemetry should measure:

- evaluation latency;
- context retrieval latency;
- allow/deny/halt rates;
- rule breach frequency;
- circuit breaker activations;
- stale-context frequency;
- revalidation frequency;
- concurrent conflict frequency;
- risk-service availability;
- risk decision failures.

Logs are operational evidence; canonical risk events/audit records remain the authoritative historical record.

---

# 22. Security

Risk controls must enforce tenant/user/account isolation, authorization, policy version integrity, secure handling of sensitive context, secret isolation, and protection against unauthorized policy modification.

No API key, broker credential, password, or secret is stored as ordinary risk policy data.

---

# 23. Policy Versioning

Executable risk policies and rules must be versioned.

A risk decision must identify the policy/rule version used for evaluation. Changes must be auditable and must not silently rewrite historical decisions.

Strategy versioning and risk policy versioning are independent but may both be required to reconstruct an executable decision.

---

# 24. Acceptance Criteria

Risk Management is ready for approval only when:

- risk is a mandatory trading gate;
- ownership is separated from Trading Engine;
- risk context is defined;
- policy/rule versioning is explicit;
- ALLOW/DENY/HALT semantics are deterministic;
- projected exposure is considered;
- concurrent requests cannot silently bypass shared limits;
- stale approvals require revalidation;
- unknown mandatory risk conditions fail closed;
- AI, strategy, workflow, and copy trading cannot bypass risk;
- backtest risk is isolated from live risk;
- platform-specific constraints are represented without moving risk authority into connectors;
- risk decisions and critical events are auditable;
- emergency halt behavior is defined;
- canonical database entities are respected;
- no duplicate trading lifecycle tables are introduced.

---

# 25. Final Boundary

```text
Risk Manager
    |
    | risk decision
    v
Trading Engine
    |
    | canonical executable command
    v
Connector
    |
    v
Broker / Platform
```

Risk Management owns the decision **whether a trading action is permitted**. Trading Engine owns **how an approved action moves through the canonical trading lifecycle**. Connector owns **how the canonical action is represented and transported to an external platform**.

No layer may silently assume another layer's authority.
