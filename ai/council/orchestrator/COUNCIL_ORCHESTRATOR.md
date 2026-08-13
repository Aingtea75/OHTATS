# OHTATS AI Council Orchestrator

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/orchestrator/COUNCIL_ORCHESTRATOR.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md
Model Specification: ai/council/models/COUNCIL_MODELS.md

---

# 1. Purpose

The Council Orchestrator coordinates the lifecycle of an OHTATS AI Council proposal.

The orchestrator is responsible for workflow coordination.

It is NOT the final decision authority.

The Project Owner remains the final authority.

---

# 2. Canonical Lifecycle

The orchestrator follows:

DRAFT
  ↓
COUNCIL_REVIEW
  ↓
EVIDENCE_COLLECTION
  ↓
OBJECTION_ANALYSIS
  ↓
CONSENSUS_ANALYSIS
  ↓
OWNER_DECISION
  ↓
REPOSITORY_RECORD
  ↓
ACCEPTED / REJECTED

A proposal may return to REVISION when required.

---

# 3. Step 1 — Proposal Intake

Input:

CouncilProposal

The orchestrator validates that the proposal contains the minimum required information.

Required:

- problem
- context
- objective
- proposed solution
- risks
- acceptance criteria
- repository impact

If mandatory information is missing:

status = REVISION

The orchestrator must not silently invent missing requirements.

---

# 4. Step 2 — Participant Assignment

The orchestrator determines which Council participants should review the proposal.

Minimum perspectives for important proposals:

DESIGN
ENGINEERING
RISK

Additional perspectives may include:

SECURITY
OPERATIONS
COMPLIANCE

Provider selection must remain independent from governance authority.

---

# 5. Step 3 — Independent Review

Each assigned participant produces an independent CouncilReview.

A participant must identify:

- correct elements
- uncertain elements
- incorrect elements
- missing elements
- risks
- evidence
- alternatives
- recommendation

Participants must not simply copy another participant's conclusion.

---

# 6. Step 4 — Evidence Collection

The orchestrator collects referenced CouncilEvidence.

Preferred evidence:

- repository files
- source code
- tests
- Git history
- official documentation
- reproducible experiments
- system logs
- measured behavior

Evidence should be traceable.

Unsupported claims should be marked as:

ASSUMPTION

or

UNKNOWN

---

# 7. Step 5 — Objection Analysis

Reviews are analyzed for objections.

Each objection receives:

severity
category
description
evidence
status

Severity:

INFO
MINOR
MAJOR
CRITICAL

A credible CRITICAL objection may block acceptance.

The orchestrator must not suppress an objection merely because another participant disagrees with it.

---

# 8. Step 6 — Consensus Analysis

The orchestrator aggregates the independent reviews.

Possible results:

NOT_REACHED
CONDITIONAL
REACHED
BLOCKED

Consensus is considered reached only when no unresolved critical objection remains.

Consensus does not mean unanimous preference.

---

# 9. Step 7 — Project Owner Decision

The orchestrator presents:

- proposal
- reviews
- evidence
- objections
- consensus result
- unresolved disagreements
- recommended action

The Project Owner makes the final decision.

Possible decisions:

APPROVE
APPROVE_WITH_CONDITIONS
REQUEST_REVISION
REJECT

The orchestrator must not automatically convert consensus into approval.

---

# 10. Step 8 — Repository Record

When the Project Owner makes a material decision, the orchestrator prepares a repository record.

The record should reference:

- decision ID
- proposal ID
- affected documents
- ADR
- PR
- commit

The repository becomes the canonical project record.

---

# 11. Trading Boundary

The orchestrator must never directly execute trading commands.

Council output is advisory.

Any future execution path must remain:

AI / Council
   ↓
Policy
   ↓
Authorization
   ↓
Validation
   ↓
Risk Engine
   ↓
Trading Engine
   ↓
Connector
   ↓
Broker / Platform

---

# 12. Security Boundary

The orchestrator must not:

- expose secrets
- store API keys in documents
- bypass authorization
- bypass validation
- bypass risk controls
- bypass audit logging
- directly access broker credentials

---

# 13. Provider Independence

The orchestrator must operate against an abstract participant interface.

It must not contain provider-specific business logic such as:

OpenAI-only decision rules
Claude-only decision rules
Grok-only decision rules

Provider adapters belong under:

ai/council/providers/

---

# 14. Failure Handling

The orchestrator must explicitly handle:

- participant unavailable
- provider timeout
- malformed review
- missing evidence
- conflicting reviews
- critical objection
- consensus failure
- repository write failure

A provider failure must not automatically become:

APPROVE

The safe default is:

REVIEW_REQUIRED

---

# 15. Auditability

Every material orchestration step should be traceable.

Recommended event sequence:

PROPOSAL_CREATED
REVIEW_STARTED
REVIEW_RECEIVED
EVIDENCE_RECORDED
OBJECTION_RAISED
CONSENSUS_CALCULATED
OWNER_DECISION_RECORDED
REPOSITORY_RECORD_CREATED

The system does not need to store every conversational message.

It must preserve enough information to reproduce the decision.

---

# 16. Initial Implementation Boundary

Version 0.1 is specification-only.

It does not yet:

- call OpenAI
- call Claude
- call Grok
- execute trading
- modify broker accounts
- automatically approve repository changes

Those capabilities require separate implementation and security review.

---

# 17. Acceptance Criteria

Orchestrator v0.1 is ready for implementation when:

1. Proposal lifecycle is defined.
2. Participant assignment is defined.
3. Independent review is defined.
4. Evidence handling is defined.
5. Objection handling is defined.
6. Consensus calculation is defined.
7. Project Owner decision boundary is defined.
8. Repository recording is defined.
9. Trading boundary is defined.
10. Security boundary is defined.
11. Provider independence is preserved.
12. Failure handling is defined.
13. Auditability is defined.
14. No unresolved contradiction exists with A_COUNCIL_PROTOCOL.md.

---

# 18. Initial Status

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Implementation: NOT STARTED

---

# END OF COUNCIL_ORCHESTRATOR.md
