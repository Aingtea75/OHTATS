# OHTATS AI Council Decision & Repository Record

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/decisions/COUNCIL_DECISION_RECORD.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md
Consensus Engine: ai/council/consensus/COUNCIL_CONSENSUS_ENGINE.md
Orchestrator: ai/council/orchestrator/COUNCIL_ORCHESTRATOR.md

---

## 1. Purpose

The Decision Record defines how material OHTATS Council decisions are converted into traceable repository records.

The Council may recommend.

The Consensus Engine may calculate consensus.

The Project Owner makes the final decision.

The repository records the resulting canonical decision.

---

## 2. Decision Authority

Decision authority remains with:

PROJECT OWNER

Council participants do not automatically receive authority to:

- approve architecture;
- approve security changes;
- approve trading-risk changes;
- approve releases;
- modify governance;
- merge protected baseline changes.

---

## 3. Decision Types

Supported owner decisions:

- APPROVE
- APPROVE_WITH_CONDITIONS
- REQUEST_REVISION
- REJECT

The decision must reference the consensus result.

---

## 4. Decision Record Identity

Each material decision should have:

- decision_id
- proposal_id
- council_session_id
- owner
- date
- status
- title

Decision IDs should be unique and traceable.

---

## 5. Required Decision Record

A material decision record should contain:

Decision ID:

Proposal ID:

Council Session:

Title:

Date:

Owner:

Status:

Problem:

Context:

Proposal:

Options Considered:

Council Reviews:

Evidence:

Objections:

Consensus Result:

Owner Decision:

Reasoning:

Conditions:

Risks Accepted:

Risks Rejected:

Affected Documents:

Related ADR:

Related PR:

Related Commit:

Acceptance Criteria:

Validation Result:

---

## 6. Evidence Traceability

Evidence references should point to identifiable sources where practical.

Examples:

- repository path;
- commit;
- test;
- official documentation;
- experiment result;
- system log.

The decision record must distinguish:

FACT

INFERENCE

ASSUMPTION

UNKNOWN

---

## 7. Objection Traceability

If objections were raised, the decision record should preserve:

- objection;
- severity;
- evidence;
- resolution;
- owner decision.

Critical objections must not be silently removed from the historical record.

---

## 8. Consensus Traceability

The decision record must reference the consensus result:

- NOT_REACHED
- CONDITIONAL
- REACHED
- BLOCKED

A Project Owner may make a decision even when consensus is not reached.

If doing so, the decision record should explain why.

---

## 9. Conditions

For:

APPROVE_WITH_CONDITIONS

all material conditions must be explicitly recorded.

Each condition should identify:

- condition_id;
- requirement;
- responsible party;
- verification method;
- completion status.

An approval condition must not disappear after approval.

---

## 10. Repository Integration

Material decisions affecting the repository should produce an appropriate repository artifact.

Possible artifacts:

- blueprint change;
- ADR;
- implementation change;
- test;
- issue;
- PR;
- configuration change.

The decision record should reference resulting artifacts.

---

## 11. Git Traceability

Where implementation changes result from a Council decision, the record should reference:

- branch;
- commit;
- PR;
- merge result.

The Git repository remains the canonical implementation source.

---

## 12. Pull Request Boundary

The Council may recommend that a PR be:

- READY_FOR_REVIEW
- APPROVED
- REQUEST_REVISION
- REJECTED

However, repository permissions and GitHub branch protection remain authoritative.

The Council must not bypass repository governance.

---

## 13. No Automatic Merge

Consensus must never automatically imply:

- git push;
- git merge;
- PR approval;
- release.

Unless a separate explicitly authorized automation policy exists.

The default behavior is recommendation and owner-controlled execution.

---

## 14. Decision Reversal

A previous decision may be superseded when:

- new evidence appears;
- a critical defect is discovered;
- requirements change;
- architecture changes;
- security requirements change;
- Project Owner changes the decision.

A reversal must reference the previous decision.

Historical records must not be silently rewritten.

---

## 15. Decision States

Supported decision states:

- DRAFT
- REVIEW
- ACCEPTED
- CONDITIONAL
- REJECTED
- SUPERSEDED

A decision record should clearly identify its current state.

---

## 16. Acceptance Verification

For ACCEPTED or CONDITIONAL decisions, the system should track:

- acceptance criteria;
- validation evidence;
- responsible verification;
- verification status.

Possible verification states:

- PENDING
- PASSED
- FAILED
- PARTIAL

---

## 17. Audit Trail

Material decisions should preserve:

Proposal
  ->
Reviews
  ->
Evidence
  ->
Objections
  ->
Consensus
  ->
Owner Decision
  ->
Repository Artifact
  ->
Commit / PR

This provides reproducibility.

---

## 18. Security Boundary

Decision records must not contain:

- API keys;
- passwords;
- broker credentials;
- private authentication tokens;
- private keys.

Sensitive information must be referenced through secure identifiers rather than copied into the record.

---

## 19. Trading Boundary

Council decisions must not directly execute trading operations.

A trading-related decision remains subject to:

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
Connector
  ->
Broker / Platform

---

## 20. Repository Source of Truth

The final canonical decision exists only when the appropriate repository artifact has been recorded through the OHTATS governance process.

Conversation text alone is not a baseline.

AI memory alone is not a baseline.

Local notes alone are not a baseline.

---

## 21. Reproducibility

Another reviewer should be able to reconstruct a material decision from:

- decision record;
- referenced proposal;
- reviews;
- evidence;
- objections;
- consensus;
- affected repository state.

---

## 22. Decision Record Template

Decision ID:

Proposal ID:

Council Session:

Title:

Date:

Owner:

Status:

Problem:

Context:

Proposal:

Options Considered:

Council Reviews:

Evidence:

Objections:

Consensus Result:

Owner Decision:

Reasoning:

Conditions:

Risks Accepted:

Risks Rejected:

Affected Documents:

Related ADR:

Related PR:

Related Commit:

Acceptance Criteria:

Validation Result:

---

## 23. Acceptance Criteria

Decision & Repository Record v0.1 is ready for implementation when:

1. Owner authority is defined.
2. Decision types are defined.
3. Decision identity is defined.
4. Required decision record is defined.
5. Evidence traceability is defined.
6. Objection traceability is defined.
7. Consensus traceability is defined.
8. Conditions are defined.
9. Repository integration is defined.
10. Git traceability is defined.
11. Pull Request boundary is defined.
12. Automatic merge prohibition is defined.
13. Decision reversal is defined.
14. Decision states are defined.
15. Acceptance verification is defined.
16. Audit trail is defined.
17. Security boundary is defined.
18. Trading boundary is defined.
19. Repository source-of-truth rule is defined.
20. Reproducibility is defined.

---

## 24. Initial Status

Status: FOUNDATION / DEVELOPMENT

Version: 0.1

Implementation: NOT STARTED

---

# END OF COUNCIL_DECISION_RECORD.md
