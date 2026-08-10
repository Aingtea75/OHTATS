# OHTATS Copy Trading

> Canonical blueprint for master/follower trading replication. Copy Trading creates follower trading requests; it does not own trading, risk, order, execution, deal, or position lifecycle.

**Status:** REVIEW

**COPY TRADING BLUEPRINT — BASELINE**

**Version:** 1.0.0

**Authority:** Copy-trading domain reference

---

# 1. Purpose

Copy Trading allows an authorized follower account to replicate eligible trading intent from a master account or strategy while preserving each follower's own identity, risk policy, broker/platform constraints, entitlement, and execution lifecycle.

Copy trading is a request-generation capability, not a bypass around OHTATS controls.

---

# 2. Non-Negotiable Boundary

```text
MASTER EVENT / MASTER TRADE
          |
          v
Copy Policy Resolution
          |
          v
Follower Eligibility
          |
          v
Symbol / Instrument Mapping
          |
          v
Follower Copy Request
          |
          v
NORMAL RISK GATE
          |
      +---+---+
      |       |
    DENY     ALLOW
      |       |
      v       v
   Audit   Trading Engine
              |
              v
          Connector
```

A master trade being approved does **not** authorize the same action for a follower.

---

# 3. Ownership

| Capability | Owner |
|---|---|
| Master/follower relationship | Copy Trading Engine |
| Copy policy/rules | Copy Trading Engine |
| Master event selection | Copy Trading Engine |
| Follower eligibility | Copy Trading Engine + entitlement/authorization controls |
| Instrument/symbol mapping | Copy Trading Engine using canonical mapping services |
| Follower sizing calculation | Copy Trading Engine within configured copy rules |
| Follower risk authority | Risk Manager |
| Follower order lifecycle | Trading Engine |
| Execution/deal lifecycle | Trading Engine |
| Position lifecycle | Trading Engine |
| External platform translation | Connector layer |
| Historical audit | Canonical audit/event services |

Copy Trading must not create duplicate order, deal, execution, or position masters.

---

# 4. Master and Follower Model

A copy relationship must identify, as applicable:

- master account or master strategy;
- follower account;
- relationship status;
- effective start/end time;
- copy policy/version;
- follower risk policy reference;
- symbol mapping policy;
- sizing policy;
- allowed instruments/platforms;
- maximum copied exposure;
- emergency stop state;
- entitlement/license state;
- audit metadata.

The relationship itself is versioned/configurable; historical executed trades remain owned by the canonical trading lifecycle.

---

# 5. Copy Policy

A copy policy must explicitly define:

- which master events are eligible;
- entry/exit/cancel actions included;
- instrument mapping behavior;
- sizing method;
- minimum/maximum copied quantity;
- rounding/volume-step handling;
- maximum follower exposure;
- maximum number of simultaneous copied positions/orders;
- latency tolerance;
- handling of unavailable symbols;
- handling of unsupported order types;
- handling of master partial fills;
- handling of master cancellation/reversal;
- follower account restrictions;
- emergency stop behavior.

Policy changes must be versioned and auditable.

---

# 6. Follower Eligibility

Before producing a follower executable request, the system must verify applicable conditions including:

- relationship active;
- follower authorized;
- entitlement/license active where required;
- follower trading account active;
- connector/platform available;
- instrument mapping resolved;
- copy policy valid;
- required follower configuration present;
- emergency copy halt not active.

Eligibility is not equivalent to risk approval.

---

# 7. Sizing

Supported sizing models may include:

- fixed quantity;
- fixed notional;
- proportional to master quantity;
- equity-ratio scaling;
- balance-ratio scaling;
- risk-based scaling;
- policy-defined capped scaling.

Every generated quantity must be normalized against the follower platform's minimum, maximum, and volume-step constraints before submission to Risk Management.

If sizing cannot be calculated deterministically, the copy request must not silently become executable.

---

# 8. Instrument and Symbol Mapping

Master and follower platforms may use different symbol identifiers.

```text
Master Canonical Instrument
          |
          v
Canonical Mapping Service
          |
          v
Follower Platform Symbol
```

Mapping must preserve the canonical instrument identity and record the mapping used for the copied request.

Unresolved or ambiguous mappings must be rejected unless an explicit policy permits a safe deterministic alternative.

---

# 9. Normal Risk Pipeline

Every follower trading action enters the same risk controls as any other executable action:

```text
Copy Request
     |
     v
Validation / Idempotency
     |
     v
Follower Risk Context
     |
     v
Risk Manager
     |
 +---+---+
 |       |
DENY    ALLOW
 |       |
 v       v
Audit  Trading Engine
```

The Copy Trading Engine cannot downgrade, bypass, or reinterpret a follower risk denial.

---

# 10. Follower-Specific Risk

Risk must be evaluated using follower state, not master state alone.

The evaluation may include:

- follower balance/equity;
- current exposure;
- pending exposure;
- existing positions;
- leverage/margin;
- daily loss/drawdown;
- follower-specific limits;
- instrument restrictions;
- broker/platform constraints;
- emergency halt;
- concurrent requests.

A copied trade can therefore be approved for the master and denied for one or more followers.

---

# 11. Event-to-Request Semantics

Master events should be processed idempotently.

Each generated follower request must retain traceability to:

- master event identifier;
- master order/trade identity where applicable;
- copy relationship/version;
- follower account;
- mapping/version;
- sizing policy/version;
- generated request identifier;
- risk decision identifier;
- resulting canonical order identity when accepted.

This allows a copied action to be reconstructed without making the master trade the follower's order master.

---

# 12. Idempotency and Duplicate Prevention

The same master event must not create duplicate follower executable actions when the same relationship/version and follower target have already been processed.

Idempotency keys must be deterministic from the relevant master event, copy relationship/version, follower account, and action semantics.

Retries must reuse the same logical request identity where appropriate.

---

# 13. Partial Fills and Lifecycle Events

Master execution events may be:

- submitted;
- accepted;
- partially filled;
- fully filled;
- cancelled;
- rejected;
- reversed/closed.

Copy policy must explicitly define which event types are replicated and how follower state is reconciled.

Follower execution remains independent: a follower may fill, reject, or partially fill differently from the master.

---

# 14. Timing and Ordering

Copy processing must preserve required causal ordering.

For related master events:

```text
Master Event A
      ↓
Copy Request A
      ↓
Follower Processing
      ↓
Master Event B
```

The system must define behavior when events arrive late, out of order, or after a relationship has been disabled.

Time-sensitive copy actions must not assume instantaneous follower execution.

---

# 15. Failure Handling

Copy processing must distinguish at least:

- invalid relationship;
- unauthorized follower;
- inactive entitlement;
- unresolved mapping;
- unsupported order type;
- sizing failure;
- risk denial;
- connector unavailable;
- follower order rejection;
- timeout;
- duplicate/idempotent replay;
- reconciliation mismatch.

A failed follower copy must not be represented as successfully executed merely because the master succeeded.

---

# 16. Reconciliation

The system must support reconciliation between expected follower copy state and canonical follower trading state.

```text
Master Event
   |
Expected Copy State
   |
Follower Trading State
   |
Reconciliation
   |
Mismatch -> Event / Alert / Recovery Policy
```

Recovery actions must pass through normal authorization, risk, and trading controls.

---

# 17. Emergency Halt

Copy Trading must support independent emergency controls at relationship, follower, strategy, account, and platform scopes where required.

A copy halt prevents new copied executable requests according to scope but must not silently rewrite historical trades.

Permitted recovery/cancellation/close actions must be explicitly defined by policy and remain subject to applicable risk and trading controls.

---

# 18. Multi-Platform Support

Copy relationships may connect different platform types, including MT4, MT5, TradingView integrations, broker APIs, and other supported connectors.

Canonical instrument and trading semantics remain OHTATS-level concepts. Platform-specific mapping and execution constraints remain connector responsibilities.

A cross-platform copy is not a guarantee of identical execution price, fill timing, spread, or outcome.

---

# 19. AI and Workflow Boundary

AI may analyze or recommend copy policies, but AI does not own follower risk authority.

Workflow may trigger copy operations, but workflow cannot bypass the copy policy, follower eligibility, risk gate, or trading lifecycle.

```text
AI / Workflow
      |
      v
Copy Trading Engine
      |
      v
Follower Risk Gate
      |
      v
Trading Engine
```

---

# 20. Backtest Boundary

Copy Trading simulation in backtests must use the Backtest Engine's isolated simulation environment.

It must not create live follower orders or mutate live copy relationships.

Master/follower assumptions used in simulation must be versioned as part of the backtest experiment.

---

# 21. Persistence Contract

Copy Trading uses canonical persistence entities defined by `DATABASE_DESIGN.md` and `ERD.md` where applicable.

It may persist relationship/configuration, copy policy/version, mapping references, processing state, and copy-specific audit/event metadata as defined by the canonical schema.

It must not create duplicate canonical tables for orders, deals, executions, positions, accounts, instruments, or risk decisions.

---

# 22. Security and Tenant Isolation

Master and follower relationships must respect tenant boundaries and authorization.

A follower must not gain access to another tenant's master data merely through a copy relationship.

Secrets and broker credentials remain under the platform's credential/security boundary and are not stored in copy policy records.

---

# 23. Observability

Operational telemetry should measure:

- copy events received;
- copy requests generated;
- risk approvals/denials;
- mapping failures;
- sizing failures;
- follower execution latency;
- rejection/timeout rates;
- duplicate/replay rates;
- reconciliation mismatches;
- emergency halts;
- per-relationship health.

Canonical historical events remain authoritative over operational metrics.

---

# 24. Acceptance Criteria

Copy Trading is ready for approval only when:

- master/follower relationships are explicit and versioned;
- follower eligibility is distinct from risk approval;
- every follower executable action enters the normal risk pipeline;
- master approval never implies follower approval;
- sizing is deterministic and platform constraints are respected;
- instrument mapping is canonical and auditable;
- idempotency prevents duplicate follower actions;
- partial fills and lifecycle differences are explicitly handled;
- out-of-order/late events have defined behavior;
- failed copies are not reported as successful executions;
- reconciliation exists for expected vs actual follower state;
- emergency halt behavior is defined;
- AI/workflow cannot bypass controls;
- backtest copy simulation is isolated from live state;
- persistence follows canonical database ownership;
- tenant/security boundaries are enforced.

---

# 25. Final Boundary

```text
                 MASTER
                   |
              Master Event
                   |
                   v
            COPY TRADING ENGINE
                   |
          +--------+--------+
          |                 |
    Policy/Mapping       Follower
      /Sizing           Eligibility
          |                 |
          +--------+--------+
                   |
                   v
             RISK MANAGER
                   |
              +----+----+
              |         |
            DENY      ALLOW
              |         |
              v         v
            Audit   TRADING ENGINE
                        |
                        v
                    CONNECTOR
                        |
                        v
                FOLLOWER PLATFORM
```

Copy Trading owns **which master actions become follower requests and how they are transformed**. Risk Management owns **whether the follower request is permitted**. Trading Engine owns **the follower's canonical execution lifecycle**. Connector owns **external platform translation and transport**.

No master trade is a shortcut around the follower's own controls.