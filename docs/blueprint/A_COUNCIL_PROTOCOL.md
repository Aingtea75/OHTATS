OHTATS AI Council Protocol

Status: REVIEW
Version: 1.0
Canonical Path: docs/blueprint/A_COUNCIL_PROTOCOL.md
Parent Governance: PROJECT_CONSTITUTION.md
Source of Truth: OHTATS Git Repository

1. Purpose

A Council Protocol defines the operating rules for collaboration between the OHTATS project owner and participating AI systems.

The protocol exists to ensure that AI-assisted decisions are:

structured;

evidence-based;

auditable;

reproducible;

reviewable;

traceable to repository changes;

consistent with the OHTATS Project Constitution;

independent of any single AI provider.

The Council is a decision-support and engineering governance mechanism. It does not replace the Project Constitution, repository governance, human ownership, security controls, risk controls, or technical validation.

2. Governance Hierarchy

The Council operates under the following hierarchy:

OHTATS Project Constitution
        ↓
Architecture Decisions / ADRs
        ↓
A Council Protocol
        ↓
Council Decisions
        ↓
Blueprints / Specifications
        ↓
Implementation
        ↓
Testing / Validation
        ↓
Release

In case of conflict, a lower-level Council decision must not override a higher-level approved governance document.

3. Source of Truth

The canonical source of truth is the Git repository:

Aingtea75/OHTATS

Chat conversations, local notes, AI sessions, temporary drafts, and private reasoning are not project baselines until the resulting decision is recorded in the repository through the appropriate Git workflow.

The Council must therefore distinguish between:

Discussion
    ↓
Proposal
    ↓
Review
    ↓
Decision
    ↓
Repository Record

4. Council Participants

The initial Council may include:

RoleResponsibility



Project Owner

Final authority and project direction

ChatGPT

Architecture, reasoning, documentation, audit

Claude

Independent analysis, review, architecture critique

Grok

Independent analysis, alternative approaches, challenge

Future AI Provider

Must follow this protocol after acceptance

AI participants are advisors and reviewers unless explicitly granted another capability by the Project Owner.

5. Project Owner Authority

The Project Owner retains final authority over:

project direction;

product scope;

acceptance of major architectural decisions;

security-sensitive decisions;

trading-risk decisions;

release decisions;

repository governance;

AI Council membership;

dispute resolution when Council consensus cannot be reached.

AI consensus does not override the Project Owner.

However, the Project Owner should record the rationale when intentionally accepting a recommendation that materially conflicts with a Council majority or technical review.

6. AI Independence

Participating AI systems should provide independent analysis.

An AI participant should not simply agree with another participant without performing its own evaluation.

When reviewing a proposal, each participant should identify:

what is correct;

what is uncertain;

what is incorrect;

what is missing;

what risks exist;

what evidence supports the conclusion;

what alternative solution may be preferable.

Agreement without analysis does not constitute meaningful Council review.

7. Proposal Lifecycle

Council proposals follow this lifecycle:

DRAFT
  ↓
COUNCIL REVIEW
  ↓
CONFLICT / REVISION
  ↓
CONSENSUS OR OWNER DECISION
  ↓
ACCEPTANCE
  ↓
REPOSITORY RECORD
  ↓
APPROVED / LOCKED

A proposal must not be considered an OHTATS baseline merely because an AI generated it.

8. Proposal Requirements

A material proposal should contain:

Problem;

Context;

Objective;

Proposed solution;

Alternatives considered;

Advantages;

Disadvantages;

Dependencies;

Risks;

Security implications;

Compatibility implications;

Testing requirements;

Acceptance criteria;

Repository impact.

For major architectural changes, an ADR should be considered.

9. Evidence Standard

Council conclusions should distinguish between:

FACT
INFERENCE
ASSUMPTION
RECOMMENDATION
UNKNOWN

AI participants must not present assumptions as verified facts.

Where practical, evidence should come from:

repository files;

source code;

tests;

Git history;

official technical documentation;

reproducible experiments;

system logs;

measured behavior.

10. Review Method

For important proposals, the Council should use at least three perspectives where available:

Perspective A — Design

Does the proposal fit the OHTATS architecture and long-term vision?

Perspective B — Engineering

Can the proposal actually be implemented, tested, maintained, and reproduced?

Perspective C — Risk

Could the proposal introduce security, trading, financial, operational, compliance, or governance problems?

Additional perspectives may be added when appropriate.

11. Consensus

Council consensus means that no participating reviewer has identified an unresolved critical objection.

Consensus does not necessarily mean that every participant prefers the same implementation.

A proposal may proceed when:

critical objections are resolved;

remaining disagreements are documented;

acceptance criteria are defined;

the Project Owner accepts the final decision.

12. Conflict Resolution

When AI participants disagree:

Each participant states its position.

Each participant identifies supporting evidence.

Each participant identifies assumptions.

Each participant identifies the strongest argument against its own position.

The alternatives are compared.

Additional evidence or testing is requested when necessary.

The disagreement is documented.

The Project Owner makes the final decision if consensus cannot be achieved.

The Council must not resolve technical disagreements merely by majority vote when the issue can be tested objectively.

13. Voting

Voting may be used as a decision-support mechanism but is not a substitute for technical evidence.

Recommended notation:

APPROVE
APPROVE WITH CONDITIONS
REVIEW REQUIRED
REJECT
ABSTAIN

A single well-supported critical objection may require additional investigation even when the majority supports a proposal.

14. Critical Objections

A critical objection may block acceptance when it identifies a credible issue involving:

security;

unauthorized access;

loss of data;

corruption of canonical project state;

bypass of authorization;

bypass of risk controls;

unsafe trading behavior;

architectural incompatibility;

irreversible destructive behavior;

violation of the Project Constitution;

inability to satisfy mandatory acceptance criteria.

The objection must include evidence or a clearly testable technical argument.

15. AI Trading Boundary

AI systems must not directly bypass OHTATS controls to execute trading operations.

The intended control boundary is:

AI Analysis
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
Connector / Adapter
    ↓
Broker / Platform

AI recommendations must not directly circumvent:

authorization;

policy;

validation;

risk management;

trading controls;

audit logging.

16. Security Boundary

Council participants must not introduce mechanisms that intentionally bypass OHTATS security controls.

Secrets, credentials, API keys, broker credentials, or personal authentication material must not be committed to the repository.

Security-sensitive proposals require explicit review before acceptance.

17. Repository Integration

The Council should work against the canonical repository rather than maintaining independent document copies.

Recommended workflow:

Council Proposal
      ↓
Work Branch
      ↓
Document / Code Changes
      ↓
Commit
      ↓
Pull Request
      ↓
Review
      ↓
Acceptance
      ↓
master

The default branch is currently:

master

18. Local Synchronization

The local OHTATS workspace is:

C:\Users\hend\OHTATS

GitHub remains the canonical source.

After accepted changes are merged into the canonical branch, the local workspace is synchronized with:

cd C:\Users\hend\OHTATS
powershell -ExecutionPolicy Bypass -File .\scripts\git\sync-ohtats.ps1

The synchronization process must retrieve repository changes rather than relying on manual file copying.

19. Cursor Integration

Cursor should operate on:

C:\Users\hend\OHTATS

When the local workspace is synchronized through Git, newly accepted repository documents become available to Cursor automatically because they exist in the local working tree.

Cursor is therefore a development interface, not a separate source of truth.

20. Document Governance

Council-created documents must follow the governance lifecycle defined by the Project Constitution:

DRAFT
  ↓
REVIEW
  ↓
APPROVED
  ↓
LOCKED
  ↓
DEPRECATED

Creation of a file does not automatically make it an approved baseline.

A document may only become LOCKED after review and acceptance criteria have been satisfied.

21. Change Control

Changes to an APPROVED or LOCKED document require:

reason for change;

impact assessment;

Council or appropriate technical review;

updated acceptance criteria where necessary;

repository commit;

PR review when appropriate;

preservation of historical rationale.

22. Audit Trail

Material Council decisions should be traceable to repository history.

Where applicable, the audit trail should identify:

proposal;

participants;

major arguments;

evidence;

decision;

decision owner;

affected documents;

related ADR;

related PR;

resulting commit.

The purpose is reproducibility rather than recording every conversational message.

23. Decision Record

Major Council decisions should use a structured record:

Decision ID:
Title:
Date:
Status:
Owner:
Participants:

Problem:
Context:

Options:
1.
2.
3.

Decision:

Reasoning:

Evidence:

Risks:

Affected Documents:

Acceptance Criteria:

Related ADR:
Related PR:
Related Commit:

24. No Hidden Baseline

An AI participant must not claim that a decision is part of OHTATS merely because it was discussed during a conversation.

The decision becomes canonical only after it is recorded in the repository through the appropriate governance process.

25. Reproducibility

A Council decision should be reproducible by another reviewer using the repository state and referenced evidence.

Where a decision depends on an experiment, the experiment should be reproducible where practical.

Where a conclusion depends on external information, the relevant source should be recorded when appropriate.

26. Council Memory

The Council should prefer repository records over conversational memory.

Important project decisions must be written into canonical documentation, ADRs, issue records, or other appropriate repository artifacts.

This prevents loss of project knowledge when:

an AI provider changes;

a conversation ends;

a participant changes;

a new developer joins;

the project is resumed after a long period.

27. AI Provider Agnosticism

The Council must not depend on one AI vendor.

OHTATS should remain capable of incorporating:

OpenAI;

Claude;

Gemini;

Grok;

DeepSeek;

OpenRouter;

Ollama;

LM Studio;

custom AI APIs;

provided that the integration complies with the OHTATS architecture and security boundaries.

28. Council Expansion

New AI participants may be added when they can operate within:

Project Constitution;

A Council Protocol;

security requirements;

repository governance;

evidence standards;

audit requirements.

Adding an AI participant does not automatically grant repository write privileges.

29. Acceptance Criteria for v1.0

A Council Protocol v1.0 may be considered ready for APPROVED review when:

Governance hierarchy is compatible with PROJECT_CONSTITUTION.md.

Project Owner authority is explicitly defined.

AI participant responsibilities are defined.

Proposal lifecycle is defined.

Evidence standards are defined.

Conflict resolution is defined.

Critical objection handling is defined.

Trading/security boundaries are defined.

Git/PR integration is defined.

Local synchronization workflow is defined.

Audit requirements are defined.

Decision records are defined.

AI provider agnosticism is preserved.

No contradiction with canonical OHTATS blueprint documents remains unresolved.

30. Initial Status

Status: REVIEW
Version: 1.0
Review Required: YES
Lock Status: NOT LOCKED
Canonical Repository: Aingtea75/OHTATS

This document must not be treated as an approved OHTATS baseline until the defined review and acceptance process has been completed.

END OF A_COUNCIL_PROTOCOL.md