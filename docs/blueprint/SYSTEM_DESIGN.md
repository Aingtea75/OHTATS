# OHTATS System Design

> Dokumen ini menjelaskan desain sistem utama OH-TRADER AI Trading System (OHTATS).

---

# 1. Tujuan

SYSTEM_DESIGN.md menjadi acuan utama dalam membangun arsitektur teknis OHTATS.

Dokumen ini menjelaskan komponen utama sistem, hubungan antar komponen, tanggung jawab setiap modul, serta alur komunikasi secara umum.

Dokumen ini tidak membahas implementasi kode, tetapi menjadi dasar sebelum proses pengembangan dimulai.

---

# 2. Filosofi Desain

OHTATS dirancang berdasarkan prinsip:

- Modular
- Scalable
- Extensible
- Secure
- Maintainable
- AI Ready
- Multi Platform
- Event Driven
- API First
- Plugin Based

---

# 3. Tujuan Desain

Desain sistem harus mampu:

- Mendukung MT4
- Mendukung MT5
- Mendukung TradingView
- Mendukung Multi Broker
- Mendukung Multi AI Provider
- Mendukung Backtest
- Mendukung Copy Trading
- Mendukung Dashboard
- Mendukung Mobile Access
- Mendukung Cloud di masa depan

---

# 4. Core Components

OHTATS terdiri dari beberapa komponen utama yang saling bekerja sama namun tetap bersifat modular.

Komponen utama tersebut adalah:

## 4.1 Core Engine

Merupakan pusat kendali seluruh sistem.

Tugas:

- Mengatur komunikasi antar modul.
- Mengelola siklus hidup sistem.
- Mengelola event utama.
- Menjalankan proses otomatis.

---

## 4.2 AI Manager

Mengelola seluruh komunikasi dengan AI Provider.

Fungsi:

- Memilih AI Provider aktif.
- Mengirim Prompt.
- Menerima Response.
- Mengatur AI Plugin.
- Mengelola AI Configuration.

---

## 4.3 Trading Engine

Bertanggung jawab terhadap seluruh aktivitas trading.

Fungsi:

- Open Position
- Close Position
- Modify Position
- Pending Order
- Order Validation
- Position Monitoring

---

## 4.4 Strategy Manager

Mengelola seluruh strategi trading.

Fungsi:

- Memuat Strategy.
- Mengaktifkan Strategy.
- Menonaktifkan Strategy.
- Mengatur Parameter Strategy.
- Menjalankan Evaluasi Strategy.

---

## 4.5 Risk Manager

Mengelola seluruh aturan manajemen risiko dalam sistem trading.

Fungsi:

- Menghitung ukuran lot (Position Sizing).
- Menentukan batas risiko per transaksi.
- Mengelola Daily Loss Limit.
- Mengelola Maximum Drawdown.
- Mengatur Risk Reward Ratio.
- Menghentikan trading apabila batas risiko tercapai.

---

## 4.6 Backtest Engine

Menyediakan lingkungan pengujian strategi menggunakan data historis.

Fungsi:

- Menjalankan Backtest.
- Menjalankan Forward Test.
- Menyimpan hasil pengujian.
- Menghasilkan laporan performa.
- Membandingkan beberapa strategi.

---

## 4.7 Data Manager

Mengelola seluruh data yang digunakan oleh sistem.

Fungsi:

- Mengelola Data Market.
- Mengelola Riwayat Trading.
- Mengelola Data AI.
- Mengelola Data Backtest.
- Mengelola Data Konfigurasi.
- Mengelola Cache.

---

## 4.8 Database Manager

Mengelola komunikasi dengan sistem database.

Fungsi:

- Membuka koneksi database.
- Menyimpan data.
- Membaca data.
- Melakukan Backup.
- Melakukan Restore.
- Optimasi database.

---

## 4.9 Connector Manager

Mengelola seluruh koneksi ke platform trading dan layanan eksternal.

Fungsi:

- Menghubungkan MT4.
- Menghubungkan MT5.
- Menghubungkan TradingView.
- Menghubungkan Broker API.
- Menghubungkan Exchange API.
- Mengelola status koneksi.

---

## 4.10 Plugin Manager

Mengelola seluruh plugin yang digunakan oleh sistem.

Fungsi:

- Memasang Plugin.
- Menghapus Plugin.
- Mengaktifkan Plugin.
- Menonaktifkan Plugin.
- Memperbarui Plugin.
- Memverifikasi kompatibilitas Plugin.

---

## 4.11 Notification Manager

Mengelola seluruh notifikasi sistem.

Fungsi:

- Notifikasi Trading.
- Notifikasi Error.
- Notifikasi AI.
- Notifikasi Risk.
- Notifikasi Backtest.
- Notifikasi Sistem.

Media notifikasi yang direncanakan:

- Dashboard
- Telegram
- Email
- Discord
- WhatsApp (opsional)

---

## 4.12 Logging & Audit Manager

Mengelola seluruh aktivitas pencatatan sistem.

Fungsi:

- System Log.
- Trading Log.
- AI Log.
- Error Log.
- Security Log.
- Audit Log.

Seluruh log harus memiliki waktu (timestamp), sumber (source), tingkat prioritas (level), dan deskripsi yang jelas.