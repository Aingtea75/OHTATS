# OHTATS AI Council Provider Interface

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Canonical Path: ai/council/providers/COUNCIL_PROVIDER_INTERFACE.md
Parent Governance: docs/blueprint/A_COUNCIL_PROTOCOL.md
Orchestrator: ai/council/orchestrator/COUNCIL_ORCHESTRATOR.md

---

# 1. Purpose

This document defines the provider abstraction boundary for the OHTATS AI Council.

The Council must be able to work with multiple AI providers without making any provider the canonical authority.

---

# 2. Provider Boundary

The canonical architecture is:

Council Orchestrator
        |
        v
Council Provider Interface
        |
        +----------------+
        |                |
        v                v
Provider Adapter    Provider Adapter
        |                |
     OpenAI           Claude
        |
        +----------------+
                 |
                 v
              Grok

Additional providers may be added later.

---

# 3. Provider Identity

Each provider participant should expose:

- provider_id
- provider_name
- model_id
- adapter_version
- capability_set
- availability
- configuration_reference

Provider identity is metadata.

Provider identity does not determine decision authority.

---

# 4. Required Provider Capability

A Council provider adapter should support the conceptual operation:

REVIEW_PROPOSAL

Input:

- CouncilProposal
- CouncilSession context
- assigned perspective
- relevant evidence
- review instructions

Output:

CouncilReview

The adapter must not directly produce a final Project Owner decision.

---

# 5. Optional Capabilities

A provider may additionally support:

- ANALYZE
- REVIEW
- CHALLENGE
- SUMMARIZE
- EVIDENCE_ANALYSIS
- OBJECTION_ANALYSIS

Capabilities must be explicitly declared.

A provider must not receive capabilities that were not granted by the Council architecture.

---

# 6. Provider Adapter Boundary

Provider-specific implementation belongs under provider adapters.

Conceptual structure:

ai/council/providers/
    interface
    openai
    anthropic
    xai
    future

Provider-specific SDK calls must remain inside the corresponding adapter.

The orchestrator must not contain provider-specific SDK logic.

---

# 7. Provider Request

A provider request should contain:

- request_id
- session_id
- proposal_id
- participant_id
- perspective
- prompt
- evidence_references
- requested_capabilities
- created_at

Secrets must never be included directly in the request model.

---

# 8. Provider Response

A provider response should contain:

- request_id
- provider_id
- model_id
- review_id
- status
- review
- evidence_references
- warnings
- latency
- received_at

Possible status:

SUCCESS
PARTIAL
TIMEOUT
ERROR
REJECTED

A provider failure must not be interpreted as approval.

---

# 9. Independence

Provider adapters must receive sufficient proposal context to perform independent analysis.

A provider should not be given another provider's conclusion before producing its own independent review unless the workflow explicitly enters a critique stage.

Recommended sequence:

Proposal
   |
   +----> OpenAI independent review
   |
   +----> Claude independent review
   |
   +----> Grok independent review
   |
   v
Review aggregation
   |
   v
Conflict / objection analysis
   |
   v
Consensus analysis

---

# 10. Provider Failure

If one provider is unavailable:

The Council may continue only when the required review policy permits continuation.

The system must record:

- unavailable provider
- failure reason
- affected perspective
- timestamp
- retry status

The system must never silently replace:

TIMEOUT

with:

APPROVE

---

# 11. Security Boundary

Provider adapters must not expose:

- API keys
- passwords
- broker credentials
- private authentication material
- secrets

Secrets must be resolved through the approved secure configuration mechanism.

Provider credentials must not be stored in Council proposal or review documents.

---

# 12. Trading Boundary

Provider adapters must not directly execute trading operations.

They only provide analysis/review capabilities to the Council.

Any trading action must remain outside the provider boundary and pass the canonical OHTATS controls.

---

# 13. Provider Agnosticism

The architecture must support:

- OpenAI
- Anthropic / Claude
- xAI / Grok
- Google / Gemini
- DeepSeek
- OpenRouter
- Ollama
- LM Studio
- custom providers

Adding a provider must not require changing the Council governance model.

---

# 14. Configuration

Provider configuration should be referenced through configuration identifiers.

Example conceptual references:

provider.openai
provider.anthropic
provider.xai

The actual credentials must remain outside source-controlled Council documents.

---

# 15. Observability

Provider calls should expose measurable operational metadata where practical:

- request_id
- provider
- model
- latency
- status
- retry_count
- error_category
- timestamp

This supports auditability and troubleshooting.

---

# 16. Auditability

Material provider interactions should be traceable to:

- Council session
- proposal
- participant
- review
- evidence
- decision

The system does not need to preserve every raw provider conversation indefinitely.

It must preserve sufficient information to reproduce the Council decision.

---

# 17. No Provider Authority

No provider may:

- approve itself;
- override another provider through privilege;
- override Project Owner authority;
- bypass Council policy;
- bypass authorization;
- bypass validation;
- bypass risk controls;
- bypass audit requirements.

---

# 18. Implementation Boundary

Version 0.1 is interface specification only.

It does not yet:

- connect to OpenAI API;
- connect to Claude API;
- connect to Grok API;
- store provider credentials;
- automatically execute Council decisions.

Those belong to later implementation stages.

---

# 19. Acceptance Criteria

Provider Interface v0.1 is ready for implementation when:

1. Provider abstraction is defined.
2. Provider identity is defined.
3. Provider capabilities are defined.
4. Request model is defined.
5. Response model is defined.
6. Provider failure behavior is defined.
7. Independence rules are defined.
8. Security boundary is defined.
9. Trading boundary is defined.
10. Configuration boundary is defined.
11. Auditability is defined.
12. Multiple providers can be added without changing Council governance.
13. No unresolved contradiction exists with the Council Protocol or Orchestrator specification.

---

# 20. Initial Status

Status: FOUNDATION / DEVELOPMENT
Version: 0.1
Implementation: NOT STARTED

---

# END OF COUNCIL_PROVIDER_INTERFACE.md
