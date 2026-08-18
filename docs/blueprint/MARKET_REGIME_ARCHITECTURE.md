# OHTATS Market Regime Architecture

> Defines the R3.16 market-regime model as an architectural contract. This document formalizes ownership, states, confidence, transitions, invalidation, and downstream consumption. It does not implement a runtime detector.

---

# Status

**MARKET REGIME ARCHITECTURE — REVIEW**

**Version:** 1.0.0

**Authority:** Market / Strategy Runtime architecture reference

---

# 1. Purpose

Market regime describes the current structural condition of a tradable instrument/session so downstream strategy, execution, and risk components can make condition-aware decisions.

Regime is contextual evidence, not a trading command and not a replacement for Risk Management authority.

# 2. Canonical Ownership

| Capability | Owner |
|---|---|
| Regime model/state | Market / Strategy Runtime |
| Regime detection | Market / Strategy Runtime |
| Regime confidence | Market / Strategy Runtime |
| Regime transition | Market / Strategy Runtime |
| Regime invalidation | Market / Strategy Runtime |
| Risk response to regime | Risk Manager |
| Strategy eligibility | Strategy Runtime |
| Execution adaptation | Trading Engine |

No regime component may directly submit, modify, or cancel a broker order.

# 3. Canonical Regime States

The baseline state vocabulary is:

- `TRENDING`
- `RANGING`
- `BREAKOUT`
- `HIGH_VOLATILITY`
- `LOW_LIQUIDITY`
- `DISORDERED`
- `UNKNOWN`

Implementations may use a richer internal model, but externally exposed states must map deterministically to the canonical vocabulary or an approved extension.

`UNKNOWN` is the fail-safe state when required evidence is unavailable, stale, contradictory, or below the detector's minimum confidence threshold.

# 4. Regime Evidence

A regime observation should contain at minimum:

```text
Regime Observation
 ├── observation_id
 ├── instrument_id
 ├── observed_at
 ├── regime_state
 ├── confidence
 ├── evidence_reference
 ├── detector_version
 ├── market_context_reference
 └── validity / expiry
```

Confidence is advisory evidence. It does not itself authorize trading.

# 5. Detection Contract

Detection must be deterministic for a fixed input/context and detector version.

A detector must declare:

1. required market inputs;
2. minimum data freshness;
3. minimum confidence threshold;
4. detector/model version;
5. evidence required to emit each state;
6. behavior when inputs are missing or contradictory.

A detector must not silently convert missing evidence into a high-confidence regime.

# 6. Transition Model

Regime transitions are explicit state changes:

```text
CURRENT REGIME
      |
      v
NEW EVIDENCE
      |
      v
TRANSITION VALIDATION
      |
   +--+--+
   |     |
 VALID  REJECT
   |     |
   v     v
NEW    CURRENT
STATE  STATE
```

A transition record should include previous state, new state, evidence reference, confidence, detector version, timestamp, and transition reason.

# 7. Invalidation

A regime observation becomes invalid when any applicable condition occurs:

- observation expiry;
- stale market context;
- detector version incompatibility;
- source/data integrity failure;
- confidence falls below the required threshold;
- contradictory evidence invalidates the observation;
- instrument/session context changes materially.

Invalid observations must not be consumed as current authoritative regime state.

# 8. Hysteresis

Regime changes must support hysteresis to prevent rapid oscillation around a boundary.

A transition policy may require:

- confirmation across multiple observations;
- minimum dwell time;
- confidence margin;
- persistence threshold;
- explicit recovery evidence.

Hysteresis is a regime-state control, not a risk override.

# 9. Cooldown and Recovery

After a high-risk regime or invalidation, a consumer may impose a cooldown before normal eligibility resumes.

Cooldown must define:

- scope;
- start condition;
- duration or clearing condition;
- evidence required for recovery;
- audit identifiers.

Risk Manager retains authority to impose a stricter restriction regardless of regime recovery.

# 10. Downstream Consumption

Regime information may be consumed by:

```text
Market Regime
    |
    +--> Strategy Eligibility
    |
    +--> Adaptive Strategy
    |
    +--> Execution Adaptation
    |
    +--> Risk Evaluation
    |
    +--> Risk Envelope Invalidation
```

Consumers must treat regime as contextual input and must preserve their own authority boundaries.

# 11. Safety Rules

1. Regime does not equal signal.
2. Regime does not equal permission to trade.
3. Regime cannot bypass authorization or risk controls.
4. `UNKNOWN` must not be interpreted as normal market conditions.
5. Regime history must remain auditable.
6. Detector/model changes must be versioned.

# 12. Acceptance Criteria

This architecture is ready for approval only when:

- canonical states and ownership are accepted;
- detection inputs and confidence semantics are defined;
- transition and invalidation semantics are deterministic;
- hysteresis and cooldown semantics are defined;
- downstream interfaces are identified;
- risk authority remains with Risk Manager;
- no direct broker execution path exists from regime detection;
- implementation tests can reproduce a fixed detector version and evidence set.

# 13. Non-Goals

This document does not implement a detector, machine-learning model, market-data adapter, strategy, order execution, or risk engine.
