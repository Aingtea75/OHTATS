# OHTATS Adaptive Runtime Architecture

> Defines the R3.16 adaptive-runtime architecture before implementation. It establishes contracts for risk envelopes, market quality, event risk, strategy eligibility, adaptive strategy/execution/risk, and hysteresis/cooldown. It does not implement runtime behavior.

---

# Status

**ADAPTIVE RUNTIME ARCHITECTURE — REVIEW**

**Version:** 1.0.1

**Authority:** Cross-domain architecture reference; canonical risk decisions remain with Risk Management.

---

# 1. Purpose

Adaptive runtime allows OHTATS to adjust strategy eligibility, execution behavior, and risk constraints using current market context while preserving deterministic governance boundaries.

Adaptation is constrained by policy. It is not permission to bypass risk, authorization, validation, or audit controls.

# 2. Canonical Ownership

| Capability | Canonical Owner |
|---|---|
| Risk envelope | Risk Management |
| Adaptive risk constraints | Risk Management |
| Event risk | Risk Management |
| Market quality inputs | Market Data / Trading Runtime |
| Strategy eligibility | Strategy Runtime |
| Adaptive strategy | Strategy Runtime |
| Adaptive execution | Trading Engine |
| Regime state | Market / Strategy Runtime |
| Hysteresis / cooldown | Regime / Adaptive Runtime |

No adaptive component creates a competing risk authority.

# 3. Runtime Context

Adaptive decisions may consume:

- market regime and confidence;
- spread;
- liquidity;
- slippage observations;
- data freshness;
- market disorder signals;
- event-risk state;
- account and portfolio exposure;
- current risk policy/version;
- strategy version;
- execution constraints;
- pending-order state.

Inputs must be timestamped and freshness-checked.

# 4. Market Quality Abstraction

Market quality is a normalized contextual abstraction describing **execution/data conditions**, not the structural market regime.

```text
Market Quality
 ├── spread_state
 ├── liquidity_state
 ├── slippage_state
 ├── freshness_state
 ├── disorder_state
 ├── observed_at
 ├── source_reference
 └── quality_version
```

The abstraction must distinguish unavailable data from good quality.

`UNKNOWN`, stale, degraded, or disordered quality must be represented explicitly and may cause stricter downstream behavior.

Canonical market-quality conditions include, as applicable, `NORMAL`, `WIDE_SPREAD`, `LOW_LIQUIDITY`, `HIGH_SLIPPAGE`, `STALE`, `DISORDERED`, and `UNKNOWN`. These conditions do not replace or redefine the structural regime states in `MARKET_REGIME_ARCHITECTURE.md`.

# 5. Event Risk Abstraction

Event risk is a Risk Management input derived from event information.

```text
Event Risk
 ├── event_id
 ├── category
 ├── severity
 ├── affected_scope
 ├── start_at
 ├── end_at
 ├── restriction_policy
 ├── source_reference
 └── evaluated_at
```

Generic events in `EVENT_SYSTEM.md` are coordination mechanisms and do not automatically become event-risk controls.

Event-risk policy may restrict new entries, order types, size, execution timing, or other actions. The policy remains owned by Risk Management.

# 6. Risk Envelope

A risk envelope is a precomputed, auditable representation of the maximum effective risk permitted for a defined scope and context.

```text
Risk Envelope
 ├── envelope_id
 ├── version
 ├── scope
 ├── policy_reference
 ├── effective_constraints
 ├── generated_at
 ├── expires_at
 ├── context_fingerprint
 ├── regime_reference
 ├── market_quality_reference
 ├── event_risk_reference
 └── invalidation_reason
```

An envelope is not a trading approval. Each executable action must still pass the mandatory Risk Gate and any required revalidation.

# 7. Envelope Lifecycle

```text
CONTEXT COLLECTED
      |
      v
ENVELOPE GENERATED
      |
      v
VALID
      |
  +---+---+
  |       |
UPDATE  INVALIDATE
  |       |
  +--> REGENERATE
```

The envelope must be invalidated when material context changes, including policy/version changes, regime transition, market-quality deterioration, event-risk changes, exposure changes, expiry, or context-integrity failure.

# 8. Requested vs Effective Adaptive Risk

Adaptive risk must preserve the distinction:

```text
Requested Risk
      |
      v
Policy / Safety Ceiling
      |
      v
Risk Arbitration
      |
      v
Effective Risk
```

Requested risk is an input. Effective risk is the constrained result accepted by Risk Management.

No AI, strategy, or execution component may self-promote requested risk into effective risk.

# 9. Strategy Eligibility

Strategy existence and current eligibility are separate concepts.

```text
Strategy Definition
      |
      v
Eligibility Evaluation
      |
      +--> ELIGIBLE
      +--> INELIGIBLE
      +--> UNKNOWN
```

Eligibility may consider regime, market quality, event risk, strategy constraints, account state, and risk envelope state.

`ELIGIBLE` does not bypass the Risk Gate.

# 10. Adaptive Strategy

Adaptive strategy may select among pre-approved strategy modes or parameters based on current context.

It must define:

- allowed adaptation dimensions;
- parameter bounds;
- strategy-version identity;
- activation conditions;
- rollback/recovery conditions;
- audit evidence.

Adaptive strategy may not create arbitrary unbounded behavior at runtime.

# 11. Adaptive Execution

Trading Engine may adapt execution within approved constraints.

Possible dimensions include:

- entry timing;
- order type;
- price tolerance;
- slippage tolerance;
- pending-order placement/cancellation behavior;
- retry timing.

Each adaptation must remain within the approved risk envelope and connector capabilities.

Adaptive execution does not change Risk Manager's decision authority.

# 12. Adaptive Risk

Risk Management may reduce effective risk when context deteriorates.

Examples include:

- reduced maximum size;
- reduced portfolio exposure;
- stricter spread/slippage thresholds;
- temporary entry restrictions;
- stricter event windows;
- mandatory revalidation.

Risk expansion requires explicit policy authority and must never be inferred merely from favorable market conditions.

# 13. Hysteresis, Cooldown, and Recovery

Adaptive decisions must avoid rapid oscillation.

A policy should define:

- transition threshold;
- confirmation requirement;
- minimum dwell time;
- cooldown period;
- recovery evidence;
- maximum retry frequency;
- audit trail.

Recovery must be deterministic and may be stricter than the originating condition.

# 14. Decision Chain

The intended architecture is:

```text
Market Data / Events
        |
        v
Regime + Market Quality + Event Risk
        |
        v
Adaptive Context
        |
        +--> Strategy Eligibility
        +--> Adaptive Strategy
        +--> Risk Envelope
                    |
                    v
              Risk Manager
                    |
                    v
               Risk Gate
                    |
                    v
             Trading Engine
                    |
                    v
                 Connector
```

No branch from adaptive context may directly reach a broker.

# 15. Failure Semantics

Adaptive runtime must fail closed or degrade to an explicitly approved conservative mode when:

- required context is unavailable;
- context is stale;
- envelope is expired/invalid;
- event risk is unresolved;
- regime is unknown when required;
- policy/version cannot be resolved;
- adaptation would exceed configured bounds.

Unknown must not silently become permissive behavior.

# 16. Observability and Audit

Every material adaptive decision should record:

- request/correlation identifiers;
- context references;
- regime reference;
- market-quality reference;
- event-risk reference;
- envelope identity/version;
- requested state;
- effective state;
- reason codes;
- timestamps;
- strategy/execution version where applicable.

# 17. Acceptance Criteria

R3.16 adaptive runtime is ready for implementation only when:

- ownership is approved;
- market quality and event risk contracts are approved;
- risk envelope lifecycle is deterministic;
- requested/effective risk semantics are explicit;
- strategy eligibility is separated from strategy existence;
- adaptive strategy/execution/risk bounds are defined;
- hysteresis/cooldown/recovery are deterministic;
- failure semantics are fail-safe;
- audit evidence is sufficient to reconstruct decisions;
- integration with Risk Manager and Trading Engine is contractually defined;
- the boundary between structural regime and market-quality conditions is preserved.

# 18. Non-Goals

This document does not implement market-data ingestion, event detection, regime detection, strategy logic, risk runtime, trading runtime, broker integration, or machine-learning models.
