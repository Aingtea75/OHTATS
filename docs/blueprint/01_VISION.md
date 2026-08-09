# OHTATS — Vision Blueprint

> Dokumen ini mendefinisikan arah strategis, tujuan, ruang lingkup, dan hasil yang ingin dicapai oleh OHTATS (OH-TRADER AI Trading System).
>
> Dokumen ini bersifat **strategic blueprint**. Detail teknis, struktur modul, database, API, dan implementasi ditetapkan oleh blueprint turunannya.

---

# 1. Vision Statement

OHTATS adalah platform trading modular berbasis AI yang menyediakan satu ekosistem terstruktur untuk menghubungkan pengguna, strategi, analisis, risk management, trading platform, broker, data, AI provider, backtesting, automation, copy trading, plugin, dan layanan pendukung tanpa mengunci pengguna pada satu vendor atau teknologi.

OHTATS harus menjadi **platform penyedia fasilitas**, bukan sekadar aplikasi trading tunggal.

Platform harus dapat berkembang mengikuti perubahan teknologi tanpa kehilangan fondasi utama: modularitas, keamanan, auditabilitas, interoperabilitas, kontrol pengguna, dan keberlanjutan.

---

# 2. Long-Term Vision

Dalam jangka panjang OHTATS diarahkan menjadi fondasi ekosistem trading modern yang:

- mendukung berbagai trading platform;
- mendukung berbagai broker dan account;
- mendukung berbagai AI provider dan model;
- menyediakan strategi, EA, indicator, workflow, dan plugin yang dapat diuji dan dikelola;
- menyediakan backtesting dan evaluasi yang reproducible;
- menyediakan risk management sebagai kontrol inti;
- menyediakan automation dan copy trading melalui pipeline yang aman;
- menyediakan audit dan reporting yang dapat ditelusuri;
- dapat digunakan secara lokal maupun diperluas ke deployment/cloud di masa depan;
- dapat berkembang dari penggunaan individual menuju skala yang lebih besar;
- tetap mempertahankan pilihan dan kontrol pengguna.

---

# 3. Mission

Misi OHTATS adalah menyediakan fondasi dan fasilitas yang memungkinkan pengguna membangun, menguji, mengoperasikan, memonitor, dan mengevaluasi sistem trading secara lebih terstruktur dengan memanfaatkan teknologi AI dan integrasi eksternal tanpa membuat core platform bergantung pada satu penyedia.

OHTATS menyediakan fasilitas dan workflow. Pengguna tetap memiliki kendali atas konfigurasi, broker, account, AI provider, strategy, dan layanan eksternal yang digunakan sesuai kemampuan platform dan aturan yang berlaku.

---

# 4. Core Objectives

## 4.1 Integrated Trading Ecosystem

Menyatukan kebutuhan trading utama dalam satu platform terstruktur, termasuk:

- market data;
- strategy;
- AI analysis;
- risk management;
- trading execution;
- backtest;
- forward/paper testing;
- workflow automation;
- copy trading;
- analytics;
- monitoring;
- reporting;
- plugin dan extension;
- licensing dan entitlement;
- external integration.

## 4.2 Technology Independence

OHTATS tidak boleh bergantung secara fundamental pada satu:

- AI provider;
- broker;
- trading platform;
- database engine;
- cloud provider;
- notification provider;
- atau vendor eksternal lainnya.

Ketergantungan eksternal harus ditempatkan melalui abstraction, adapter, connector, atau integration boundary yang jelas.

## 4.3 AI-Enabled, Not AI-Controlled

AI digunakan untuk membantu analisis, rekomendasi, evaluasi, automation, dan pengambilan keputusan terstruktur.

AI tidak menjadi jalur langsung menuju broker.

Setiap keputusan yang dapat menghasilkan executable trading action harus tetap melewati policy, authorization, validation, risk management, trading pipeline, dan audit sesuai aturan sistem.

## 4.4 Test Before Trust

Strategi, EA, indicator, AI-assisted decision, workflow, dan konfigurasi trading harus dapat diuji sebelum digunakan pada live environment apabila jenis komponen tersebut memungkinkan pengujian.

Pengujian harus mendukung reproducibility sehingga hasil dapat ditelusuri kembali ke:

- strategy version;
- parameter set;
- market-data dataset version;
- execution assumptions;
- cost assumptions;
- environment/configuration yang relevan.

## 4.5 Risk First

Risk management merupakan kontrol inti, bukan fitur tambahan.

Tidak boleh ada jalur eksekusi yang secara sengaja melewati risk controls hanya karena sumber perintah berasal dari AI, workflow, copy trading, plugin, atau integrasi tertentu.

## 4.6 Auditability

Aktivitas penting harus dapat ditelusuri melalui audit trail, event history, trading history, workflow history, security events, dan reporting yang sesuai.

## 4.7 Extensible Platform

Kemampuan baru harus dapat ditambahkan melalui modul, plugin, provider, connector, adapter, workflow, atau extension point tanpa mengharuskan perubahan besar terhadap core system apabila tidak diperlukan.

---

# 5. Target Platform Ecosystem

OHTATS dirancang untuk mendukung secara bertahap:

- MetaTrader 4 (MT4);
- MetaTrader 5 (MT5);
- TradingView;
- broker REST/API;
- FIX/API integration;
- crypto exchange;
- platform trading tambahan melalui connector/plugin.

Platform tidak boleh menganggap model trading satu platform sebagai model universal. Perbedaan execution, symbol, account, hedging/netting, authentication, dan capability harus diisolasi pada integration/connector layer.

---

# 6. AI Ecosystem

OHTATS dirancang AI-provider-agnostic.

Provider yang dapat diintegrasikan antara lain:

- OpenAI;
- Google Gemini;
- Anthropic Claude;
- xAI Grok;
- DeepSeek;
- OpenRouter;
- Ollama;
- LM Studio;
- custom API/provider.

Daftar provider bukan daftar ketergantungan wajib. Provider dapat ditambah, diganti, dinonaktifkan, atau digunakan secara lokal sesuai konfigurasi dan kemampuan implementasi.

AI Manager/Orchestrator menjadi boundary utama antara core OHTATS dan provider eksternal.

---

# 7. User Control

OHTATS harus memberikan pilihan kepada pengguna mengenai:

- AI provider dan model;
- trading platform;
- broker;
- trading account;
- strategy;
- workflow;
- plugin;
- integration;
- deployment mode yang tersedia;
- dan fasilitas yang digunakan sesuai entitlement.

Platform tidak boleh mencampurkan entitlement/licensing dengan ownership atau historical trading state.

---

# 8. Platform as a Facility Provider

OHTATS diposisikan sebagai platform yang menyediakan fasilitas dan workflow.

Analogi konseptualnya adalah sebuah bangunan dengan berbagai fasilitas yang dapat digunakan sesuai hak akses pengguna.

Fasilitas dapat mencakup:

- trading;
- analysis;
- AI;
- backtest;
- strategy;
- indicator/EA;
- copy trading;
- reporting;
- monitoring;
- automation;
- plugin;
- marketplace;
- integration.

Model penggunaan atau licensing dapat berkembang seiring implementasi, tetapi fasilitas platform harus tetap dipisahkan secara arsitektural dari domain trading dan historical records.

---

# 9. Quality Philosophy

OHTATS menerapkan prinsip:

> **Blueprint → Validate → Implement → Test → Audit → Release**

Bukan:

> **Code first → repair later**

Tidak ada fitur besar yang dianggap siap hanya karena source code sudah dibuat.

Kesiapan harus dinilai berdasarkan dokumentasi, implementasi, test, security, auditability, dan acceptance criteria yang sesuai dengan tahapnya.

---

# 10. Non-Goals

Vision OHTATS tidak berarti bahwa semua kemampuan harus langsung tersedia pada versi pertama.

Hal-hal berikut merupakan bagian dari evolusi bertahap:

- cloud deployment berskala besar;
- multi-region/high availability tingkat lanjut;
- marketplace penuh;
- seluruh broker/platform sekaligus;
- seluruh AI provider sekaligus;
- seluruh jenis asset sekaligus;
- automation tanpa batas;
- live trading tanpa validation dan risk gate.

Prioritas implementasi harus mengikuti roadmap dan dependency blueprint, bukan sekadar banyaknya fitur.

---

# 11. Evolution Strategy

OHTATS harus berkembang secara bertahap melalui lapisan berikut:

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

Setiap tahap harus memiliki acceptance criteria dan tidak boleh dilompati tanpa alasan arsitektural yang terdokumentasi.

---

# 12. Success Criteria

Vision OHTATS dianggap berhasil diwujudkan apabila platform secara bertahap mampu:

1. mengintegrasikan trading platform melalui connector yang terisolasi;
2. mengintegrasikan lebih dari satu AI provider tanpa mengubah core secara besar;
3. menjalankan strategy melalui lifecycle yang terversi dan dapat diaudit;
4. menerapkan risk controls sebelum executable trading action;
5. menjalankan backtest yang reproducible;
6. menyediakan monitoring dan reporting yang dapat ditelusuri;
7. menyediakan copy trading tanpa bypass risk/trading pipeline;
8. mendukung plugin dan extension dengan capability yang terkontrol;
9. menjaga credential dan secret di luar business data biasa;
10. menjaga historical trading dan audit records secara konsisten;
11. dapat berkembang tanpa ketergantungan fundamental terhadap satu vendor;
12. memiliki dokumentasi dan test yang mengikuti perubahan implementasi.

---

# 13. Relationship to Other Blueprints

`01_VISION.md` menetapkan arah strategis.

Dokumen lain menjabarkan arah tersebut pada tingkat yang lebih spesifik:

- `PLATFORM_PHILOSOPHY.md` — prinsip dan filosofi platform;
- `PROJECT_CONSTITUTION.md` — aturan dasar pengembangan;
- `SYSTEM_DESIGN.md` — desain sistem tingkat tinggi;
- `ARCHITECTURE.md` — hubungan layer dan komponen teknis;
- `MODULE_SPECIFICATION.md` — tanggung jawab modul;
- `DATABASE_DESIGN.md` — model persistence;
- `ERD.md` — hubungan entity;
- blueprint domain lainnya — detail capability dan implementasi.

Jika terjadi konflik, konflik harus diselesaikan melalui review arsitektur dan keputusan yang terdokumentasi. Dokumen turunan tidak boleh diam-diam mengubah arah strategis vision.

---

# 14. Vision Status

**Status: BASELINE READY FOR REVIEW**

Dokumen ini menjadi baseline strategis untuk review dan penguncian sebelum blueprint turunan yang bergantung pada vision dinyatakan final.

---

# END OF 01_VISION.md
