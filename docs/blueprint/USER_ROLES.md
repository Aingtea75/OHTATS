# OHTATS User Roles & Authorization Foundation

> Foundation blueprint for identity-linked authorization: roles, permissions,
> and capability boundaries.
>
> Authorization **gates access**; it does **not** replace Risk Manager decisions
> or Trading Engine lifecycle ownership.
>
> Role names below are **conceptual baseline examples**, not final production policy.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** User roles & authorization foundation reference

---

# 1. Purpose

Define how OHTATS assigns and evaluates who may perform which actions on which
resources, under least privilege and deny-by-default, without inventing implemented UI
or production role packs.

---

# 2. Scope

**In scope:** role/permission/capability concepts; trading/risk/AI/workflow boundaries;
audit; multi-tenant isolation; testing expectations.

**Out of scope:** source code, schema changes, concrete production role catalogs as policy,
pricing, or claims that RBAC UI is already shipped.

---

# 3. Design Principles

1. Deny by default.
2. Least privilege.
3. Separation of duties for elevated actions.
4. Explicit resource scope (tenant, account, strategy, etc.).
5. Authorization ≠ risk approval.
6. Entitlement (license) may further constrain, never expand past security policy alone without both checks.
7. Language-neutral permission codes.
8. Auditable changes to roles and grants.
9. No broker bypass via elevated roles.
10. Blueprint-aligned with `SECURITY.md`.

---

# 4. Terminology

| Term | Meaning |
|---|---|
| Identity | Authenticated principal (user or service) |
| Role | Named set of permissions (conceptual) |
| Permission | Allowed action on a resource class |
| Capability | Coarse feature gate, often license-linked |
| Scope | Tenant/account/resource boundary of a grant |
| Entitlement | License/subscription-derived access right |

---

# 5. User Identity Boundary

Authorization evaluates an authenticated identity. Identity lifecycle (register, verify)
is product-surface dependent and **planned** where not implemented.

---

# 6. Authentication vs Authorization

- **Authentication** establishes identity.
- **Authorization** decides allow/deny for an action on a resource.

Both required for sensitive operations. Authn success never implies trading risk approval.

---

# 7. Role Model

RBAC (roles → permissions) is the baseline model; attributes/capabilities may refine scope.

Roles are assignable within tenant policy. Examples are conceptual only.

---

# 8. Role Hierarchy

Hierarchy, if used, must not silently grant broker or risk-bypass powers.

Higher roles remain subject to Risk Manager and Trading Engine for executable trading.

---

# 9. System Roles

Conceptual examples (not production mandates):

- platform operator;
- tenant admin;
- trader;
- analyst/read-only;
- service principal.

Final catalogs require human governance approval.

---

# 10. Tenant/User Ownership

Grants are tenant-scoped. Cross-tenant access requires explicit authorized admin paths and audit.

---

# 11. Resource Ownership

Permissions attach to resource classes (accounts, strategies, workflows, reports) with ownership
or membership rules defined at implementation time under this model.

---

# 12. Permission Model

Permissions are stable, language-neutral codes (e.g. `trading.request.create`).

UI labels may localize; codes do not.

---

# 13. Capability Model

Capabilities represent product features (e.g. backtest, copy-trading) often constrained by
license entitlement. Capability without permission still denies; permission without entitlement
may deny when gating is enabled.

---

# 14. Role-Permission Mapping

Mappings are configuration under governance. Changes are auditable. This blueprint does not
ship a frozen production matrix.

---

# 15. Trading Permissions

Control who may submit trading requests or view trading state.

Executable path remains:

```text
User/API/AI/Workflow/Copy → Trading Request → Authorization → Validation
→ Risk Manager → Trading Engine → Connector → Broker/Platform
```

No role may authorize a direct broker command outside this path.

---

# 16. Risk Permissions

Separate view vs configure risk policy. Configuring risk is privileged and auditable.

Risk evaluation authority remains Risk Manager, not the role system alone.

---

# 17. AI Permissions

Gate AI invocation and configuration. AI output is not a broker command and cannot bypass
risk/trading controls.

---

# 18. Workflow Permissions

Gate workflow definition/execution triggers. Workflows cannot send broker commands directly.

---

# 19. Plugin Permissions

Plugins receive only granted capabilities. Plugins cannot obtain implied trading/risk bypass.

---

# 20. Account Permissions

Gate trading-account link, view, and configuration within tenant isolation.

---

# 21. Reporting Permissions

Gate report generation/export. Reporting is read-oriented and non-executing.

---

# 22. Backtest Permissions

Gate backtest run and result access. Backtest remains isolated from live connectors.

---

# 23. Copy Trading Permissions

Gate relationship management and copy configuration. Follower executable actions still pass
risk and trading path.

---

# 24. Administrative Permissions

Tenant/platform admin actions are elevated, audited, and still deny-by-default for undefined actions.

Admin ≠ risk bypass.

---

# 25. Read vs Write vs Execute

Distinguish read, write/configure, and execute. Execute on trading remains subject to risk gate.

---

# 26. Least Privilege

Default grants minimal. Expansion requires explicit assignment.

---

# 27. Separation of Duties

Sensitive pairs (e.g. configure risk policy vs approve production go-live) should be separable
where governance requires.

---

# 28. Privileged Operations

Secret access metadata, role changes, emergency halts, and license overrides are privileged
and heavily audited.

---

# 29. Approval Requirements

Human approval workflows, when used, do not replace Risk Manager or Trading Engine.

---

# 30. Session / Token Boundary

Tokens carry identity and scope claims. Expired/revoked tokens deny. Align with `SECURITY.md`.

---

# 31. API Authorization

Every sensitive API operation evaluates authorization. Stable deny codes; localized messages optional.

---

# 32. Service-to-Service Authorization

Service principals use least privilege. No ambient user impersonation without explicit, audited delegation.

---

# 33. Audit Requirements

Log role/permission changes, privileged access, and authorization denials of investigative value
per `LOGGING.md` / `SECURITY.md` (no secrets in logs).

---

# 34. Security Requirements

Consistent with `SECURITY.md`: fail closed, tenant isolation, no secret leakage via permission errors.

---

# 35. Multi-tenant Isolation

Authorization checks always include tenant scope. Cross-tenant data access is prohibited without
explicit break-glass/admin governance.

---

# 36. Delegation / Impersonation Rules

Delegation must be explicit, time-bounded, scoped, and audited. Default: disallowed.

---

# 37. Emergency / Break-glass Rules

Break-glass, if ever defined, is rare, authenticated, time-limited, and fully audited.
It still must not invent a silent broker path around Trading Engine/Risk Manager unless a
separate governed emergency trading policy explicitly exists (not claimed here).

---

# 38. Role Lifecycle

Create, assign, revoke, expire. Orphaned grants should be reviewable.

---

# 39. Permission Change Governance

Material permission model changes require review. Production policy packs are not auto-approved
by this document.

---

# 40. Failure / Deny-by-Default

If authorization data is unavailable or indeterminate → **deny** sensitive actions.

---

# 41. Testing Requirements

- allow/deny matrix tests for critical permissions;
- tenant isolation tests;
- no broker bypass via role elevation;
- fail-closed when authz store unavailable;
- audit events for grant changes.

---

# 42. Compliance Considerations

Supports access-control evidence needs generically. Jurisdiction-specific packs are future/governance.

---

# 43. Future Extension Rules

Extensions must not:

- move risk authority out of Risk Manager;
- move trading lifecycle out of Trading Engine;
- allow AI/Workflow/Plugin/API direct broker access;
- treat license entitlement as a substitute for authorization.

---

# Related Documents

- `SECURITY.md`
- `LICENSE_SYSTEM.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `API_DESIGN.md`
- `LOGGING.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`

---

# END OF USER_ROLES.md
