# OHTATS Coding Standard

> Dokumen ini menjadi standar penulisan kode pada seluruh proyek OH-TRADER AI Trading System (OHTATS).

---

# 1. Tujuan

Menjamin seluruh source code memiliki gaya penulisan yang konsisten, mudah dibaca, mudah diuji, dan mudah dipelihara.

---

# 2. Prinsip

Seluruh kode harus memenuhi prinsip:

- Clean Code
- Readable
- Modular
- Reusable
- Testable
- Documented

---

# 3. Aturan Umum

- Hindari Hardcode.
- Gunakan konfigurasi.
- Setiap module memiliki logging.
- Setiap function memiliki satu tanggung jawab.
- Hindari duplikasi kode (DRY - Don't Repeat Yourself).

---

# 4. Standar Penamaan

## 4.1 Folder

Gunakan huruf kecil.

Contoh:

- ai
- api
- config
- dashboard
- database
- mt4
- mt5
- tradingview

---

## 4.2 File Python

Gunakan snake_case.

Contoh:

- ai_manager.py
- trading_engine.py
- risk_manager.py
- database_manager.py

---

## 4.3 Class

Gunakan PascalCase.

Contoh:

- AIOrchestrator
- TradingEngine
- RiskManager
- DatabaseManager

---

## 4.4 Function

Gunakan snake_case.

Contoh:

- calculate_risk()
- execute_trade()
- load_strategy()
- save_history()

---

## 4.5 Variable

Gunakan snake_case.

Contoh:

- account_balance
- open_positions
- current_price
- stop_loss

---

# 5. Dokumentasi Kode

Setiap module harus memiliki docstring.

Setiap class harus memiliki deskripsi.

Function yang memiliki logika penting harus memiliki penjelasan singkat mengenai tujuan, parameter, dan nilai yang dikembalikan.