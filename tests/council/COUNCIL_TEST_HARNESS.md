# OHTATS AI Council Test Harness

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: tests/council/COUNCIL_TEST_HARNESS.md

---

## Purpose

This directory validates the basic Council lifecycle before real AI providers are connected.

The initial test is provider-independent and uses deterministic fixture data.

Lifecycle:

Proposal
  ->
Independent Reviews
  ->
Consensus
  ->
Owner Decision
  ->
Decision Record

---

## Test Objectives

The harness must verify:

1. proposal input exists;
2. multiple independent reviews can be represented;
3. evidence is preserved;
4. objections are preserved;
5. consensus can be calculated;
6. critical objections can block consensus;
7. owner decision remains separate from AI consensus;
8. decision information can be recorded;
9. provider identity does not automatically determine authority.

---

## Test Case 001

Scenario:

Three AI reviewers independently review a documentation proposal.

ChatGPT:
APPROVE

Claude:
APPROVE_WITH_CONDITIONS

Grok:
APPROVE

No critical objection exists.

Expected consensus:

CONDITIONAL

Expected owner decision:

APPROVE_WITH_CONDITIONS

Reason:

Claude identified a non-critical condition that must be recorded.

---

## Test Case 002

Scenario:

Three AI reviewers review an architecture proposal.

ChatGPT:
APPROVE

Claude:
APPROVE

Grok:
REVIEW_REQUIRED

Grok identifies a credible security concern.

Expected consensus:

NOT_REACHED

Expected owner decision:

REQUEST_REVISION

---

## Test Case 003

Scenario:

Three AI reviewers review a trading-related proposal.

ChatGPT:
APPROVE

Claude:
APPROVE

Grok:
APPROVE

A separate risk review identifies an unresolved critical risk-control bypass.

Expected consensus:

BLOCKED

Expected owner decision:

REQUEST_REVISION

The majority vote must not override the critical objection.

---

## Test Case 004

Scenario:

One mandatory provider review fails to return.

ChatGPT:
APPROVE

Claude:
PROVIDER_FAILURE

Grok:
APPROVE

Expected consensus:

NOT_REACHED

The system must not automatically assume that the missing review is an approval.

---

## Test Case 005

Scenario:

All required reviews are complete.

No critical objections exist.

All mandatory acceptance criteria are satisfied.

Expected consensus:

REACHED

Expected owner decision:

APPROVE

---

## Safety Rules

The harness must verify:

- consensus does not equal owner approval;
- voting does not override critical objections;
- missing evidence does not become FACT;
- provider failure does not become approval;
- trading decisions do not bypass Risk Engine;
- security controls cannot be bypassed;
- repository history remains authoritative.

---

## Initial Status

Implementation:

NOT STARTED

Tests:

DESIGN ONLY

---

# END OF COUNCIL_TEST_HARNESS.md
