# OHTATS — AI Provider Blueprint

# Status

**AI PROVIDER BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Provider Contract

Semua provider harus diakses melalui canonical interface.

```text
AI Manager
   ↓
Provider Interface
   ├── chat / completion
   ├── structured output
   ├── embeddings (optional)
   ├── tool capability (optional)
   └── usage metadata
```

# 2. Provider Registry

Provider registry menyimpan metadata, capability, status, model mapping, rate limits, dan configuration references.

Credential disimpan melalui secure secret reference, bukan plaintext.

# 3. Target Providers

OHTATS dapat mendukung:

- OpenAI;
- Google Gemini;
- Anthropic Claude;
- xAI Grok;
- DeepSeek;
- OpenRouter;
- Ollama;
- LM Studio;
- custom provider/API.

Daftar ini bukan dependency wajib.

# 4. Model Registry

Model identity harus dipisahkan dari provider identity. Provider-specific model name dapat dipetakan ke canonical capability/metadata.

# 5. Provider Selection

Selection dapat mempertimbangkan:

- capability;
- model availability;
- user configuration;
- entitlement;
- cost policy;
- latency;
- rate limit;
- availability;
- privacy/deployment policy.

# 6. Usage / Cost

Setiap invocation yang relevan harus dapat menghasilkan usage metadata seperti token, latency, provider, model, request status, dan estimated cost.

Estimated cost bukan accounting truth tanpa pricing snapshot yang sesuai.

# 7. Failure / Fallback

Fallback provider hanya boleh dilakukan bila policy mengizinkan. Fallback tidak boleh mengubah semantic contract secara diam-diam.

# 8. Secret Boundary

API key/token hanya tersedia saat runtime melalui secure secret mechanism.

Tidak boleh masuk log, audit payload, queue payload, prompt history tanpa sanitization, atau client response.

# 9. Acceptance Criteria

- provider interface versioned;
- model registry defined;
- credential isolation;
- capability discovery;
- usage tracking;
- rate-limit/error mapping;
- fallback policy;
- consistent dengan `AI_ARCHITECTURE.md` dan database AI entities.

# END OF AI_PROVIDER.md
