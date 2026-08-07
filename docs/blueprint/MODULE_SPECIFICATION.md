# OHTATS Module Specification

> Dokumen ini berisi daftar seluruh modul yang terdapat pada OH-TRADER AI Trading System (OHTATS).

---

# 1. Tujuan

Dokumen ini menjadi referensi utama seluruh modul yang ada di dalam sistem.

Setiap modul harus memiliki fungsi yang jelas, tanggung jawab yang spesifik, serta dapat dikembangkan secara mandiri tanpa memengaruhi modul lainnya.

---

# 2. Prinsip Modul

Seluruh modul OHTATS harus memenuhi prinsip berikut:

- Single Responsibility
- Modular
- Reusable
- Testable
- Replaceable
- Configurable
- Documented

---

# 3. Daftar Modul Inti (Core Modules)

## 3.1 Core Engine

Pusat kendali sistem.

---

## 3.2 AI Orchestrator

Mengelola seluruh layanan Artificial Intelligence.

---

## 3.3 Trading Engine

Menjalankan seluruh proses trading.

---

## 3.4 Strategy Manager

Mengelola strategi trading.

---

## 3.5 Risk Manager

Mengelola manajemen risiko.

---

## 3.6 Backtest Engine

Menjalankan pengujian strategi menggunakan data historis.

---

## 3.7 Data Manager

Mengelola seluruh data sistem.

---

## 3.8 Database Manager

Mengelola komunikasi dengan database.

---

# 4. Infrastructure Modules

## 4.1 Connector Manager

Mengelola seluruh koneksi ke platform trading dan layanan eksternal.

---

## 4.2 Plugin Manager

Mengelola plugin yang digunakan oleh sistem.

---

## 4.3 Notification Manager

Mengelola seluruh notifikasi sistem.

---

## 4.4 Logging Manager

Mengelola pencatatan aktivitas sistem.

---

## 4.5 Audit Manager

Mengelola audit seluruh aktivitas penting.

---

## 4.6 Configuration Manager

Mengelola konfigurasi sistem.

---

## 4.7 Security Manager

Mengelola autentikasi, otorisasi, dan keamanan sistem.

---

## 4.8 Scheduler Manager

Mengelola seluruh proses yang berjalan secara terjadwal.

---

## 4.9 Monitoring Manager

Mengelola monitoring kesehatan seluruh sistem.

---

## 4.10 Backup & Restore Manager

Mengelola proses backup dan restore data sistem.

---

# 5. Trading Modules

## 5.1 Order Manager

Mengelola seluruh proses pembuatan dan pengiriman order.

---

## 5.2 Position Manager

Mengelola seluruh posisi trading yang sedang berjalan.

---

## 5.3 Portfolio Manager

Mengelola keseluruhan portofolio trading.

---

## 5.4 Money Management

Mengelola perhitungan lot, margin, dan alokasi modal.

---

## 5.5 Copy Trading Manager

Mengelola proses Copy Trading antara Master dan Follower.

---

## 5.6 Backtest Result Manager

Mengelola penyimpanan dan analisis hasil Backtest.

---

## 5.7 Performance Analyzer

Menghitung performa trading seperti:

- Profit Factor
- Win Rate
- Drawdown
- Sharpe Ratio
- Recovery Factor
- Expectancy

---

# 6. AI Modules

## 6.1 AI Orchestrator

Mengelola seluruh layanan Artificial Intelligence dan menentukan AI Provider yang digunakan sesuai kebutuhan.

---

## 6.2 Prompt Manager

Mengelola seluruh Prompt yang digunakan oleh sistem AI.

---

## 6.3 Memory Manager

Mengelola memori percakapan dan konteks AI agar setiap AI Provider dapat bekerja secara konsisten.

---

## 6.4 AI Provider Manager

Mengelola seluruh AI Provider yang terhubung ke OHTATS.

AI Provider yang direncanakan:

- OpenAI
- Google Gemini
- Anthropic Claude
- xAI Grok
- DeepSeek
- OpenRouter
- Ollama
- LM Studio
- Custom AI Provider

---

## 6.5 Model Selector

Menentukan model AI terbaik berdasarkan jenis pekerjaan yang dilakukan.

Contoh:

- Analisis Trading
- Analisis Fundamental
- Analisis Teknikal
- Penulisan Kode
- Analisis Risiko
- Pembuatan Laporan

---

## 6.6 AI Memory Storage

Menyimpan riwayat interaksi AI yang diperlukan untuk mendukung proses analisis dan pembelajaran sistem.

---

## 6.7 Cost Manager

Mengelola penggunaan token, biaya AI, serta statistik penggunaan setiap AI Provider.

---

# 7. Interface Modules

## 7.1 Dashboard Manager

Mengelola seluruh tampilan Dashboard OHTATS.

Dashboard meliputi:

- Desktop Dashboard
- Web Dashboard
- Mobile Dashboard

---

## 7.2 REST API Manager

Menyediakan layanan REST API untuk komunikasi antar aplikasi.

---

## 7.3 WebSocket Manager

Mengelola komunikasi data secara real-time.

---

## 7.4 Authentication Manager

Mengelola proses Login, Logout, Session, dan Token pengguna.

---

## 7.5 User Manager

Mengelola seluruh data pengguna, hak akses, dan profil pengguna.

---

## 7.6 Role & Permission Manager

Mengelola Role Based Access Control (RBAC).

Contoh Role:

- Super Admin
- Administrator
- Trader
- Viewer
- Developer

---

## 7.7 MCP Server

Menyediakan layanan Model Context Protocol (MCP) sebagai jembatan antara OHTATS dengan AI Assistant dan aplikasi eksternal.