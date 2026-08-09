# OHTATS Project Constitution

> Dokumen ini menjadi aturan dasar dalam perancangan, pengembangan, pengujian, review, dan pemeliharaan platform OHTATS (Om Hend Trader AI Trading System).

---

# 1. Tujuan

Project Constitution memastikan seluruh pengembangan OHTATS memiliki aturan yang sama, terstruktur, terdokumentasi, dapat diaudit, dan dapat dikembangkan dalam jangka panjang.

---

# 2. Prinsip Utama

- Documentation First
- Blueprint Before Coding
- Modular Architecture
- AI Provider Agnostic
- Multi Platform
- Security by Design
- API First
- Plugin Based
- Risk First
- Auditability
- Maintainability
- Reproducibility

---

# 3. Filosofi Pengembangan

Sebelum implementasi fitur besar, requirement dan blueprint harus tersedia.

Urutan default:

```text
Vision
  ↓
Platform Principles
  ↓
System Design
  ↓
Architecture
  ↓
Module Specification
  ↓
Data / API / Integration Design
  ↓
Implementation
  ↓
Testing
  ↓
Release
```

Pengecualian terhadap urutan harus memiliki alasan yang terdokumentasi.

---

# 4. Source of Truth

Repository Git adalah sumber kebenaran proyek.

Dokumen atau keputusan yang hanya berada di percakapan, catatan lokal, atau AI session tidak dianggap sebagai baseline proyek sampai tercatat di repository melalui commit/PR yang sesuai.

---

# 5. Status Dokumen

Status blueprint resmi:

- `DRAFT` — pekerjaan awal.
- `REVIEW` — sedang diverifikasi.
- `APPROVED` — memenuhi acceptance criteria dan disetujui.
- `LOCKED` — baseline yang tidak boleh diubah tanpa review/decision baru.
- `DEPRECATED` — tidak lagi menjadi sumber aktif.

Status harus ditulis pada dokumen atau metadata governance yang sesuai.

---

# 6. Change Control

Perubahan terhadap dokumen `APPROVED` atau `LOCKED` harus:

1. memiliki alasan perubahan;
2. diperiksa dampaknya terhadap dokumen terkait;
3. melalui review;
4. dicatat dalam commit dan, bila relevan, ADR/PR;
5. tidak menghapus historical rationale tanpa alasan governance.

---

# 7. Standar Arsitektur

Seluruh sistem mengikuti modular architecture dengan boundary yang jelas.

Komunikasi antar modul dilakukan melalui interface, service, command, event, atau API contract yang terdokumentasi.

Circular dependency dan bypass terhadap security, risk, trading, atau audit controls dilarang.

---

# 8. Standar Dokumentasi

Fitur besar minimal memiliki:

- tujuan;
- fungsi;
- boundary;
- cara kerja;
- dependency;
- konfigurasi;
- acceptance criteria;
- testing scope;
- dan catatan perubahan bila diperlukan.

Dokumentasi diperbarui ketika terdapat perubahan arsitektur atau behavior yang material.

---

# 9. Standar Penamaan

Nama folder, file, modul, class, function, dan variable harus jelas, konsisten, dan menggambarkan tanggung jawabnya.

---

# 10. Standar Konfigurasi

Konfigurasi dipisahkan dari source code.

Secret dan credential tidak boleh di-hardcode atau disimpan plaintext pada business tables.

---

# 11. Standar Keamanan

Security by Design wajib diterapkan melalui:

- least privilege;
- authentication;
- authorization;
- capability control;
- secret protection;
- audit logging;
- encryption sesuai kebutuhan;
- backup dan recovery.

---

# 12. Standar Pengujian

Modul harus dapat diuji secara mandiri sesuai jenisnya.

Jenis pengujian dapat mencakup:

- Unit Test
- Integration Test
- System Test
- Performance Test
- Backtest
- Forward Test
- Paper Trading
- Security Test

Tidak ada fitur yang dianggap siap hanya karena kode telah dibuat.

---

# 13. Standar AI

OHTATS AI Provider Agnostic.

Provider seperti OpenAI, Gemini, Claude, Grok, DeepSeek, OpenRouter, Ollama, LM Studio, dan custom API dapat diintegrasikan melalui provider abstraction.

AI tidak boleh memperoleh jalur langsung ke broker command dan tidak boleh melewati policy, authorization, validation, risk, trading, atau audit controls.

---

# 14. Standar Integrasi Trading

Trading platform diintegrasikan melalui connector/adapter boundary.

Target meliputi:

- MT4
- MT5
- TradingView
- Broker REST/API
- FIX/API
- Crypto Exchange API

Connector harus dapat berkembang tanpa menjadikan vendor-specific model sebagai canonical core model.

---

# 15. Standar Plugin

Plugin harus memiliki lifecycle, compatibility, configuration, documentation, dan capability boundary.

Plugin tidak boleh memperoleh privilege di luar capability yang diberikan.

---

# 16. Standar Git Workflow

Branch default repository saat ini adalah `master`.

Perubahan pekerjaan dilakukan melalui branch kerja, misalnya:

```text
master
  ├── work/*
  ├── feature/*
  ├── hotfix/*
  └── release/*
```

Perubahan besar tidak langsung dianggap baseline hanya karena sudah di-push ke branch kerja. Baseline masuk `master` setelah review dan acceptance criteria terpenuhi.

---

# 17. Standar Audit

Aktivitas penting harus dapat ditelusuri, termasuk:

- authentication;
- configuration changes;
- strategy publication/deployment;
- risk changes;
- trading actions;
- backtest;
- copy trading;
- AI decisions yang relevan;
- licensing changes;
- deployment;
- administrative actions;
- security events.

---

# 18. Penutup

Project Constitution merupakan aturan dasar OHTATS. Blueprint turunan harus konsisten terhadap constitution, vision, dan keputusan arsitektur yang telah disetujui.

Perubahan terhadap constitution harus melalui review dan dicatat dalam repository.

---

# END OF PROJECT_CONSTITUTION.md
