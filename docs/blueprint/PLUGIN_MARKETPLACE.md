# OHTATS — Plugin Marketplace Blueprint

# Status

**PLUGIN MARKETPLACE BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Objective

Marketplace menyediakan katalog dan distribution capability untuk plugin/extension tanpa menjadi owner trading history atau broker state.

# 2. Catalog

Marketplace metadata dapat mencakup:

- plugin identity;
- publisher;
- versions;
- category;
- compatibility;
- capabilities;
- permissions;
- dependencies;
- documentation;
- artifact checksum;
- publication status.

# 3. Publication Lifecycle

```text
Submit
  ↓
Validate
  ↓
Security / Compatibility Review
  ↓
Publish
  ↓
Entitle / Distribute
  ↓
Install
  ↓
Update / Deprecate
```

# 4. Entitlement

Marketplace access dapat terhubung dengan licensing/entitlement, tetapi entitlement tidak menjadi owner dari historical trading state.

# 5. Trust

Published artifact harus dapat diverifikasi checksum/signature sesuai security implementation.

Publisher identity harus dapat ditelusuri.

# 6. Compatibility

Marketplace harus memeriksa:

- OHTATS version;
- plugin API version;
- platform capability;
- dependencies;
- permission requirements.

# 7. Security

Marketplace tidak boleh menjadi jalur bypass plugin capability/security/risk/trading.

# 8. Acceptance Criteria

- catalog model defined;
- publication lifecycle defined;
- artifact integrity defined;
- compatibility defined;
- entitlement boundary defined;
- publisher traceability defined;
- consistent dengan `PLUGIN_SYSTEM.md`, `LICENSE_SYSTEM.md`, `SECURITY.md`, dan `DATABASE_DESIGN.md`.

# END OF PLUGIN_MARKETPLACE.md
