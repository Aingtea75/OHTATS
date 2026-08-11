# OHTATS License System Foundation

> Foundation blueprint for licensing, subscription concepts, and feature entitlement.
>
> License controls **entitlement/capability access**. It does **not** replace authorization,
> Risk Manager, or Trading Engine, and must never become a security or broker bypass.
>
> **No pricing, payment packages, or named payment gateways are defined here.**

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** License & entitlement foundation reference

---

# 1. Purpose

Define how OHTATS may grant, constrain, suspend, or revoke access to product capabilities
through license/subscription/entitlement concepts—without implementing billing or claiming
commercial packages.

---

# 2. Scope

**In scope:** entitlement model, lifecycle states, feature gating concepts, binding concepts,
audit, failure-safe behavior, testing expectations.

**Out of scope:** prices, SKUs, tax, specific payment providers, source code, schema changes.

---

# 3. Design Principles

1. Entitlement gates features; authorization still required.
2. No license path to broker command.
3. No financial guarantees or profit claims.
4. Deny/fail safe when entitlement state is unknown for gated features.
5. Auditable lifecycle transitions.
6. Tenant isolation of entitlements.
7. Vendor-neutral billing boundary.
8. Planned capabilities marked honestly.

---

# 4. Terminology

| Term | Meaning |
|---|---|
| License | Right to use defined capabilities under terms |
| Subscription | Time-bounded commercial relationship concept (no pricing here) |
| Entitlement | Concrete capability grant derived from license/plan |
| Plan | Conceptual bundle of entitlements (not a price list) |
| Quota | Optional quantitative limit concept |

---

# 5. License vs Subscription vs Entitlement

License/subscription are commercial/legal relationship concepts; entitlement is what the
platform evaluates for feature gating. Implementation may unify or separate storage later
without changing this boundary.

---

# 6. Product Capability Model

Capabilities map to product facilities (trading enablement surfaces, AI, backtest, copy,
plugins, API, reporting, etc.) as **conceptual gates**, not claims of availability.

---

# 7. Feature Entitlement

A feature may require: authenticated identity + authorization permission + valid entitlement
(when gating is enabled for that feature).

---

# 8. Plan Concept

Plans group entitlements. Plan names/prices are **not** specified in this foundation.

---

# 9. License Lifecycle

Conceptual states may include: draft, active, grace, suspended, expired, revoked.

Exact state machine is refined at implementation under this model.

---

# 10. Trial Concept

Trials are optional time-bounded entitlements. Trial must not weaken security or risk controls.

---

# 11. Activation

Activation associates entitlement with a principal/tenant when product flows support it (planned).

---

# 12. Renewal

Renewal extends validity. Billing execution is outside this blueprint’s ownership.

---

# 13. Expiration

On expiry, gated features deny until renewed or policy provides grace.

---

# 14. Suspension

Suspension disables entitlements under policy (abuse, admin, billing hold)—audited.

---

# 15. Revocation

Revocation permanently or indefinitely removes entitlement; auditable; fail closed for gated features.

---

# 16. Grace Period Concept

Optional grace may allow limited continued access after expiry. Grace is policy, not a security bypass.

---

# 17. User/Account Binding

Entitlements may bind to user and/or trading-account scope as product design requires.

---

# 18. Organization/Tenant Binding

Tenant-level entitlements apply within tenant isolation boundaries.

---

# 19. Device Binding Concept

Optional future device limits are conceptual only; not claimed as implemented.

---

# 20. Multi-account Access

Whether one entitlement covers multiple trading accounts is plan/policy configuration—not fixed here.

---

# 21. Feature Gating

Gating checks run before sensitive feature entry. Gating denial is not a risk decision and not a trade.

---

# 22. AI Provider / BYOK Boundary

Entitlement may allow AI features. BYOK still uses secret boundaries (`SECURITY.md`).
AI never gains broker direct access via license.

---

# 23. External Integration Entitlement

Connector/platform facilities may be entitlement-gated. Connector remains vendor boundary.

---

# 24. Plugin Entitlement

Plugin install/use may require entitlement plus plugin capability grants.

---

# 25. EA / Indicator Entitlement

Strategy/EA/indicator access may be gated when marketplace/distribution exists (planned).

---

# 26. Backtest Entitlement

Backtest runs may be gated; isolation from live remains mandatory regardless of license.

---

# 27. Copy Trading Entitlement

Copy features may be gated; follower actions still require risk + trading path.

---

# 28. Reporting Entitlement

Report types/exports may be gated; reporting remains non-executing.

---

# 29. API Entitlement

API access tiers are conceptual; authorization still applies per call.

---

# 30. Usage Limits Concept

Optional limits (runs, calls) are conceptual quotas—not priced packages.

---

# 31. Quota Concept

Quotas decrement/enforce soft or hard limits per policy when implemented.

---

# 32. Time-based Access

Validity windows use consistent time foundation (UTC internal).

---

# 33. License State Machine

Transitions (activate, renew, suspend, expire, revoke) must be explicit and auditable.
Illegal transitions deny.

---

# 34. Authorization Integration

```text
Authn → Authz (USER_ROLES) → Entitlement gate (LICENSE) → Domain controls (Risk/Trading/...)
```

License cannot skip authorization or risk.

---

# 35. Security

License records are not secret stores for broker keys. Align with `SECURITY.md`.

---

# 36. Anti-abuse Considerations

Detect sharing/abuse patterns where product requires; responses are suspend/revoke—not trading bypass.

---

# 37. Audit Trail

Record entitlement changes, denials of investigative value, and admin overrides (no secrets).

---

# 38. Payment Provider Boundary

Billing providers, if any, are external. This blueprint does not select or claim a provider.

---

# 39. External Billing Boundary

Invoices/payments are outside trading domain ownership. Webhooks must be authenticated and
must not place trades.

---

# 40. Offline / Temporary Connectivity Concept

Optional offline grace is future/policy. Must not disable risk controls.

---

# 41. Failure-safe Behavior

If entitlement service is unavailable: fail closed for gated features; do not auto-approve trading.

---

# 42. No Financial Guarantee

Licensing never promises profits, returns, or investment outcomes.

---

# 43. Testing Requirements

- state transition tests;
- gating deny when expired/revoked;
- authz still required when entitled;
- no broker path via license flags;
- tenant isolation of entitlements.

---

# 44. Compliance Considerations

Supports commercial/access records generically; jurisdiction packs are separate governance.

---

# 45. Future Extension Rules

Must not:

- bypass Risk Manager or Trading Engine;
- embed prices as architecture truth;
- store payment card data in license records contrary to security policy;
- treat entitlement as authentication.

---

# Related Documents

- `USER_ROLES.md`
- `SECURITY.md`
- `MODULE_SPECIFICATION.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `PLUGIN_SYSTEM.md`
- `../user-guide/README.md`

---

# END OF LICENSE_SYSTEM.md
