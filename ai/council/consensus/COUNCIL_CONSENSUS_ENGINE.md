# OHTATS AI Council Consensus Engine

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/consensus/COUNCIL_CONSENSUS_ENGINE.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md
Model Specification: ai/council/models/COUNCIL_MODELS.md
Review Engine: ai/council/review/COUNCIL_REVIEW_ENGINE.md
Orchestrator: ai/council/orchestrator/COUNCIL_ORCHESTRATOR.md

---

# 1. Purpose

The Consensus Engine analyzes independent Council reviews and determines whether a proposal has reached a sufficient review state for Project Owner decision.

The Consensus Engine is not the Project Owner.

It must never automatically convert consensus into approval.

---

# 2. Input

The Consensus Engine receives:

- CouncilProposal
- CouncilReview records
- CouncilEvidence records
- CouncilObjection records
- acceptance criteria
- applicable governance references

---

# 3. Consensus States

Supported states:

NOT_REACHED
CONDITIONAL
REACHED
BLOCKED

---

# 4. NOT_REACHED

Consensus is NOT_REACHED when:

- important reviews are missing;
- material disagreement remains unresolved;
- required evidence is missing;
- acceptance criteria cannot yet be evaluated;
- additional investigation is required.

The proposal may return to:

REVISION

or:

COUNCIL_REVIEW

---

# 5. CONDITIONAL

Consensus is CONDITIONAL when:

- the proposal is generally supportable;
- no unresolved critical objection exists;
- important conditions remain;
- acceptance requires explicit conditions or additional verification.

Conditions must be recorded.

The Project Owner must be able to see the conditions before making a decision.

---

# 6. REACHED

Consensus is REACHED when:

- required reviews have been completed;
- material evidence has been considered;
- no unresolved critical objection remains;
- mandatory acceptance criteria are satisfied or demonstrably satisfiable;
- remaining disagreements are non-critical and documented.

Consensus does not mean unanimous agreement.

---

# 7. BLOCKED

Consensus is BLOCKED when a credible unresolved issue prevents safe acceptance.

Examples:

- critical security vulnerability;
- authorization bypass;
- risk-control bypass;
- unsafe trading behavior;
- corruption of canonical repository state;
- destructive irreversible behavior;
- violation of Project Constitution;
- mandatory acceptance criterion failure.

A BLOCKED proposal cannot proceed directly to acceptance.

---

# 8. Critical Objection Rule

Any unresolved CRITICAL objection must be surfaced.

The engine must record:

- objection_id
- category
- description
- evidence
- affected requirement
- resolution status

A critical objection may block consensus even if most reviewers support the proposal.

---

# 9. Evidence Weight

The engine should prioritize evidence according to traceability.

Preferred order:

1. Reproducible measured behavior
2. Tests
3. Source code
4. Git history
5. Official technical documentation
6. System logs
7. External sources
8. Inference
9. Assumption

This ordering is a review heuristic, not an absolute mathematical truth.

Evidence must remain classified according to the Council model.

---

# 10. Agreement Analysis

The engine should identify:

- common conclusions;
- common supporting evidence;
- common risks;
- common recommendations;
- areas of disagreement;
- contradictory claims.

Agreement alone is not sufficient for acceptance.

---

# 11. Disagreement Analysis

For each material disagreement, record:

- topic;
- participant positions;
- supporting evidence;
- assumptions;
- strongest counterargument;
- whether the disagreement is testable;
- required follow-up action.

If the disagreement can be objectively tested, testing should be preferred over voting.

---

# 12. Voting Boundary

Voting may provide decision-support information.

Possible summary:

APPROVE
APPROVE_WITH_CONDITIONS
REVIEW_REQUIRED
REJECT
ABSTAIN

Voting must not override:

- evidence;
- critical objections;
- security controls;
- risk controls;
- Project Constitution;
- Project Owner authority.

A minority reviewer may block further investigation when the objection is technically credible and critical.

---

# 13. Acceptance Criteria Evaluation

The engine must evaluate each proposal acceptance criterion.

Each criterion should produce:

SATISFIED
PARTIALLY_SATISFIED
NOT_SATISFIED
UNKNOWN

Unknown criteria must not silently become satisfied.

---

# 14. Governance Compatibility

The Consensus Engine must check compatibility with:

- PROJECT_CONSTITUTION.md
- approved architecture decisions;
- relevant ADRs;
- security requirements;
- risk requirements;
- trading boundaries;
- audit requirements.

A lower-level Council decision cannot override higher-level governance.

---

# 15. Owner Decision Boundary

The Consensus Engine produces a recommendation.

The Project Owner makes the final decision.

Conceptual flow:

Consensus Engine
       ↓
Council Recommendation
       ↓
Project Owner
       ↓
Final Decision

Possible owner decisions:

APPROVE
APPROVE_WITH_CONDITIONS
REQUEST_REVISION
REJECT

The engine must not silently perform the final decision.

---

# 16. Safe Defaults

If evidence is insufficient:

NOT_REACHED

If required criteria are unknown:

NOT_REACHED

If unresolved critical objection exists:

BLOCKED

If reviews conflict materially:

NOT_REACHED

If provider failure prevents a mandatory review:

NOT_REACHED

The engine must prefer additional investigation over unsafe automatic approval.

---

# 17. Consensus Record

A consensus record should contain:

- consensus_id
- proposal_id
- status
- review_count
- completed_review_count
- unresolved_objection_count
- critical_objection_count
- satisfied_criteria_count
- unknown_criteria_count
- common_findings
- disagreements
- conditions
- recommendation
- generated_at

---

# 18. Auditability

Consensus results should reference:

- proposal;
- reviews;
- evidence;
- objections;
- acceptance criteria;
- governance documents;
- related ADR;
- related PR where available.

Another reviewer should be able to reconstruct why the engine produced its recommendation.

---

# 19. Trading Boundary

Consensus output is advisory.

It must not directly:

- place orders;
- modify positions;
- modify trading accounts;
- bypass Risk Engine;
- bypass Authorization;
- bypass Validation;
- bypass Audit Controls.

Any future trading action remains subject to the canonical OHTATS trading architecture.

---

# 20. Security Boundary

The Consensus Engine must not store:

- API keys;
- passwords;
- broker credentials;
- private authentication tokens;
- private keys.

Sensitive information must remain in approved secure configuration systems.

---

# 21. Provider Independence

Consensus must operate on normalized CouncilReview records.

It must not contain provider-specific rules.

For example:

OpenAI support must not automatically receive more weight than Claude support.

Claude support must not automatically receive more weight than Grok support.

Provider identity is metadata, not authority.

---

# 22. Failure Handling

Consensus calculation must explicitly handle:

- missing reviews;
- malformed reviews;
- missing evidence;
- unresolved objections;
- conflicting evidence;
- provider failures;
- governance conflicts;
- acceptance-criteria failures.

Failure to calculate consensus safely should produce:

REVIEW_REQUIRED

rather than automatic approval.

---

# 23. Acceptance Criteria

Consensus Engine v0.1 is ready for implementation when:

1. Consensus states are defined.
2. NOT_REACHED behavior is defined.
3. CONDITIONAL behavior is defined.
4. REACHED behavior is defined.
5. BLOCKED behavior is defined.
6. Critical objection handling is defined.
7. Evidence analysis is defined.
8. Agreement analysis is defined.
9. Disagreement analysis is defined.
10. Voting boundary is defined.
11. Acceptance criteria evaluation is defined.
12. Governance compatibility is defined.
13. Owner decision boundary is defined.
14. Safe defaults are defined.
15. Consensus record is defined.
16. Auditability is defined.
17. Trading boundary is defined.
18. Security boundary is defined.
19. Provider independence is preserved.
20. Failure handling is defined.
21. No unresolved contradiction exists with the Council Protocol, Models, Orchestrator, or Review Engine.

---

# 24. Initial Status

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Implementation: NOT STARTED

---

# END OF COUNCIL_CONSENSUS_ENGINE.md
