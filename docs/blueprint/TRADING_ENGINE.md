# OHTATS Trading Engine

> Dokumen ini mendefinisikan canonical trading lifecycle OHTATS, ownership, command/event contracts, state transitions, risk gate, connector boundary, idempotency, reconciliation, auditability, dan failure handling.
>
> `SYSTEM_DESIGN.md` adalah sumber fungsi tingkat sistem. `ARCHITECTURE.md` adalah sumber boundary teknis. `MODULE_SPECIFICATION.md` adalah sumber ownership modul. `DATABASE_DESIGN.md` dan `ERD.md` adalah sumber canonical persistent trading entities.

---

# Status

**Status:** REVIEW

**TRADING ENGINE BLUEPRINT — BASELINE**

**Version:** 1.0.0

**Authority:** Trading domain reference

---

# 1. Tujuan

Trading Engine adalah canonical owner untuk executable trading lifecycle OHTATS.

Engine harus menyediakan lifecycle yang konsisten untuk MT4, MT5, TradingView integration, broker REST/API, FIX/API, exchange/platform tambahan melalui connector, live trading, strategy-driven execution, AI-assisted execution, workflow-triggered execution, dan copy-trading execution.

Perbedaan vendor tidak boleh mengubah canonical OHTATS trading semantics.

---

# 2. Canonical Lifecycle

```text
Trading Request
      |
      v
Authentication / Authorization
      |
      v
Request Validation
      |
      v
Idempotency Check
      |
      v
Strategy / Context Resolution
      |
      v
Risk Evaluation
      |
      +---- DENY / HALT ----> Risk Event / Audit
      |
      v
Order Creation
      |
      v
Connector Routing
      |
      v
Broker / Platform
      |
      v
Execution / Deal
      |
      v
Position Update
      |
      v
Trading Events / Audit
      |
      v
Reconciliation
```

Risk approval is mandatory before an executable trading action reaches a connector.

---

# 3. Ownership

| Capability | Owner |
|---|---|
| Trading request | Trading Engine |
| Order lifecycle | Trading Engine |
| Order events | Trading Engine |
| Execution / deal lifecycle | Trading Engine |
| Position lifecycle | Trading Engine |
| Connector routing | Connector Manager |
| Vendor translation | Trading Platform Connector |
| Risk decision | Risk Manager |
| Strategy identity/version | Strategy Manager |
| Market instrument identity | Market Data Manager |
| AI analysis/decision | AI Manager |
| Workflow execution | Workflow Engine |
| Copy rules | Copy Trading Engine |
| Historical persistence | Data / Persistence Service |
| Audit record | Security & Audit Manager / audit contract |

Trading Engine owns trading state and lifecycle. It does not own risk policy, strategy master data, broker credentials, or vendor-specific implementation.

---

# 4. Canonical Entities

The Trading Engine uses the entities defined by `DATABASE_DESIGN.md`:

- `trading_accounts`
- `account_balance_snapshots`
- `trading_requests`
- `orders`
- `order_events`
- `order_executions`
- `deals`
- `positions`
- `position_events`
- `trading_journals`

Supporting entities include users, connections, broker/platform mappings, instruments, symbol mappings, strategies, strategy versions/deployments, risk policies/rules/events.

The engine must not introduce duplicate canonical tables for these concepts.

---

# 5. Trading Request

A Trading Request is an application/domain command asking OHTATS to evaluate and, if approved, execute a trading action.

A request may originate from a user/API, strategy execution, AI decision, workflow, copy trading, scheduled operation, or approved internal automation.

A request is not an order.

```text
Trading Request = intent to perform trading action
Order            = executable order state
Execution/Deal   = broker/platform execution result
Position         = resulting canonical exposure state
```

This separation is mandatory.

---

# 6. Request Validation

Before risk evaluation, validate authenticated actor/context, authorization, account availability, connection availability, instrument identity, broker-symbol mapping, requested side/action, quantity and price constraints, order-type requirements, strategy/version context when required, request expiry/time validity, idempotency key, platform capability, market/session availability when known, and required correlation identifiers.

Invalid requests must not create an executable order.

---

# 7. Idempotency

Trading commands are financially sensitive and must be idempotent.

Every externally initiated executable request must carry an idempotency key or equivalent unique request identity.

Rules:

- the same request must not create duplicate executable orders;
- retries after timeout reuse the original request identity;
- an unknown connector response triggers reconciliation before another order is created;
- idempotency state survives process restart according to persistence requirements;
- idempotency conflicts are auditable.

Never solve a timeout by blindly submitting a second order.

---

# 8. Risk Gate

No executable order may bypass the Risk Manager.

```text
Trading Request
      |
      v
Risk Manager
      |
  +---+---+
  |       |
ALLOW    DENY
  |       |
  v       v
Order   Risk Event
```

Risk evaluation may include account status, balance/equity, available margin, position/symbol/portfolio exposure, leverage and order-size limits, daily loss, drawdown, strategy/user risk policy, broker/platform restrictions, market/session restrictions, and emergency halt state.

Trading Engine consumes the risk decision; it does not silently override it.

---

# 9. Order Lifecycle

Canonical order states are domain states, not vendor-specific statuses.

Minimum lifecycle:

```text
CREATED -> VALIDATED -> RISK_APPROVED -> SUBMITTING -> SUBMITTED
                                                    |
                           +------------------------+----------------+
                           |                        |                |
                      REJECTED             PARTIALLY_FILLED       EXPIRED
                                                    |
                                                  FILLED
```

Cancellation is represented as a controlled transition from an eligible non-terminal state through `CANCEL_REQUESTED` to `CANCELLED` when confirmed.

Additional terminal/error states may be defined when required, but semantics must remain documented and deterministic.

Vendor status must be mapped into canonical OHTATS state before exposure to other modules.

---

# 10. Partial Fills

The engine must support one order producing zero, one, or multiple executions/deals.

```text
Order
 ├── Execution 1
 ├── Execution 2
 └── Execution N
```

Therefore one order is not assumed to equal one deal or one position. Average execution price, fees, commission, swap, and equivalent costs remain attributable to the appropriate execution/deal records. Position updates consume execution events rather than vendor assumptions.

---

# 11. Deal / Execution

A deal represents an execution result received from an external trading venue/platform. Live Trading Engine distinguishes submission acknowledgement, execution acknowledgement, execution fill, rejection, cancellation, and correction/reconciliation information.

Connector-specific identifiers are preserved as external identifiers while OHTATS retains canonical identifiers.

---

# 12. Position Lifecycle

A position is canonical exposure state derived from executions/deals and applicable position rules.

The engine supports opening, increasing, reducing, closing, reversal where supported, partial close, multiple executions affecting one position, and platform-specific netting/hedging semantics.

The engine must not assume every platform has identical position semantics. Platform differences belong at the connector/adapter boundary and must be normalized into documented canonical behavior.

---

# 13. Netting and Hedging

The connector capability contract must expose whether the target account supports netting, hedging/multiple positions, partial close, position modification, order modification, pending orders, stop/limit protection, and required execution reporting capabilities.

Trading Engine must reject or transform an operation when the target platform cannot safely represent the requested canonical action.

No silent semantic loss is permitted.

---

# 14. Connector Boundary

```text
Trading Engine
      |
      | Canonical Command
      v
Connector Manager
      |
      +--> MT4 Connector
      +--> MT5 Connector
      +--> TradingView Connector
      +--> Broker API Connector
      +--> FIX Connector
      +--> Exchange Connector
```

Connectors are responsible for vendor authentication through secure secret references, request/response translation, capability discovery, external identifier handling, transport/retry behavior, and vendor error mapping.

Connectors must not implement OHTATS business risk policy.

---

# 15. Timeouts and Unknown Outcomes

A network timeout does not mean an order failed.

```text
SUBMITTING -> TIMEOUT / UNKNOWN -> RECONCILIATION
                                      |
                                  +---+---+
                                  |       |
                                FOUND  NOT FOUND
                                  |       |
                                  v       v
                                UPDATE  controlled retry
```

A retry is permitted only after idempotency/reconciliation rules establish that duplicate execution will not occur.

---

# 16. Reconciliation

Reconciliation compares OHTATS state with external platform state and detects missing/unexpected orders, missing/duplicate executions, position mismatch, quantity mismatch, average-price mismatch, balance mismatch, status mismatch, and stale connection state.

Reconciliation produces auditable discrepancy records/events.

Automatic correction is policy-controlled and must not silently overwrite authoritative history.

---

# 17. Events

Minimum trading event families:

- `trading_request.created`
- `trading_request.rejected`
- `trading_request.approved`
- `order.created`
- `order.submitted`
- `order.accepted`
- `order.rejected`
- `order.partially_filled`
- `order.filled`
- `order.cancel_requested`
- `order.cancelled`
- `execution.received`
- `deal.created`
- `position.opened`
- `position.updated`
- `position.closed`
- `trading.reconciliation_required`
- `trading.reconciliation_completed`
- `trading.halted`

Events must include correlation identifiers sufficient to reconstruct the lifecycle.

---

# 18. Auditability

Critical trading actions must be auditable. Audit context should identify, when available, actor/user, session/request, strategy/version, AI decision reference, workflow execution reference, copy-trading reference, account, instrument, canonical request/order/deal/position identifiers, connector/platform, risk decision, result, timestamps, and external identifiers.

Audit history is append-only and is not a mutable trading state store.

---

# 19. Strategy and AI Integration

AI and strategy modules may produce intent or decision context. They do not submit broker commands directly.

```text
AI / Strategy -> Trading Request -> Trading Engine -> Risk Manager -> Connector
```

An AI response such as `BUY EURUSD` is not an executable broker command until it passes authorization, validation, risk, and execution controls.

Every executable strategy must reference an immutable strategy version.

---

# 20. Workflow Integration

Workflow Engine may trigger a trading request but must not bypass authorization, validation, risk, idempotency, audit, or reconciliation.

Workflow execution identity is carried as correlation context where applicable.

---

# 21. Copy Trading Integration

```text
Master Event -> Copy Rule / Mapping -> Follower Trading Request -> Normal Risk + Trading Pipeline
```

Copy Trading Engine must never submit directly to a connector. Follower-specific risk policy remains authoritative for the follower account.

---

# 22. Backtest Separation

Backtest Engine uses canonical trading concepts where practical but is isolated from live connector execution.

```text
Live:     Trading Engine -> Connector -> Broker/Platform
Backtest: Backtest Engine -> Simulation Adapter -> Simulated Execution
```

Backtest must never accidentally call live connectors and must reference immutable strategy and dataset versions for reproducibility.

---

# 23. Failure Handling

Failure categories include validation failure, authorization failure, risk denial, connector unavailable, authentication failure, vendor rejection, timeout/unknown outcome, reconciliation discrepancy, persistence failure, internal processing failure, and emergency trading halt.

Retry behavior is category-specific. Financially executable commands are never blindly retried.

---

# 24. Emergency Halt

The platform must support a controlled trading halt originating from administrator control, risk policy, account policy, connector/platform emergency condition, operational incident, or configured circuit breaker.

A halt prevents new executable actions according to scope while preserving existing state and audit history. The policy must explicitly state whether cancellation, close, and reconciliation actions remain permitted.

---

# 25. Observability

Every trading lifecycle carries a correlation identifier. Operational telemetry should distinguish request latency, risk latency, connector latency, submission latency, execution latency, reconciliation latency, rejection/timeout rates, idempotency conflicts, connector availability, and position discrepancies.

Logging is not a replacement for audit records.

---

# 26. Security Rules

Trading Engine must enforce authorization, use secure secret references, avoid logging secrets/tokens, protect sensitive trading identifiers, preserve tenant/user/account isolation, record critical actions, reject malformed or unauthorized commands, and respect licensing/entitlement policy where applicable.

Connector credentials remain outside canonical trading domain state.

---

# 27. Transaction Boundaries

A database transaction does not atomically include an external broker operation.

```text
Persist intent/state -> External command -> External result/event -> Persist canonical result -> Reconcile when necessary
```

Distributed failure is handled through idempotency, events, durable state, retry policy, and reconciliation.

---

# 28. Acceptance Criteria

Trading Engine is ready for approval only when:

- canonical lifecycle is documented;
- trading request and order are distinct;
- order/execution/deal/position ownership is explicit;
- risk is a mandatory gate;
- connector boundary is explicit;
- MT4/MT5/TradingView differences are represented as capabilities/adapters;
- partial fills are supported;
- netting/hedging semantics are addressed;
- idempotency is defined;
- timeout/unknown outcome behavior is defined;
- reconciliation is defined;
- auditability is defined;
- AI/strategy/workflow/copy-trading cannot bypass controls;
- backtest is isolated from live execution;
- emergency halt is defined;
- observability and security requirements are defined;
- persistent entities remain consistent with `DATABASE_DESIGN.md` and `ERD.md`;
- module ownership remains consistent with `MODULE_SPECIFICATION.md`.

---

# 29. Related Blueprints

- `01_VISION.md`
- `PROJECT_CONSTITUTION.md`
- `SYSTEM_DESIGN.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `DATABASE_DESIGN.md`
- `DATABASE_REVIEW.md`
- `ERD.md`
- `DATA_FLOW.md`
- `API_DESIGN.md`
- `EVENT_SYSTEM.md`
- `MESSAGE_QUEUE.md`
- `ERROR_HANDLING.md`
- `INTEGRATION.md`
- `RISK_MANAGEMENT.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`
- `WORKFLOW_ENGINE.md`

---

# END OF TRADING_ENGINE.md
