# OHTATS — Plugin System Blueprint

# Status

**PLUGIN SYSTEM BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Objective

Plugin system memungkinkan capability tambahan tanpa mengubah core secara tidak perlu.

# 2. Plugin Lifecycle

```text
Discover
  ↓
Validate Manifest
  ↓
Security / Compatibility Check
  ↓
Install
  ↓
Configure
  ↓
Activate
  ↓
Run
  ↓
Deactivate / Upgrade / Remove
```

# 3. Plugin Manifest

Minimum metadata:

- plugin ID;
- version;
- publisher;
- description;
- required platform version;
- dependencies;
- capabilities;
- permissions;
- configuration schema;
- artifact checksum.

# 4. Capability Model

Plugin hanya memperoleh capability yang explicitly granted.

Contoh capability:

- read market data;
- strategy extension;
- indicator;
- reporting;
- notification;
- workflow action;
- connector extension.

Capability tidak otomatis memberi broker execution privilege.

# 5. Security

Plugin adalah untrusted/less-trusted extension boundary.

Harus ada:

- permission enforcement;
- artifact verification;
- dependency validation;
- configuration validation;
- audit trail;
- isolation/sandbox sesuai runtime capability.

# 6. Trading Rule

Plugin yang menghasilkan trading intent harus mengirim `Trading Request` ke normal risk/trading pipeline. Plugin tidak boleh memanggil broker connector secara langsung.

# 7. Versioning

Plugin version immutable setelah publication. Upgrade menghasilkan installation/version transition yang dapat diaudit.

# 8. Acceptance Criteria

- lifecycle defined;
- manifest defined;
- capability/permission defined;
- compatibility defined;
- security boundary defined;
- trading bypass prohibited;
- auditability defined;
- consistent dengan `MODULE_SPECIFICATION.md`, `DATABASE_DESIGN.md`, dan `DATA_FLOW.md`.

# END OF PLUGIN_SYSTEM.md
