# OHTATS Backtest Engine

> Canonical blueprint for deterministic, reproducible, isolated historical simulation. Backtest execution MUST remain separated from live trading execution and live operational state.

**Status:** REVIEW

**BACKTEST ENGINE BLUEPRINT — BASELINE**

**Version:** 1.0.0

**Authority:** Backtest domain reference

---

# 1. Purpose

Backtest Engine provides a controlled environment for evaluating strategies, indicators, risk policies, and execution assumptions against historical market data without sending live orders or mutating live trading state.

Primary goals:
- reproducibility;
- deterministic execution where the same inputs permit it;
- strategy/version traceability;
- dataset/version traceability;
- risk-model traceability;
- realistic execution simulation;
- separation from live connectors;
- auditable results;
- comparable experiments;
- safe failure handling.

---

# 2. Non-Negotiable Boundary

```text
BACKTEST
Dataset -> Simulation -> Strategy -> Risk Model -> Simulated Execution -> Results

LIVE
Market -> Strategy -> Risk Manager -> Trading Engine -> Live Connector -> Broker/Platform
```

Backtest code MUST NOT call a live broker connector, live order endpoint, live account mutation path, or live risk state mutation path.

A simulation adapter may implement the same canonical contracts used by live components, but it must be a distinct execution boundary.

---

# 3. Ownership

| Capability | Owner |
|---|---|
| Backtest orchestration | Backtest Engine |
| Dataset selection | Data/Backtest control plane |
| Strategy execution | Strategy Engine under backtest context |
| Simulated risk | Backtest Risk Model / isolated Risk context |
| Simulated order lifecycle | Backtest Simulation Adapter |
| Live order lifecycle | Trading Engine |
| Live connector transport | Connector layer |
| Result persistence | Backtest/Reporting services using canonical persistence contracts |
| Experiment identity | Backtest Engine |

Backtest Engine owns simulation orchestration, not live trading authority.

---

# 4. Backtest Job Contract

Every run must have an immutable or reproducibly addressable configuration containing, at minimum:
- `backtest_id`;
- tenant/user/actor scope;
- strategy identifier;
- strategy version/commit reference;
- dataset identifier and version;
- instrument universe;
- timeframe(s);
- start/end timestamps;
- timezone convention;
- initial capital;
- currency;
- leverage/margin assumptions;
- fee/commission model;
- spread model;
- slippage model;
- execution model;
- risk-policy/model version;
- parameter set;
- simulator version;
- engine version;
- random seed when stochastic simulation is enabled.

Changing any material input creates a distinct reproducible experiment configuration.

---

# 5. Dataset Contract

Historical data must be identifiable by stable dataset identity/version. The engine must record source/provider, dataset version or content fingerprint, instrument mapping, timestamp convention, timezone, granularity, adjustment assumptions, missing-data policy, quality status, and ingestion/transformation version.

The same dataset version and configuration should produce equivalent results under the same simulator version and deterministic seed.

---

# 6. Strategy Boundary

A strategy may consume historical market data and simulated account state through approved interfaces. Backtest context explicitly supplies a simulated clock, account state, positions/orders, historical events, strategy configuration, isolated risk context, and simulation APIs.

Strategy execution in backtest context MUST have no path to live connector authority.

---

# 7. Simulation Clock

Backtest execution uses a controlled simulation clock. Trading decisions must not depend on wall-clock time. Event timestamps advance according to the historical dataset; latency and timers operate on simulated time.

---

# 8. Market Event Model

Historical inputs may include ticks, bars/candles, quotes, bid/ask, volume where available, sessions, instrument metadata, corporate/action events, and explicitly versioned external event/news datasets.

The chosen event resolution must be explicit. The engine must not silently manufacture unavailable intrabar information.

---

# 9. Look-Ahead and Data Leakage Prevention

The engine must prevent future information from becoming available before its historical timestamp through ordered event delivery, feature availability timestamps, no future-bar access, publication-time semantics for external events, and deterministic warm-up handling.

A result violating these controls is invalid for performance claims.

---

# 10. Simulated Risk Boundary

Backtest uses an isolated risk model/context derived from the specified risk-policy/model version. It evaluates applicable position, exposure, drawdown/loss, margin/leverage, strategy, account, and circuit-breaker constraints.

Live risk state is never consulted as mutable authority for a backtest.

---

# 11. Simulated Order Lifecycle

```text
Strategy Intent
      ↓
Simulated Risk Gate
      ↓
Simulated Order
      ↓
Simulated Matching / Execution
      ↓
Simulated Deal
      ↓
Simulated Position
      ↓
Events / Metrics
```

The semantics remain compatible with the canonical trading lifecycle while allowing simulation-specific execution assumptions.

---

# 12. Execution Model

The execution model explicitly defines market/limit/stop behavior, fill and partial-fill assumptions, slippage, spread, latency, rejection assumptions, liquidity constraints where modeled, session/market closure behavior, price precision, and volume step.

Simulated fills must never be represented as actual historical executions.

---

# 13. Costs and Funding

Where applicable, simulation models and discloses commissions, spread, slippage, swaps/funding, financing, taxes/fees, and conversion costs. Cost models are versioned or reproducibly configured.

---

# 14. Portfolio and Account Accounting

The simulator maintains isolated balance, equity, realized/unrealized P&L, fees, margin, available margin, exposure, drawdown, and position state sufficient for the supported instruments.

---

# 15. Parameter and Experiment Management

Parameter changes create distinct experiment configurations. Parameter sweeps have unique trial identity, inherited dataset/strategy versions, explicit parameters, risk/simulator configuration, result status, and reproducibility metadata. Results are never silently overwritten by later trials.

---

# 16. Reproducibility

```text
Strategy Version
+ Dataset Version
+ Parameter Set
+ Risk Model Version
+ Simulator Version
+ Engine Version
+ Execution/Cost Models
+ Seed (if applicable)
= Reproducible Experiment
```

If exact determinism is not possible, the source of nondeterminism and seed must be recorded.

---

# 17. Result Contract

Results should include experiment identity, return/profit metrics, fees/costs, maximum drawdown, win/loss statistics, profit factor, exposure, trade count, execution statistics, equity curve, trade history, risk events, rejected actions, simulator assumptions, and data-quality indicators as applicable.

Metrics must distinguish simulated results from live performance.

---

# 18. Auditability

Each run records who/what started it, configuration, strategy version, data version, execution assumptions, risk version, simulator version, start/end time, completion/failure state, and result identity.

Historical backtest results must not be silently rewritten.

---

# 19. Failure Handling

A run fails explicitly for missing/invalid data, unavailable strategy version, incompatible simulator, invalid configuration, unresolved instrument mapping, impossible assumptions, resource exhaustion, deterministic integrity violations, or detected look-ahead/data leakage.

Partial results are marked incomplete and are not presented as final successful results.

---

# 20. Live Isolation

Isolation exists at code, configuration, connector, state, and authorization boundaries. Required controls include a separate simulation adapter/interface, no live credentials, no live connector dependency, no mutation of live account state, explicit environment/context markers, authorization preventing live submission, and tests proving isolation.

---

# 21. Multi-Platform Support

Backtesting may simulate MT4, MT5, TradingView, or other supported platform semantics through versioned simulation adapters. Canonical strategy and risk contracts remain platform-neutral where possible; platform-specific behavior is modeled explicitly.

---

# 22. Strategy Comparison and Validation

Comparisons use equivalent datasets, periods, cost assumptions, risk assumptions, simulator versions, and execution models. Out-of-sample and walk-forward validation may be supported as distinct experiment phases.

---

# 23. Reporting Boundary

```text
Backtest Engine -> Result Store -> Reporting -> User
```

Reporting presents results but does not alter the underlying experiment result.

---

# 24. Security

Backtest jobs enforce tenant isolation, authorization, resource limits, and protection of proprietary strategy/data assets. External datasets and plugins are treated as untrusted inputs and validated before execution. No live credential is available to a backtest process merely because the user also has live trading access.

---

# 25. Acceptance Criteria

Backtest Engine is ready for approval only when:
- live connectors cannot be reached from the backtest execution path;
- live state cannot be mutated;
- strategy/data/risk/simulator versions are traceable;
- simulation clock is controlled;
- look-ahead leakage is prevented;
- execution and cost assumptions are explicit;
- risk evaluation is isolated;
- results are reproducible or nondeterminism is disclosed;
- failed/incomplete runs are distinguishable from valid results;
- experiment history is auditable;
- parameter trials are independently identifiable;
- multi-platform differences are explicit;
- reporting cannot rewrite canonical results.

---

# 26. Final Boundary

```text
                 BACKTEST DOMAIN
                       |
             +---------+---------+
             |                   |
        Historical Data      Strategy Version
             |                   |
             +---------+---------+
                       |
                 Backtest Engine
                       |
             +---------+---------+
             |                   |
      Simulated Risk      Simulation Adapter
             |                   |
             +---------+---------+
                       |
                Simulated Results
                       |
                  Reporting

                 X
                 |
          NO LIVE CONNECTOR
          NO LIVE ORDER
          NO LIVE STATE
```

The Backtest Engine is a simulation authority, not a live trading authority. Its purpose is to produce reproducible evidence under explicitly declared assumptions before any strategy is considered for live execution.