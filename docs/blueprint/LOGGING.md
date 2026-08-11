# OHTATS Logging Foundation

> Dokumen ini mendefinisikan logging sebagai **cross-cutting capability**
> untuk observability, investigation, operations, dan dukungan audit di OHTATS.
>
> Logging **mengobservasi dan mencatat**; logging **bukan** domain owner.
> Logging tidak mengambil keputusan trading, risk, workflow, atau broker command.
>
> Risk Manager tetap risk authority. Trading Engine tetap lifecycle owner.
> Connector tetap vendor/platform boundary.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** Logging foundation reference

---

# 1. Purpose

Menyediakan foundation logging agar OHTATS dapat:

- diobservasi secara operasional;
- ditelusuri saat incident;
- mendukung investigasi security, trading, risk, workflow, dan connector;
- mendukung audit trail di mana event log relevan;
- menjaga redaction secret/PII;
- tetap netral terhadap vendor tooling.

Logging bukan pengganti authoritative financial state di persistence canonical.

---

# 2. Scope

**In scope**

- logging principles and boundaries;
- conceptual structured event model;
- log levels and severity;
- event taxonomy (language-neutral types);
- correlation / request / trace context;
- timestamp and timezone rules;
- sensitive data and secret redaction;
- integrity, access control, retention principles;
- failure handling when logging is unavailable;
- relationship to monitoring/observability (without vendor lock-in);
- testing expectations for logging behavior.

**Out of scope (this PR)**

- source code or library configuration;
- database schema / SQL / migrations / ERD;
- choosing a specific log vendor or stack;
- claiming any concrete tool is already in production.

---

# 3. Logging Principles

1. **Observe, do not decide** — logs record; domains decide.
2. **Structured first** — prefer machine-parseable fields over free-form only.
3. **Language-neutral event types** — identifiers are stable tokens, not UI copy.
4. **Least sensitive data** — minimize secrets and PII.
5. **Correlate end-to-end** — propagate correlation/request context where available.
6. **UTC internally** — consistent with internationalization time foundation.
7. **Fail closed on controls** — logging failure must not bypass risk/security/authz.
8. **Vendor neutral** — no mandatory vendor in this foundation.
9. **Environment aware** — distinguish backtest, forward test, and live contexts.
10. **Blueprint aligned** — consistent with Security, Architecture, Testing, i18n.

---

# 4. Logging as Cross-Cutting Capability

Logging spans API, domain services, connectors, jobs, and clients as applicable.

This document does **not** introduce a new domain owner that replaces:

- Risk Manager;
- Trading Engine;
- Workflow Engine;
- Backtest Engine;
- Copy Trading;
- Connector;
- Security architecture controls.

Operational logging services support runtime visibility; they do not own business masters.

---

# 5. Logging Boundaries

```text
Domain Action / Control Path
        |
        v
   (optional) emit structured log/event
        |
        v
   Log / event pipeline (planned)
        |
        v
   Retention / access / investigation
```

Logging must not:

- approve or deny risk;
- create or mutate orders/positions as authority;
- send broker commands;
- bypass Authorization, Risk Manager, Trading Engine, or Connector boundaries.

---

# 6. Canonical Event Model

Conceptual contract (not a database schema):

| Field | Role |
|---|---|
| `event_id` | Unique event identity |
| `event_type` | Language-neutral type token |
| `event_version` | Contract version of the event shape |
| `timestamp` | Event time (canonical UTC foundation) |
| `correlation_id` | End-to-end correlation |
| `request_id` | Per-request identity when applicable |
| `actor` / context | Who/what initiated (user, service, system) within policy |
| `source` | Emitting component/boundary |
| `severity` | Operational/security severity |
| `outcome` | success / failure / denied / error / etc. |
| `metadata` | Non-sensitive structured context |
| `error` | Structured error info when present |

Additional domain fields may be attached without becoming a substitute for canonical persistence entities.

---

# 7. Structured Logging

Prefer structured fields over unstructured blobs for searchable operational data.

Unstructured text may accompany structure for human readability but must still obey redaction rules.

---

# 8. Log Levels

Conceptual levels (names may map to implementation later):

| Level | Typical use |
|---|---|
| TRACE | Highly detailed diagnostics (non-production default off) |
| DEBUG | Development diagnostics |
| INFO | Normal operational milestones |
| WARN | Recoverable anomalies |
| ERROR | Failed operations requiring attention |
| FATAL/CRITICAL | Process/control-plane failure (if used) |

Level selection must not hide mandatory security/audit signals behind debug-only paths in production policy.

---

# 9. Event Severity

Severity may differ from log level (e.g. an INFO log of a high-impact security denial).

Severity supports triage and alerting policy without changing domain outcomes.

---

# 10. Event Taxonomy

Event types are hierarchical, stable, language-neutral tokens.

Illustrative patterns (not an exhaustive production catalog):

```text
authentication.login.success
authentication.login.failure
authorization.denied
security.policy.violation

trading.request.received
trading.request.rejected
risk.check.passed
risk.check.rejected

order.submitted
order.accepted
order.rejected

position.opened
position.closed

workflow.started
workflow.completed
workflow.failed

connector.request.sent
connector.response.received
connector.error
```

Do not use translated UI strings as `event_type`.

---

# 11. System Events

System/runtime events cover process start/stop, configuration reload signals, health degradation, and similar operational facts—without embedding secrets.

---

# 12. Authentication Events

Record authentication attempts and outcomes with stable codes.

Avoid logging passwords, full session tokens, or raw credentials.

Prefer actor identifiers and result codes over sensitive payloads.

---

# 13. Authorization Events

Record allow/deny decisions relevant to investigation, including resource/action class when safe.

Denial must remain a domain/security outcome; the log only records it.

---

# 14. Security Events

Security-relevant events include policy violations, lockouts, credential rotation metadata (not secret values), and suspected abuse patterns.

Treat as elevated-care for retention and access.

---

# 15. Trading Events

Log trading-request lifecycle milestones as observed from the control path.

Logging does not submit trades. Canonical path remains:

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

# 16. Risk Events

Record risk evaluation outcomes (pass/reject/halt context) without re-implementing risk logic in the logger.

Risk Manager remains the authority for the decision.

---

# 17. Order Events

Record order state transitions as emitted by Trading Engine ownership.

Logs are not the order master; persistence rules in database blueprints remain authoritative for financial history.

---

# 18. Position Events

Record position open/close/update observations consistent with trading domain events.

Do not invent position state in logs that contradicts canonical position records.

---

# 19. Workflow Events

Record workflow start/step/complete/fail markers when Workflow Engine emits them.

Workflow logging must not imply a broker bypass path.

---

# 20. AI Events

May record:

- request metadata;
- provider/model context when available and non-secret;
- outcome/error;
- linkage to correlation ids.

Must not:

- store secrets;
- automatically persist full sensitive prompts by default without policy;
- treat AI output as execution authority;
- grant AI broker access via logging side effects.

---

# 21. Backtest Events

Backtest logging is isolated from live execution context.

Backtest must not produce production broker commands; logs should make the simulation context explicit.

---

# 22. Copy Trading Events

Support audit of:

- source signal reference;
- copy decision metadata;
- risk validation outcome;
- execution outcome linkage.

Logging is not copy-execution authority; Risk + Trading path remains mandatory for follower executable actions.

---

# 23. Connector Events

Record connector request/response/error operational outcomes.

Never log broker credentials or raw secret material.

Connector remains the vendor/platform boundary.

---

# 24. Broker Integration Events

Where broker-facing interactions are observed, log normalized outcomes and error classes—not secret handshake material.

Unknown external outcomes remain subject to reconciliation policy in trading design; logs support investigation.

---

# 25. API Events

API edge may log request receipt, authn/authz outcomes, validation failures, and response status classes.

Avoid logging full payloads that contain secrets or unnecessary PII.

---

# 26. User Action Events

Significant user actions (configuration changes, enable/disable controls) may be logged for accountability within policy.

---

# 27. Audit Events

Audit-oriented records emphasize who/what/when/outcome for critical actions.

Application logs support audit but do not automatically replace dedicated audit retention policies where distinguished by Security/governance.

---

# 28. Correlation ID

A correlation identifier should flow across related hops of a logical operation when available.

Correlation enables end-to-end investigation without requiring a specific vendor tracer.

---

# 29. Request ID

A request identifier scopes a single inbound request or unit of work.

Request id and correlation id may differ; both should be stable tokens, not localized text.

---

# 30. Trace Context

Distributed trace context may be propagated when tracing is implemented.

This foundation does **not** mandate a specific tracing product.

---

# 31. Event Timestamp

Each event carries a timestamp for ordering and investigation.

Clock skew handling is operational; domain event ordering still follows canonical domain rules.

---

# 32. Timezone Rules

**Internal canonical time foundation:** UTC.

Display of times in tools/UI follows user/locale policy per `INTERNATIONALIZATION.md`.

Do not rewrite stored event timestamps solely because of UI language or timezone preference.

---

# 33. Internationalization / Localization

- `event_type` and internal codes remain language-neutral.
- User-facing presentation of messages may be localized via catalogs.
- Do not translate identifiers used for routing, metrics, or automated response.

Consistent with `INTERNATIONALIZATION.md`.

---

# 34. Sensitive Data Protection

Classify fields before logging. Default to omit or redact sensitive classes.

Sensitive operational data requires justification, access control, and retention alignment.

---

# 35. Secret / Credential Redaction

Never log in raw form:

- passwords;
- API keys;
- access/refresh tokens;
- private keys;
- broker credentials;
- encryption keys;
- other secrets.

Use redaction, masking, or secret **references** (not values).

Do not invent example real secrets in documentation or fixtures.

---

# 36. PII Handling

Minimize PII in logs.

If PII is required for a justified operational/audit reason:

- document justification in policy;
- restrict access;
- apply retention limits;
- avoid secondary sprawl into unrestricted debug sinks.

---

# 37. Log Integrity

Security/audit-grade logging should pursue:

- tamper resistance;
- integrity verification concepts;
- controlled access;
- traceability of access.

This foundation does not select a concrete integrity technology.

---

# 38. Log Immutability

Prefer append-oriented operational history for investigation streams.

Corrections, if any, should be compensating events—not silent rewrites of evidence—subject to governance.

---

# 39. Retention Policy

Retention must consider:

- security needs;
- audit needs;
- legal/regulatory requirements (when applicable);
- operational needs;
- privacy requirements.

Final retention durations are **governance decisions**, not fixed numbers in this foundation.

---

# 40. Log Access Control

Logs are not world-readable data.

Principles:

- least privilege;
- role-based access;
- tighter controls for security/sensitive streams;
- audit of privileged log access where required by policy.

---

# 41. Log Failure Handling

If the logging subsystem fails:

- do **not** bypass risk, security, or authorization;
- do **not** auto-approve trading;
- domain fail-closed rules remain in force.

For critical audit/security events, policy should define durability/handling requirements (for example retry, local buffer, or incident escalation)—without mandating a vendor.

---

# 42. Logging Availability

Best-effort diagnostic logs may degrade under overload.

Control-plane and safety decisions must not depend on log pipeline availability as an allow path.

---

# 43. Observability Integration

Logs may feed:

- metrics derivation;
- monitoring;
- alerting;
- tracing correlation;
- incident investigation.

Integration is planned/foundation-level. No specific observability vendor is required by this document.

---

# 44. Monitoring Integration

Monitoring may alert on error rates, auth failures, risk denial spikes, connector errors, etc., using log/metric signals.

Alert routing is operational policy, separate from trading authority.

---

# 45. Incident Investigation

Investigators should be able to reconstruct:

- actor/context;
- correlation chain;
- control-path outcomes (authz, risk, trading, connector);
- errors without secret leakage.

Preserve evidence per retention and legal hold policies when defined.

---

# 46. Testing Strategy

Aligned with `TESTING_STRATEGY.md`:

- required field presence for critical event types;
- redaction tests (secrets never appear in sinks under test policy);
- correlation propagation tests;
- timestamp/UTC expectations;
- failure-mode tests (logging down ≠ risk bypass);
- access control tests for sensitive streams;
- environment labeling (backtest vs forward vs live) where applicable;
- no production secrets in test fixtures.

---

# 47. Logging Governance

- Document status: **REVIEW** (not APPROVED, not LOCKED).
- Changes affecting security/audit logging rules require review.
- INDEX synchronization for this document is a separate follow-up PR after acceptance.
- Logging does not alter Constitution status vocabulary.

---

# 48. Acceptance Criteria

This foundation is ready for continued review when:

- logging is cross-cutting and non-authoritative for trading/risk;
- conceptual event model is defined;
- taxonomy uses language-neutral types;
- secret/PII rules are explicit;
- UTC + i18n display rules align;
- failure handling does not bypass controls;
- backtest isolation and forward-test non-live distinction are explicit;
- no source code, schema, ERD, or vendor lock-in is introduced;
- status remains REVIEW.

---

# 49. Operational Constraints

- Do not use logs as the sole source of truth for balances, positions, or legal ledgers.
- Do not dump unrestricted payloads in production by default.
- Do not treat log shipping delay as trading ack.
- Distinguish **backtest**, **forward test (NON-LIVE)**, and **live** contexts in metadata when the action is environment-scoped.
- Controlled live experiments, if ever authorized, are a separate governance category—not Forward Testing.

---

# 50. Future Logging Extensions

Possible future work (not claimed as implemented):

- concrete catalog of production event types;
- pipeline and storage selection under architecture review;
- automated redaction libraries;
- SIEM integrations;
- immutable evidence stores for elevated audit tiers;
- sampling policies for high-volume debug streams.

Extensions must not:

- move risk authority out of Risk Manager;
- move trading lifecycle out of Trading Engine;
- allow AI/Workflow/Plugin/API direct broker access;
- weaken secret redaction;
- blur Forward Testing with live trading.

---

# Related Documents

- `PROJECT_CONSTITUTION.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `SECURITY.md`
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

# END OF LOGGING.md
