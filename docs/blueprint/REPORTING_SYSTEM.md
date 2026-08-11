# OHTATS Reporting System Foundation

> Foundation blueprint for read-oriented, analytical, auditable reporting.
>
> Reporting **summarizes and presents**; it is **non-authoritative** for trading execution.
> Reporting must not place, modify, or cancel orders; must not call brokers; must not bypass
> Risk Manager or Trading Engine.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** Reporting system foundation reference

---

# 1. Purpose

Provide a blueprint for trade, risk, performance, backtest, copy, AI, and operational reports
without claiming specific UI or implemented report packs.

---

# 2. Scope

**In scope:** reporting boundaries, data source concepts, report classes, metrics concepts,
access control, environment separation, testing expectations.

**Out of scope:** source code, schema design, dashboard product selection, live execution features.

---

# 3. Design Principles

1. Read-oriented only.
2. Non-executing.
3. Tenant isolated.
4. Environment-labeled (backtest / forward non-live / live).
5. No secrets in report outputs by default.
6. Reproducible where inputs are versioned.
7. Not a substitute for canonical ledgers when they differ.
8. Align with `SECURITY.md`, `LOGGING.md`, `USER_ROLES.md`.

---

# 4. Reporting Boundary

```text
Canonical domain data / events
        ↓
Reporting read models / queries (planned)
        ↓
Report artifact / export
        ↓
Authorized consumer
```

No path from reporting to Connector/Broker command submission.

---

# 5. Reporting vs Operational State

Operational state is owned by domain services. Reports may lag and must not be used as the
sole real-time trading authority.

---

# 6. Reporting vs Audit

Audit emphasizes who/what/when for control actions. Reporting emphasizes aggregates and
analysis. Both may share sources; neither executes trades.

---

# 7. Reporting vs Analytics

Analytics may extend reporting with deeper models. Same non-executing boundary applies.

---

# 8. Data Sources

Conceptual sources: canonical persistence, validated domain events, backtest results,
copy linkage metadata—per `DATABASE_DESIGN.md` / domain blueprints without schema invention here.

---

# 9. Event Sources

Structured events (`LOGGING.md` / event system) may feed derived reports. Event types remain
language-neutral.

---

# 10. Trade Reports

Summaries of deals/trades as recorded by trading domain—not independent trade inventories.

---

# 11. Order Reports

Order lifecycle views for investigation and operations. Non-mutating.

---

# 12. Position Reports

Position snapshots/histories as derived from canonical position ownership.

---

# 13. Account Reports

Account-level summaries within tenant scope and authorization.

---

# 14. Strategy Reports

Strategy/version performance views when data exists; no profit guarantees.

---

# 15. Risk Reports

Risk decisions, denials, exposures as observed—Risk Manager remains authority for decisions.

---

# 16. Backtest Reports

Simulation metrics under declared assumptions. Not live performance.

---

# 17. Copy Trading Reports

Master/follower linkage outcomes for auditability; not execution authority.

---

# 18. AI Activity Reports

Usage/outcome metadata without default full sensitive prompts or secrets.

---

# 19. Workflow Reports

Workflow run success/failure/latency summaries.

---

# 20. Plugin Reports

Plugin activity within granted capabilities.

---

# 21. Performance Metrics

Conceptual returns/statistics from available data—disclosed as informational, not promises.

---

# 22. PnL Representation

PnL figures are derived displays; currency display follows localization rules without mutating
stored values (`INTERNATIONALIZATION.md`).

---

# 23. Drawdown

Drawdown metrics are analytical. They do not auto-halt trading unless a separate risk policy does.

---

# 24. Exposure

Exposure reports reflect observed positions/orders; risk limits remain Risk Manager policy.

---

# 25. Risk Metrics

Aggregated risk observations for humans; not a parallel risk engine.

---

# 26. Execution Metrics

Latency, fill, reject rates as telemetry-derived analytics where available.

---

# 27. Reliability Metrics

Error rates and availability-oriented report sections may align with observability concepts.

---

# 28. Time / UTC Rules

Internal canonical time: UTC. Display per user locale/timezone policy.

---

# 29. Currency Display Rules

Formatting is presentation-only. No silent FX conversion unless a governed domain service provides rates.

---

# 30. Historical Data

Historical reports must not silently rewrite financial history.

---

# 31. Snapshot vs Event-derived Reporting

Snapshots and event-sourced projections are both allowed conceptually; document methodology
in report metadata when implemented.

---

# 32. Auditability

Report generation by whom/when/parameters should be attributable for sensitive exports.

---

# 33. Reproducibility

Where inputs are versioned (strategy, dataset, window), reports should cite those versions.

---

# 34. Report Generation

On-demand or scheduled generation is planned capability. Schedulers must not submit trades.

---

# 35. Export Concept

Exports inherit access control and redaction. No secret material in exports.

---

# 36. Access Control

Reporting permissions per `USER_ROLES.md`. Least privilege; tenant scoped.

---

# 37. Tenant Isolation

No cross-tenant report data leakage.

---

# 38. Sensitive Data Protection

Align with `SECURITY.md`. Mask accounts/secrets as policy requires.

---

# 39. PII / Secret Redaction

Minimize PII. Never include raw credentials, API keys, or tokens.

---

# 40. Backtest vs Live Separation

Reports must label environment. Backtest metrics must not be presented as live results.

---

# 41. Forward Testing NON-LIVE

Forward-test reports remain non-live evaluation context. Not live trading reports.

Controlled live experiments are a separate governance category.

---

# 42. Reporting Failure Behavior

Generation failure fails the report, not trading controls. No fallback to unsupervised execution.

---

# 43. Performance Considerations

Heavy reports should avoid blocking trading control planes (implementation planned).

---

# 44. Testing Requirements

- non-execution guarantees (no connector calls from reporting path);
- tenant isolation;
- environment labeling;
- redaction tests;
- authorization on generate/export.

---

# 45. Compliance Considerations

Supports evidence/export needs generically without claiming certifications.

---

# 46. Future Extension Rules

Must not:

- add execution side effects to reports;
- bypass Risk/Trading;
- mix unlabeled live and simulation data;
- introduce pricing or profit guarantees into report copy.

---

# Related Documents

- `USER_ROLES.md`
- `LICENSE_SYSTEM.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`
- `SECURITY.md`
- `LOGGING.md`
- `OBSERVABILITY.md`
- `INTERNATIONALIZATION.md`
- `DATABASE_DESIGN.md`

---

# END OF REPORTING_SYSTEM.md
