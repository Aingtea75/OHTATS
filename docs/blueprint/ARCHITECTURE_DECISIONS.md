# OHTATS Architecture Decisions

> Dokumen ini mencatat keputusan arsitektur penting yang menjadi dasar blueprint OHTATS.

---

# ADR-001 — Layered Modular Architecture

**Status:** Approved

OHTATS menggunakan layered modular architecture untuk menjaga separation of concerns, testability, maintainability, dan extensibility.

---

# ADR-002 — AI Orchestrator / Provider Abstraction

**Status:** Approved

AI capability diakses melalui abstraction/orchestration layer sehingga provider dapat ditambah, diganti, atau dinonaktifkan tanpa mengubah core domain secara fundamental.

AI tidak memperoleh akses broker langsung.

---

# ADR-003 — Multi-Platform Trading

**Status:** Approved

OHTATS mendukung integrasi bertahap untuk MT4, MT5, TradingView, broker API, crypto exchange, dan platform lain melalui connector/adapter boundary.

---

# ADR-004 — Canonical System Layering and Boundary

**Status:** Approved

Arsitektur canonical OHTATS menggunakan:

```text
Client & Interface
        ↓
API & Application
        ↓
Core Orchestration
        ↓
Domain Services
        ↓
Connector & Integration / Persistence Contracts
        ↓
External Systems / Storage
```

Infrastructure and Operations Services bersifat cross-cutting/supporting services dan tidak menjadi owner duplicate business master state.

### Alasan

`SYSTEM_DESIGN.md` sudah menetapkan Core Orchestration, Domain Services, Connector/Integration, dan Persistence/Data sebagai boundary utama. `ARCHITECTURE.md` harus menggunakan vocabulary yang sama agar tidak terdapat dua model layer yang saling bersaing.

### Consequences

- Layer lama User/Presentation/API/Business/AI/Trading/Data/Infrastructure diperlakukan sebagai konsep interface/domain/service detail, bukan canonical top-level architecture yang berbeda.
- Vendor-specific implementation tetap berada pada connector/provider boundary.
- Domain trading selalu melalui risk and trading controls.
- AI, workflow, plugin, copy trading, dan MCP tidak boleh bypass control boundary.

---

# ADR-005 — Repository-First Change Governance

**Status:** Approved

Repository Git adalah source of truth untuk blueprint dan implementation.

Perubahan besar dilakukan pada branch kerja dan masuk ke `master` setelah review dan acceptance criteria terpenuhi.

### Alasan

Menghindari perbedaan antara versi yang berada di percakapan, komputer lokal, dan repository.

### Consequences

- Dokumen yang hanya dibahas di chat belum dianggap baseline.
- Branch kerja dapat digunakan untuk eksperimen/review.
- `master` menjadi baseline aktif yang dapat dirujuk seluruh pihak.
- Perubahan arsitektur material harus memiliki rationale dan, bila relevan, ADR.

---

# END OF ARCHITECTURE_DECISIONS.md
