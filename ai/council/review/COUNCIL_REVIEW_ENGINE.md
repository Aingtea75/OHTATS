# OHTATS AI Council Review Engine

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/review/COUNCIL_REVIEW_ENGINE.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md
Model Specification: ai/council/models/COUNCIL_MODELS.md
Provider Interface: ai/council/providers/COUNCIL_PROVIDER_INTERFACE.md
Orchestrator: ai/council/orchestrator/COUNCIL_ORCHESTRATOR.md

---

# 1. Purpose

The Review Engine coordinates independent reviews of a Council Proposal.

It converts provider responses into structured CouncilReview records.

The Review Engine does not make the final Project Owner decision.

---

# 2. Input

The Review Engine receives:

- CouncilProposal
- CouncilSession
- CouncilParticipant
- assigned perspective
- relevant evidence
- review instructions

---

# 3. Review Perspective

Supported perspectives:

DESIGN
ENGINEERING
RISK
SECURITY
OPERATIONS
COMPLIANCE

Important proposals should normally include:

DESIGN
ENGINEERING
RISK

Additional perspectives may be added when required.

---

# 4. Review Output

Each participant review should produce:

- review_id
- proposal_id
- participant_id
- perspective
- conclusion
- findings
- assumptions
- risks
- recommendations
- evidence_references
- objection_references
- status
- created_at

Review status:

PENDING
IN_PROGRESS
COMPLETED
FAILED
REQUIRES_REVISION

---

# 5. Independence Rule

Each participant should initially review the proposal independently.

Recommended sequence:

Proposal
    |
    +----> Participant A
    |
    +----> Participant B
    |
    +----> Participant C
    |
    v
Independent Reviews
    |
    v
Aggregation

A participant should not receive another participant's conclusion before completing its own independent review unless the workflow explicitly enters a critique phase.

---

# 6. Required Review Questions

A review should evaluate:

1. What is correct?
2. What is uncertain?
3. What is incorrect?
4. What is missing?
5. What risks exist?
6. What evidence supports the conclusion?
7. What alternative solution may be preferable?
8. Does the proposal satisfy its acceptance criteria?
9. Does the proposal conflict with existing OHTATS governance?
10. Does the proposal introduce security, trading, operational, or compliance concerns?

---

# 7. Evidence Handling

Evidence referenced by a review should become structured CouncilEvidence.

Evidence classifications:

FACT
INFERENCE
ASSUMPTION
UNKNOWN

The Review Engine must preserve the distinction.

It must not silently convert:

ASSUMPTION

into:

FACT

---

# 8. Objection Handling

A review may generate one or more CouncilObjection records.

Severity:

INFO
MINOR
MAJOR
CRITICAL

Categories:

SECURITY
AUTHORIZATION
DATA
RISK
TRADING
ARCHITECTURE
GOVERNANCE
COMPLIANCE
OPERATIONS
TESTING

A CRITICAL objection must be surfaced to the Consensus Engine.

---

# 9. Conflict Detection

The Review Engine should identify disagreements between reviews.

Examples:

- different architectural conclusions;
- incompatible implementation recommendations;
- conflicting risk assessments;
- contradictory evidence interpretation;
- different acceptance-criteria assessments.

Conflict detection does not decide which review is correct.

It flags the disagreement for further analysis.

---

# 10. Review Validation

Before a review is accepted, validate:

- participant identity exists;
- proposal identity exists;
- perspective is valid;
- conclusion is present;
- evidence references are structurally valid;
- objection references are structurally valid;
- status is valid.

Invalid reviews must be marked:

FAILED

or:

REQUIRES_REVISION

They must not silently enter consensus.

---

# 11. Provider Failure

Provider failures must remain distinguishable from review conclusions.

Examples:

TIMEOUT
UNAVAILABLE
RATE_LIMITED
AUTHENTICATION_ERROR
INVALID_RESPONSE
PROVIDER_ERROR

A provider failure must never be interpreted as:

APPROVE

REJECT

or:

CONSENSUS

---

# 12. Retry Policy

Retry behavior should be controlled by the orchestrator.

The Review Engine may expose retry metadata:

- retry_count
- last_error
- next_retry_at

Repeated failures should eventually become a review failure requiring owner/system attention.

---

# 13. Aggregation Boundary

The Review Engine produces structured reviews.

It does not determine final consensus.

Boundary:

Provider Adapter
      ↓
Review Engine
      ↓
CouncilReview
      ↓
Evidence / Objection
      ↓
Consensus Engine

---

# 14. Trading Boundary

Review Engine output is advisory.

It must not:

- send broker commands;
- place orders;
- modify positions;
- bypass Risk Engine;
- bypass authorization;
- bypass validation;
- bypass audit controls.

---

# 15. Security Boundary

The Review Engine must not store:

- API keys;
- passwords;
- broker credentials;
- private authentication tokens;
- private keys.

Sensitive provider configuration must remain outside Council review records.

---

# 16. Auditability

Every completed review should be traceable to:

- session_id
- proposal_id
- participant_id
- provider
- model
- perspective
- evidence
- objections
- timestamp

The system should preserve enough structured information to reproduce why the review reached its conclusion.

---

# 17. Review Result Classification

The Review Engine may normalize review outcomes into:

SUPPORT
SUPPORT_WITH_CONDITIONS
UNCERTAIN
OPPOSE
BLOCKED
FAILED

These classifications are review results.

They do not represent Project Owner decisions.

---

# 18. Safe Behavior

When evidence is insufficient:

UNCERTAIN

When mandatory information is missing:

REQUIRES_REVISION

When a critical security or governance issue exists:

BLOCKED

When provider execution fails:

FAILED

The engine must not invent a positive conclusion to complete the workflow.

---

# 19. Acceptance Criteria

Review Engine v0.1 is ready for implementation when:

1. Review input is defined.
2. Review output is defined.
3. Perspectives are defined.
4. Independent review rules are defined.
5. Required review questions are defined.
6. Evidence handling is defined.
7. Objection handling is defined.
8. Conflict detection is defined.
9. Review validation is defined.
10. Provider failure handling is defined.
11. Retry metadata is defined.
12. Aggregation boundary is defined.
13. Trading boundary is defined.
14. Security boundary is defined.
15. Auditability is defined.
16. Safe behavior is defined.
17. No unresolved contradiction exists with the Council Protocol, Model Specification, Orchestrator, or Provider Interface.

---

# 20. Initial Status

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Implementation: NOT STARTED

---

# END OF COUNCIL_REVIEW_ENGINE.md
