# OHTATS AI Council Model Specification

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/models/COUNCIL_MODELS.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md

---

# 1. Purpose

This document defines the canonical logical model for the OHTATS AI Council.

The model is provider-agnostic.

It must not depend on OpenAI, Claude, Grok, Gemini, or any other specific AI provider.

The model represents Council governance and review state, not trading execution state.

---

# 2. Entity Overview

The initial Council model contains:

1. CouncilSession
2. CouncilProposal
3. CouncilParticipant
4. CouncilReview
5. CouncilEvidence
6. CouncilObjection
7. CouncilConsensus
8. CouncilDecision

---

# 3. CouncilSession

Represents one Council working session.

Fields:

- session_id
- title
- status
- created_at
- updated_at
- owner_id

Status lifecycle:

DRAFT
REVIEW
DECISION
ACCEPTED
REJECTED
CLOSED

Relationships:

CouncilSession
  -> many CouncilProposal
  -> many CouncilReview
  -> many CouncilDecision

---

# 4. CouncilProposal

Represents a proposal submitted to the Council.

Fields:

- proposal_id
- session_id
- title
- problem
- context
- objective
- proposed_solution
- alternatives
- advantages
- disadvantages
- dependencies
- risks
- security_implications
- compatibility_implications
- testing_requirements
- acceptance_criteria
- repository_impact
- status
- created_at
- updated_at

Status lifecycle:

DRAFT
COUNCIL_REVIEW
REVISION
READY_FOR_DECISION
ACCEPTED
REJECTED

A proposal must not become a canonical project decision merely because an AI generated it.

---

# 5. CouncilParticipant

Represents a participant in a Council session.

Fields:

- participant_id
- session_id
- provider
- model
- role
- status
- joined_at

Example providers:

- openai
- anthropic
- xai
- google
- deepseek
- openrouter
- ollama
- lmstudio
- custom

The provider field identifies the provider.

The model field identifies the model used.

No provider is inherently authoritative.

---

# 6. CouncilReview

Represents one independent participant review of a proposal.

Fields:

- review_id
- proposal_id
- participant_id
- perspective
- conclusion
- findings
- assumptions
- risks
- recommendations
- evidence_ids
- objection_ids
- created_at

Recommended perspectives:

DESIGN
ENGINEERING
RISK
SECURITY
OPERATIONS
COMPLIANCE

Not every proposal requires every perspective.

Important proposals should normally include Design, Engineering, and Risk.

---

# 7. CouncilEvidence

Represents evidence supporting a Council finding.

Fields:

- evidence_id
- proposal_id
- source_type
- source_reference
- description
- classification
- collected_at

Source types may include:

REPOSITORY_FILE
SOURCE_CODE
TEST
GIT_HISTORY
OFFICIAL_DOCUMENTATION
EXPERIMENT
SYSTEM_LOG
MEASURED_BEHAVIOR
EXTERNAL_SOURCE

Classification:

FACT
INFERENCE
ASSUMPTION
UNKNOWN

Evidence must be traceable whenever practical.

---

# 8. CouncilObjection

Represents a disagreement or blocking concern.

Fields:

- objection_id
- proposal_id
- review_id
- severity
- category
- description
- evidence_ids
- status
- resolution
- created_at
- resolved_at

Severity:

INFO
MINOR
MAJOR
CRITICAL

Categories may include:

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

A CRITICAL objection may block acceptance.

---

# 9. CouncilConsensus

Represents the Council's aggregate review result.

Fields:

- consensus_id
- proposal_id
- status
- unresolved_objection_count
- critical_objection_count
- summary
- conditions
- generated_at

Status:

NOT_REACHED
CONDITIONAL
REACHED
BLOCKED

Consensus must not override Project Owner authority.

---

# 10. CouncilDecision

Represents the final decision by the Project Owner.

Fields:

- decision_id
- proposal_id
- consensus_id
- decision
- decision_reason
- owner_id
- acceptance_criteria
- affected_documents
- related_adr
- related_pr
- related_commit
- decided_at

Decision values:

APPROVE
APPROVE_WITH_CONDITIONS
REQUEST_REVISION
REJECT

The Project Owner is the final authority.

---

# 11. Evidence Rule

Council participants must distinguish:

FACT
INFERENCE
ASSUMPTION
RECOMMENDATION
UNKNOWN

An assumption must not be presented as a verified fact.

---

# 12. Trading Boundary

Council models must not directly execute trading operations.

The Council may recommend changes.

Execution remains outside the Council model boundary and must pass:

Policy
  ->
Authorization
  ->
Validation
  ->
Risk Engine
  ->
Trading Engine
  ->
Connector / Adapter
  ->
Broker / Platform

---

# 13. Security Boundary

Council models must never store:

- passwords
- API secrets
- broker credentials
- authentication tokens
- private keys

Sensitive credentials belong in the appropriate secure configuration mechanism.

---

# 14. Repository Traceability

Material Council decisions should reference repository artifacts where applicable:

- affected documents
- ADR
- PR
- commit

The repository remains the canonical source of truth.

---

# 15. Initial Status

Status: FOUNDATION / DEVELOPMENT

This specification is an implementation foundation.

It is not yet an APPROVED governance baseline.

---

# END OF COUNCIL_MODELS.md
