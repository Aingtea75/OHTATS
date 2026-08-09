# OHTATS — AI Architecture Blueprint

# Status

**AI ARCHITECTURE BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principle

AI adalah capability provider, bukan privileged execution channel.

AI layer harus:

- provider-agnostic;
- model-agnostic;
- policy-aware;
- auditable;
- replaceable;
- observable;
- secure terhadap prompt/input/output;
- terisolasi dari broker execution.

# 2. Boundary

```text
Application / Workflow
        ↓
AI Manager
        ↓
AI Policy / Capability
        ↓
Provider Abstraction
        ↓
Provider Adapter
        ↓
External / Local Model
```

# 3. AI Lifecycle

```text
Request
 ↓
Context Assembly
 ↓
Policy Check
 ↓
Provider Selection
 ↓
Model Invocation
 ↓
Response Normalization
 ↓
Analysis / Structured Decision
 ↓
Validation
 ↓
Risk / Trading Pipeline if executable
```

# 4. Context

Context harus memiliki scope dan source yang dapat ditelusuri. Sensitive data harus disanitasi atau diberikan hanya bila authorized.

# 5. Structured Output

AI output yang akan dipakai sistem harus melalui schema validation. Natural-language output tidak dianggap executable command.

# 6. Decision Boundary

```text
AI Decision
   ↓
Policy
   ↓
Strategy Validation
   ↓
Risk Manager
   ↓
Trading Engine
```

AI tidak boleh memanggil broker connector secara langsung.

# 7. Session / Usage

AI sessions, requests, responses, analyses, decisions, prompts, versions, dan usage mengikuti canonical entities pada database blueprint.

# 8. Provider Failure

Provider timeout, rate limit, malformed output, unavailable model, dan quota failure mengikuti `ERROR_HANDLING.md`.

Provider failure tidak boleh mengubah trading state tanpa explicit domain handling.

# 9. Security

Prompt injection, data exfiltration, secret leakage, unsafe tool invocation, dan unauthorized capability harus ditangani sebagai security concerns.

Tool/MCP access harus capability-scoped dan tidak bypass authorization/risk/audit.

# 10. Acceptance Criteria

- provider abstraction jelas;
- structured output validation;
- AI decision tidak bypass controls;
- sensitive context protected;
- usage/audit traceable;
- failure behavior defined;
- consistent dengan `MODULE_SPECIFICATION.md`, `DATA_FLOW.md`, `AI_PROVIDER.md`, dan `DATABASE_DESIGN.md`.

# END OF AI_ARCHITECTURE.md
