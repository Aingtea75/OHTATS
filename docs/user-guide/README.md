# OHTATS User Guide

> This document is the **User Documentation Foundation** for OHTATS.
> It is a **documentation map**, not a claim that every feature or UI is already implemented.
>
> Canonical architecture, trading lifecycle, risk policy, security, and database design
> remain defined in `docs/blueprint/`. If this guide conflicts with a blueprint, the blueprint wins.

**Status:** REVIEW

**Version:** 0.1.0

**Documentation lifecycle (internal):** PLANNED → DRAFT → REVIEW → APPROVED → PUBLISHED

---

# 1. Purpose

Provide a structured map for end-user and operator documentation covering onboarding,
configuration, risk-controlled trading workflows, AI-assisted tooling, simulation,
monitoring, and support.

This foundation does **not**:

- invent UI screens, buttons, or menus;
- invent API endpoints or request formats;
- invent pricing or subscription packages;
- invent broker integrations beyond documented target platforms;
- promise profits or financial outcomes.

Detailed tutorials are published only when the corresponding capability is implemented
and validated.

---

# 2. Audience

| Audience | Primary need |
|---|---|
| End users / traders | Safe configuration, risk controls, simulation, and trading workflows |
| Operators / admins | Access, entitlements, monitoring, escalation |
| Integrators | Connector and configuration boundaries (non-bypass) |
| Support staff | Troubleshooting map and escalation paths |

---

# 3. Documentation Principles

1. **Blueprint is source of truth** for architecture and controls.
2. **Document what is implemented**; mark the rest as planned or pending.
3. **No financial guarantees** — OHTATS is tooling with risk controls, not investment advice.
4. **Risk-first** — executable trading always requires authorization, validation, and Risk Gate.
5. **No bypass paths** — AI, Workflow, Plugin, and API must not send broker commands directly.
6. **Secrets stay out of the repository** — credentials use secure configuration boundaries.
7. **Forward Testing is non-live** — it is not live trading.
8. **Backtest is isolated** from live connectors and live state.
9. **User-controlled configuration** — users own their risk and connection choices within policy.
10. **Evidence over claims** — operational steps reference validated product behavior.

---

# 4. Getting Started

**Maturity:** Planned / available when client onboarding is implemented.

Intended high-level journey (documentation target, not implementation claim):

```text
Register
  ↓
Profile
  ↓
Choose Facilities
  ↓
Connect Trading Account
  ↓
Configure Risk
  ↓
Optional AI
  ↓
Select Strategy / EA
  ↓
Backtest
  ↓
Forward Test
  ↓
Enable Trading
  ↓
Monitor
  ↓
Review Reports
```

Step-by-step onboarding tutorials will be added when registration, profile, and
facility selection flows are implemented and validated.

---

# 5. Account & Profile

**Maturity:** Planned.

Future documentation will cover:

- account registration and verification (as implemented);
- profile identity fields;
- preference and notification settings;
- session and access hygiene.

No specific form fields or UI labels are defined here until the client layer delivers them.

Related blueprint: identity/access concepts in `SECURITY.md` and module boundaries in
`MODULE_SPECIFICATION.md`.

---

# 6. Trading Account Connection

**Maturity:** Planned per connector; documentation pending implementation and validation.

Target platforms (capability targets from platform design, not a claim of current availability):

### 6.1 MT4

Detailed operational tutorial will be provided when the MT4 connector and user connection
flow are implemented and validated.

### 6.2 MT5

Detailed operational tutorial will be provided when the MT5 connector and user connection
flow are implemented and validated.

### 6.3 TradingView

Detailed operational tutorial will be provided when the TradingView integration path and
user connection flow are implemented and validated.

### Shared rules (always)

- Credentials and API keys are handled via secure secret boundaries — never committed to git.
- Connection does not grant a bypass of Risk Manager or Trading Engine.
- Connector is a vendor boundary; it does not define OHTATS risk policy.

Related blueprints: `TRADING_ENGINE.md`, `SECURITY.md`, `ARCHITECTURE.md`.

---

# 7. AI Features

**Maturity:** Planned / available when AI provider abstraction and user configuration are implemented.

### 7.1 AI provider configuration

Documentation will describe how users select or configure allowed AI providers once the
product exposes that configuration. Provider lists in blueprints are capability targets,
not a guarantee of simultaneous availability.

### 7.2 BYOK / user-provided AI key

If bring-your-own-key is supported, guides will cover secure entry and rotation.
Keys must not be stored in the repository or shared in support tickets in plaintext.

### 7.3 Local AI option

Local/runtime options (for example local model hosts) are documented only when the
corresponding adapter is implemented and validated.

### 7.4 AI safety boundaries

Non-negotiable for all AI documentation:

- AI output is **not** a broker command;
- AI suggestions still pass authorization, validation, Risk Gate, and Trading Engine;
- AI must not be described as a direct path to the broker.

Related blueprints: `AI_ARCHITECTURE.md`, `AI_PROVIDER.md`, `SECURITY.md`.

---

# 8. Strategy & EA

**Maturity:** Planned.

Future guides will cover strategy selection, version awareness, and deployment concepts
as exposed by the product. Published executable strategy versions are treated as immutable
in the platform design.

No claim is made here about specific Expert Advisor formats, marketplaces, or UI wizards
until implemented.

Related: `MODULE_SPECIFICATION.md` (Strategy Manager), trading/risk blueprints.

---

# 9. Indicator

**Maturity:** Planned.

Indicator usage documentation will be added when indicator tooling is part of an
implemented, validated user workflow. Indicators do not create a privileged trading path.

---

# 10. Risk Management

**Maturity:** Documentation expands with Risk Manager implementation; principles are fixed.

Users should understand:

- Risk Gate is **mandatory** before executable trading actions;
- deny/halt outcomes cannot be bypassed by AI, workflow, copy trading, or plugins;
- risk configuration is user- and policy-controlled within authorized scope;
- risk service unavailability is expected to fail closed for executable actions.

Detailed policy screens and parameter names will be documented when implemented.

Related blueprint: `RISK_MANAGEMENT.md`.

---

# 11. Backtesting

**Maturity:** Planned / available when Backtest Engine user flows are implemented.

Documentation principles:

- backtest is **historical simulation**;
- backtest must not place live orders or mutate live trading state;
- results are under declared assumptions (data version, strategy version, costs models);
- backtest metrics are not live performance guarantees.

Related blueprint: `BACKTEST_ENGINE.md`, `TESTING_STRATEGY.md`.

---

# 12. Forward Testing

**Maturity:** Planned.

Forward Testing uses real-time or near-real-time data for evaluation and remains **NON-LIVE**.
It must not be documented as live trading and must not send live broker commands.

Any future controlled live experiment is a separate governance category and is not part of
Forward Testing documentation.

Related: `TESTING_STRATEGY.md`.

---

# 13. Trading

**Maturity:** Planned / expands with Trading Core and connector readiness.

User-facing trading documentation will explain:

- trading request as intent, distinct from an order;
- the control path: Authorization → Validation → Risk → Trading Engine → Connector;
- monitoring of request/order/position state as exposed by the product;
- that timeouts and unknown external outcomes require reconciliation—not blind resubmit.

Live trading enablement is environment- and policy-controlled. Guides must not instruct
users to bypass risk or security controls.

Related blueprints: `TRADING_ENGINE.md`, `SECURITY.md`.

---

# 14. Copy Trading

**Maturity:** Planned.

When available, documentation will cover master/follower relationships and follower-specific
risk. Master approval does **not** imply follower approval. Follower actions enter the normal
risk and trading pipeline.

Related blueprint: `COPY_TRADING.md`.

---

# 15. Workflow

**Maturity:** Planned.

Workflow documentation will describe orchestration of multi-step processes when the Workflow
Engine is exposed to users. Workflows do not send broker commands directly and do not replace
Risk Manager or Trading Engine.

Related blueprint: `WORKFLOW_ENGINE.md`.

---

# 16. Reporting

**Maturity:** Planned.

Reporting guides will cover available report types once Reporting Manager surfaces are
implemented. Reports present validated data; they do not rewrite historical financial records.

---

# 17. Notifications

**Maturity:** Planned.

Notification preferences and channels will be documented when notification delivery is
implemented. Notifications are operational signals, not trading authority.

---

# 18. Subscription / Rental Facilities

**Maturity:** Planned.

Entitlement and facility selection will be documented when Licensing & Subscription behavior
is implemented. **No pricing packages, fees, or commercial offers are defined in this foundation.**

---

# 19. License & Feature Access

**Maturity:** Planned.

Documentation will explain how entitlements gate features once the license system is live.
Entitlement is not ownership of trading history and does not bypass risk or security controls.

---

# 20. Security

**Maturity:** Principles available from blueprint; user how-tos expand with product surfaces.

Users should expect:

- authentication and authorization on sensitive actions;
- tenant and account isolation;
- no broker/API secrets in git or public channels;
- auditability of critical actions where the product records them.

Related blueprint: `SECURITY.md`.

---

# 21. Account & Credential Safety

**Maturity:** Ongoing guidance (principles now; product-specific steps later).

Recommended practice:

- use unique, strong credentials for platform access;
- store broker and AI keys only in approved secure configuration paths;
- revoke compromised tokens/keys promptly;
- never share secrets in chat, screenshots, or repositories;
- treat support requests as never requiring full secret disclosure in plaintext channels.

---

# 22. Troubleshooting

**Maturity:** Map only until operational runbooks exist.

Future troubleshooting entries will be tied to real error codes and product states.
Until then, general guidance:

- distinguish authentication failure, authorization denial, risk denial, and connector failure;
- do not “fix” a timeout by blindly resubmitting executable trading actions;
- escalate unresolved security or trading-control issues through the support path below.

---

# 23. FAQ

**Maturity:** Seed FAQ (non-promissory).

**Does OHTATS guarantee profits?**  
No. Documentation must never promise profits or specific financial outcomes.

**Can AI place trades directly at the broker?**  
No. AI is not a direct broker path. Executable actions follow Risk + Trading Engine controls.

**Is Forward Testing the same as live trading?**  
No. Forward Testing is non-live evaluation.

**Is Backtest the same as live performance?**  
No. Backtest is simulation under declared assumptions.

**Where is the source of truth for architecture?**  
`docs/blueprint/`, not this user guide.

---

# 24. Glossary

| Term | Meaning (user-oriented) |
|---|---|
| Trading Request | Intent to evaluate/execute a trading action; not yet an order |
| Risk Gate | Mandatory risk evaluation before executable trading |
| Connector | Adapter to an external broker/platform |
| Backtest | Historical simulation, isolated from live |
| Forward Testing | Non-live forward evaluation |
| BYOK | Bring-your-own-key for provider credentials, when supported |
| Entitlement | License/subscription-gated feature access |

A fuller glossary may later align with `docs/blueprint/GLOSSARY.md` when that document is filled.

---

# 25. User Support / Escalation

**Maturity:** Planned operational channels.

When support channels are published by the project, this section will list:

- how to report product defects;
- how to report security concerns;
- what information to include (environment, correlation identifiers, **redacted** configs).

Do not include secrets in escalation materials.

---

# 26. Future Documentation Extensions

Allowed extensions after implementation milestones:

- step-by-step guides per connector (MT4/MT5/TradingView/others);
- AI configuration walkthroughs;
- risk policy user guides;
- backtest/forward-test cookbooks;
- copy-trading operator guides;
- reporting and notification setup;
- entitlement and access FAQs.

Extension rules:

- no architecture invention;
- no financial guarantees;
- no bypass of Risk / Trading / Security controls;
- mark maturity honestly (PLANNED / DRAFT / REVIEW / APPROVED / PUBLISHED).

---

# Related Blueprint Documents

- `docs/blueprint/PROJECT_CONSTITUTION.md`
- `docs/blueprint/ARCHITECTURE.md`
- `docs/blueprint/MODULE_SPECIFICATION.md`
- `docs/blueprint/SECURITY.md`
- `docs/blueprint/TESTING_STRATEGY.md`
- `docs/blueprint/TRADING_ENGINE.md`
- `docs/blueprint/RISK_MANAGEMENT.md`
- `docs/blueprint/BACKTEST_ENGINE.md`
- `docs/blueprint/COPY_TRADING.md`
- `docs/blueprint/WORKFLOW_ENGINE.md`
- `docs/blueprint/AI_ARCHITECTURE.md`
- `docs/blueprint/ROADMAP.md`

---

# END OF USER GUIDE FOUNDATION
