# OHTATS Architecture Decisions

> Dokumen ini mencatat seluruh keputusan arsitektur penting yang diambil selama pengembangan OHTATS.

---

# ADR-001

## Judul

Menggunakan Layered Modular Architecture

### Status

Approved

### Alasan

- Memudahkan pengembangan.
- Memudahkan pengujian.
- Memudahkan pemeliharaan.
- Mendukung penambahan fitur tanpa mengubah Core System.

---

# ADR-002

## Judul

Menggunakan AI Orchestrator

### Status

Approved

### Alasan

- Mendukung banyak AI Provider.
- Provider dapat diganti tanpa mengubah modul lain.
- Mendukung fallback AI.
- Mendukung pemilihan model otomatis.

---

# ADR-003

## Judul

Mendukung Multi Platform Trading

### Status

Approved

### Platform

- MetaTrader 4 (MT4)
- MetaTrader 5 (MT5)
- TradingView
- Broker API
- Crypto Exchange API

### Alasan

- Fleksibilitas tinggi.
- Mudah dikembangkan.
- Tidak bergantung pada satu platform.