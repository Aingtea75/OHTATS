# ADR-008 — Stage 4 R3.14–R3.16 Reconciliation

**Status:** REVIEW
**Decision Scope:** Stage 4 documentation reconciliation after ADR-007

---

## 1. Decision

Stage 4 formalizes the missing R3.14/R3.15 semantics and the R3.16 architecture without implementing production runtime.

## 2. R3.14

AI Council disagreement is treated as consultative evidence available to Risk Management. It cannot create authority, override risk, or directly execute trading actions.

## 3. R3.15

`RISK_MANAGEMENT.md` remains the sole canonical risk home. The document now defines a System Safety Ceiling, deterministic constraint arbitration, requested/approved/constrained/effective risk states, SAFE/ACTIVE profiles, and deterministic emergency recovery.

## 4. R3.16

Market regime and adaptive runtime are formalized as separate REVIEW documents. They define ownership and contracts for regime state, market quality, event risk, risk envelopes, strategy eligibility, adaptive strategy/execution/risk, and hysteresis/cooldown.

Implementation remains blocked until these architecture contracts are reviewed and accepted.

## 5. Governance Constraints

- Project Owner remains final authority.
- Risk Manager remains risk authority.
- Trading Engine remains execution-lifecycle authority.
- ADR-006 strategy/deployment/account binding remains canonical.
- No production runtime is claimed by documentation or fixture tests.
- No baseline is promoted to APPROVED or LOCKED by this ADR.

## 6. Gate

The next stage is evidence audit and Architect/Project Owner review. Only accepted contracts may proceed to implementation planning.
