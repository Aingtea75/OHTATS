# OHTATS Observability Foundation

> Dokumen ini mendefinisikan observability/monitoring sebagai
> **cross-cutting capability** untuk visibility sistem, domain, security,
> audit, dan operasi OHTATS.
>
> Observability menjawab *what/where/how healthy* — **bukan** *what trade to make*.
> Observability **bukan** domain owner dan tidak memperkenalkan Observability Manager
> sebagai module/domain owner baru.
>
> Risk Manager tetap risk authority. Trading Engine tetap lifecycle owner.
> Connector tetap vendor/platform boundary.
>
> Dependency foundation: `LOGGING.md`.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** Observability & monitoring foundation reference

---

# 1. Purpose

Menyediakan foundation agar operator dan reviewer dapat memahami:

- kesehatan sistem dan komponen;
- aliran trading/risk/workflow/connector;
- anomali security dan operational;
- korelasi investigasi insiden;

tanpa mengubah canonical control path atau memberi observability wewenang eksekusi.

---

# 2. Scope

**In scope**

- principles and boundaries of observability;
- relationship to logging, security, audit, and operations;
- conceptual signals: logs, metrics, traces, events, health;
- domain health views (trading, risk, workflow, AI, backtest, copy, connector, API, authn/authz);
- correlation/request/trace identity;
- health, liveness, readiness, dependency health concepts;
- alerting and incident visibility principles;
- access control and sensitive data rules;
- testing expectations;
- governance status REVIEW.

**Out of scope (this PR)**

- source code, agents, or dashboard implementations;
- database schema / SQL / migrations / ERD;
- vendor selection or claims of specific tool usage;
- numeric alert thresholds as final policy.

---

# 3. Observability Principles

1. **Visibility, not authority** — observe outcomes; domains decide.
2. **Aligned with logging** — use `LOGGING.md` event foundations; do not contradict them.
3. **Correlate** — prefer correlation/request/trace context for investigation.
4. **Environment-aware** — separate dev/test/backtest/forward/live signals.
5. **Least sensitive data** — no secrets; minimize PII.
6. **Vendor neutral** — no mandatory observability product in this foundation.
7. **Actionable alerts** — alerts inform humans/ops; they are not trading commands.
8. **Fail closed on controls** — observability failure must not bypass risk/security/authz.
9. **Language-neutral identifiers** — stable machine-readable signal names.
10. **Blueprint aligned** — consistent with Architecture, Security, Testing, i18n, Logging.

---

# 4. Observability as Cross-Cutting Capability

Observability spans runtime components without replacing:

- Risk Manager;
- Trading Engine;
- Workflow Engine;
- Backtest Engine;
- Copy Trading;
- Connector;
- Security controls.

No new “Observability Manager” domain owner is introduced by this document.

---

# 5. Observability Boundaries

```text
Canonical control path / domain activity
              |
              v
     emit signals (logs/metrics/traces/health)
              |
              v
     collection → correlation → analysis
              |
              v
     visualization / alerting → human/ops response
```

Observability must not:

- make trading or risk decisions;
- mutate orders or positions as authority;
- send broker commands;
- bypass Authorization, Risk Manager, Trading Engine, or Connector.

Canonical trading path remains:

```text
User/API/AI/Workflow/Copy
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
Broker/Platform
```

---

# 6. Relationship with Logging

`LOGGING.md` defines structured logging, event taxonomy, redaction, correlation ids,
and failure rules.

Observability **consumes and correlates** those signals (and metrics/traces) for health
and investigation. It must not redefine conflicting event-type semantics or weaken
secret redaction rules.

---

# 7. Relationship with Security

Security observability highlights authentication failures, authorization denials,
policy violations, and abuse patterns—without exposing secrets.

Security controls remain authoritative; observability only reports.

Consistent with `SECURITY.md`.

---

# 8. Relationship with Audit

Audit needs who/what/when/outcome evidence. Observability supports investigation and
may complement audit streams defined under security/governance policy.

Observability does not replace authoritative financial ledgers.

---

# 9. Relationship with Operations

Ops uses health, alerts, and dashboards for detection and response.

Incident **response ownership** remains with Operations/Security governance processes.
This document does not invent a new Incident Manager domain owner.

---

# 10. Canonical Observability Model

Conceptual flow:

```text
Sources
  ↓
Signals
  ↓
Collection
  ↓
Correlation
  ↓
Analysis
  ↓
Visualization / Alerting
  ↓
Human / Operational Response
```

This pipeline is **visibility only**, never execution authority.

---

# 11. Signals

Primary signal classes:

- **Logs** — structured event records (`LOGGING.md`);
- **Metrics** — numeric time-series aggregates;
- **Traces** — distributed request/path spans (when implemented);
- **Events** — domain/operational discrete occurrences;
- **Health signals** — component/dependency readiness state.

---

# 12. Logs

Logs follow `LOGGING.md`: structured fields, language-neutral `event_type`, UTC timestamps,
correlation/request ids, redaction, and non-authoritative recording of outcomes.

---

# 13. Metrics

Metrics summarize rates, latencies, errors, and saturation for triage.

Metrics must not encode secrets. Labels/tags should avoid unnecessary PII.

Final threshold numbers are governance/ops decisions, not fixed here.

---

# 14. Traces

Traces correlate spans across components for latency and failure path analysis when tracing
is implemented.

This foundation does **not** mandate a tracing product.

---

# 15. Events

Discrete events (including those from the logging taxonomy) feed alerting and investigation.

Event identifiers remain language-neutral.

---

# 16. Health Signals

Health expresses whether a component or dependency is usable for its intended work.

Health is observational state—not a trading allow/deny authority.

---

# 17. System Health

System-level view: process/runtime availability, resource pressure, and platform-wide error
conditions—without claiming specific host agents.

---

# 18. Application Health

Application services expose conceptual health for their process/API surface readiness.

---

# 19. Domain Health

Domain services (strategy, risk, trading, workflow, etc.) may expose domain-oriented health
indicators that reflect ability to perform their **own** responsibilities—not cross-domain
bypass signals.

---

# 20. Trading Health

Observe trading-request rates, rejections, execution latency, failures, and lifecycle anomalies
as **telemetry**, not as order masters.

Trading Engine remains lifecycle owner.

---

# 21. Risk Health

Observe risk evaluation latency, rejection counts, and risk-path failures.

Risk Manager remains the decision authority; metrics only describe observed outcomes.

---

# 22. Workflow Health

Observe workflow execution counts, success/failure, and latency.

Workflow health must not imply broker direct access.

---

# 23. AI Health

Observe request counts, latency, failures, and non-secret provider/model metadata when available.

AI output is not execution authority; AI must not gain broker bypass via observability.

---

# 24. Backtest Health

Observe backtest run counts, duration, failures, and isolation integrity signals.

Backtest must remain isolated from live broker commands; telemetry should label simulation context.

---

# 25. Copy Trading Health

Observe signal volume, copy decisions, risk validation outcomes, and execution linkages for
investigation—without becoming copy-execution authority.

---

# 26. Connector Health

Observe connectivity, latency, request/response outcomes, error rates, and availability.

Never expose connector credentials in telemetry.

---

# 27. Broker Connectivity Health

Observe reachability and error classes of broker/platform links as known to connectors.

External uncertainty remains subject to trading reconciliation policy; health is not a fill.

---

# 28. API Health

Observe API availability, latency, error rates, and authn/authz failure rates at the edge.

---

# 29. Authentication Health

Observe login success/failure rates and related security signals without logging secrets.

---

# 30. Authorization Health

Observe denial rates and anomalous authorization patterns for investigation.

Denials remain security/domain outcomes; observability only reports.

---

# 31. Security Observability

Aggregate security-relevant signals for detection and forensics support, under elevated
access control and retention policy alignment with `SECURITY.md` / `LOGGING.md`.

---

# 32. Audit Observability

Support reconstruction of critical action chains (actor, correlation, outcome) for audit
investigation without substituting canonical financial records.

---

# 33. Correlation ID

Propagate correlation identifiers across related operations when available, consistent with
`LOGGING.md`, to enable end-to-end investigation.

---

# 34. Request ID

Request identifiers scope individual inbound units of work and complement correlation ids.

---

# 35. Trace Context

Optional distributed trace context may link spans when tracing is implemented.

Vendor-neutral: no required tracing product.

---

# 36. Timestamp and Time

**Internal canonical time foundation:** UTC.

Display follows localization/user timezone policy per `INTERNATIONALIZATION.md`.

Do not rewrite stored telemetry timestamps solely due to UI language or timezone preference.

---

# 37. Internationalization and Localization

- Metric names, event types, and internal codes are language-neutral and stable.
- User-facing dashboard/alert text may be localized.
- Do not translate machine identifiers used for routing or automation.

---

# 38. Service/Component Identity

Telemetry should identify emitting service/component boundaries with stable names
(not localized UI labels).

---

# 39. Environment Identity

Label telemetry by environment class at minimum conceptually:

- development;
- test;
- backtest;
- forward test (**NON-LIVE**);
- production/live.

Do not treat Forward Testing as Live. Controlled live experiments are a separate governance
category and must not be labeled as Forward Testing.

---

# 40. Health Checks

Components may expose conceptual health check endpoints or signals when implemented.

Health checks report state; they do not execute trades.

---

# 41. Readiness

**Readiness:** whether a component is prepared to accept work (dependencies met, warmup done).

Unready services should not be treated as implicitly risk-approved for trading.

---

# 42. Liveness

**Liveness:** whether a component process/control loop is still alive.

Liveness failure is an ops concern; it does not create a trading bypass.

---

# 43. Dependency Health

Observe critical dependency availability (e.g. configuration, secret store reachability as
metadata only, downstream connectors)—without logging secret values.

Missing dependency for risk evaluation remains fail-closed for executable trading.

---

# 44. Metrics Taxonomy

Conceptual metric groups (illustrative, not final thresholds):

**System:** availability, latency, throughput, error rate, resource saturation.

**Trading:** request rate, rejection rate, execution latency, execution failure, lifecycle anomalies.

**Risk:** rejection count, evaluation latency, risk-path failure.

**Workflow:** execution count, success/failure, latency.

**Connector:** request count, response latency, error rate, connectivity state.

**AI:** request count, latency, failure, non-secret provider/model metadata.

**Backtest:** execution count, duration, failure, isolation-violation signals.

**Copy trading:** signal count, copy decision count, rejection, execution outcome linkage.

---

# 45. Alerting Principles

Alerts should be:

- actionable;
- severity-based;
- correlatable;
- conceptually deduplicated where possible;
- traceable to signals;
- auditable in operational process.

Alerts **must not** automatically open/close/modify trades, bypass risk, or bypass security.

---

# 46. Alert Severity

Conceptual severity aligned with operational triage (compatible with logging severity concepts):

| Severity | Intent |
|---|---|
| INFO | Notable informational condition |
| WARNING | Degraded or elevated risk of impact |
| ERROR | Failed operation requiring attention |
| CRITICAL | Severe control-plane or safety-impacting condition |

Do not invent conflicting severity systems versus `LOGGING.md`.

---

# 47. Alert Routing

Routing (who is notified) is operational policy: on-call, security, engineering—as defined
outside this blueprint.

Routing must not equal automated broker execution.

---

# 48. Incident Detection

Detection uses thresholds, anomaly signals, and correlated event patterns (planned).

Detection opens investigation; it does not grant trading authority.

---

# 49. Incident Investigation

Support the conceptual chain:

```text
Detection → Triage → Investigation → Diagnosis → Resolution → Evidence
```

Investigators should reconstruct actor/context, correlation, control-path outcomes, and errors
without secret leakage.

---

# 50. Dashboard Principles

Dashboards present health and trends for humans.

Principles:

- environment-separated views;
- clear distinction of backtest / forward (non-live) / live;
- no secret fields;
- stable identifiers plus optional localized labels.

No specific dashboard product is required by this foundation.

---

# 51. Access Control

Telemetry is not world-readable.

Principles:

- least privilege;
- role-based access;
- tighter controls for security/sensitive streams;
- audit of privileged telemetry access where required by policy.

---

# 52. Sensitive Data Protection

Never expose in telemetry:

- passwords;
- API keys;
- access/refresh tokens;
- private keys;
- broker credentials;
- encryption keys;
- other secrets.

Minimize PII. Prefer references and redaction consistent with `LOGGING.md` and `SECURITY.md`.

Do not invent example real secrets in docs or fixtures.

---

# 53. Failure Handling

If observability/collection pipelines fail:

- trading authority unchanged;
- risk authority unchanged;
- authorization and security controls remain in force;
- canonical trading path unchanged;
- fail-closed rules for executable actions remain.

Observability outage should itself be detectable operationally when possible (meta-monitoring),
without mandating a vendor.

---

# 54. Testing Strategy

Aligned with `TESTING_STRATEGY.md` and `LOGGING.md`:

- signal/metric correctness for critical series;
- trace/correlation linkage when tracing is present;
- health state correctness;
- environment separation labels;
- alert correctness and conceptual dedup behavior;
- sensitive data absence in sinks under test policy;
- access control tests for sensitive telemetry;
- failure-mode tests (observability down ≠ control bypass);
- backtest isolation and forward-test non-live labeling;
- no production secrets in fixtures.

---

# 55. Governance

- Document status: **REVIEW** (not APPROVED, not LOCKED).
- INDEX synchronization is a **separate follow-up PR** after acceptance.
- Changes affecting security-sensitive telemetry rules require review.
- Does not alter Constitution status vocabulary.

---

# 56. Acceptance Criteria

This foundation is ready for continued review when:

- observability is cross-cutting and non-authoritative;
- logs/metrics/traces/events/health are defined conceptually;
- health, readiness, liveness, dependency health are distinguished;
- alerting is non-executing and severity-based;
- security/access/redaction rules are explicit;
- UTC + i18n rules align;
- backtest isolation and Forward Testing NON-LIVE are explicit;
- canonical trading path and domain ownership preserved;
- no source code, schema, ERD, or vendor lock-in;
- status remains REVIEW.

---

# 57. Operational Constraints

- Do not use dashboards as the sole ledger for balances or positions.
- Do not auto-trade from alerts.
- Do not mix live and non-live telemetry without labels.
- Do not treat log/metric lag as execution acknowledgment.
- Do not dump unrestricted payloads into shared sinks by default.

---

# 58. Future Observability Extensions

Possible future work (not claimed as implemented):

- concrete metric catalogs and SLO definitions;
- pipeline/storage selection under architecture review;
- dashboard packs per environment;
- automated correlation rules;
- elevated immutable evidence tiers for incidents;
- sampling policies for high-volume debug telemetry.

Extensions must not:

- move risk authority out of Risk Manager;
- move trading lifecycle out of Trading Engine;
- allow AI/Workflow/Plugin/API direct broker access;
- weaken secret protection;
- blur Forward Testing with live trading.

---

# Related Documents

- `PROJECT_CONSTITUTION.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `SECURITY.md`
- `LOGGING.md`
- `TESTING_STRATEGY.md`
- `ROADMAP.md`
- `INTERNATIONALIZATION.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `WORKFLOW_ENGINE.md`
- `BACKTEST_ENGINE.md`
- `COPY_TRADING.md`
- `AI_ARCHITECTURE.md`
- `ERROR_HANDLING.md`
- `EVENT_SYSTEM.md`
- `../user-guide/README.md`

---

# END OF OBSERVABILITY.md
