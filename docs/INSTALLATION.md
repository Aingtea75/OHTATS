# INSTALLATION

## 1. Pendahuluan

Dokumen ini menjelaskan proses instalasi platform **OHTATS (Om Hend Trader AI Trading System)**.

Panduan ini ditujukan bagi pengguna, administrator, maupun developer yang ingin memasang dan menjalankan OHTATS pada lingkungan lokal (Local Development) maupun lingkungan produksi (Production).

Dokumen ini hanya membahas proses instalasi. Untuk konfigurasi setelah instalasi selesai, silakan lihat **CONFIGURATION.md**.

---

# 2. Tujuan

Dokumen ini bertujuan untuk:

- Menjelaskan proses instalasi OHTATS secara bertahap.
- Mengurangi kesalahan selama proses pemasangan.
- Menjadi panduan standar instalasi.
- Memastikan seluruh komponen sistem telah terpasang dengan benar sebelum digunakan.

---

# 3. Ruang Lingkup

Dokumen ini mencakup:

- Persyaratan sistem
- Perangkat lunak yang diperlukan
- Instalasi proyek
- Verifikasi instalasi
- Troubleshooting dasar

---

# 4. Persyaratan Sistem

## 4.1 Sistem Operasi

OHTATS dirancang agar dapat dijalankan pada:

- Windows 10 atau yang lebih baru
- Linux (Ubuntu LTS direkomendasikan)
- macOS (versi terbaru)

---

## 4.2 Perangkat Lunak

Pastikan perangkat lunak berikut telah tersedia:

- Python
- Git
- Visual Studio Code
- MetaTrader 4 (opsional)
- Docker (opsional)
- PostgreSQL atau SQLite (sesuai implementasi)

---

## 4.3 Spesifikasi Minimum

Disarankan menggunakan spesifikasi minimal:

| Komponen | Minimum |
|----------|----------|
| CPU | 2 Core |
| RAM | 8 GB |
| Storage | 20 GB |
| Internet | Stabil |

---

# 5. Proses Instalasi

## Langkah 1

Clone repository OHTATS.

## Langkah 2

Masuk ke folder proyek.

## Langkah 3

Buat Virtual Environment Python.

## Langkah 4

Aktifkan Virtual Environment.

## Langkah 5

Install seluruh dependency proyek.

## Langkah 6

Salin file konfigurasi awal dari `.env.example` menjadi `.env`.

## Langkah 7

Lakukan konfigurasi sesuai kebutuhan.

## Langkah 8

Jalankan proses inisialisasi database.

## Langkah 9

Verifikasi bahwa seluruh modul berhasil dijalankan.

---

# 6. Verifikasi Instalasi

Setelah instalasi selesai, lakukan pemeriksaan berikut:

- Struktur folder proyek telah lengkap.
- Seluruh dependency berhasil dipasang.
- Database berhasil dibuat.
- Konfigurasi dapat dibaca oleh aplikasi.
- Tidak terdapat pesan kesalahan saat proses startup.

---

# 7. Struktur Direktori

Setelah instalasi selesai, struktur proyek utama akan menyerupai berikut:

```text
OHTATS/

ai/
api/
config/
dashboard/
database/
docs/
examples/
logs/
mcp/
mt4/
scripts/
strategy/
tests/
tools/

README.md
LICENSE
requirements.txt
```

---

# 8. Troubleshooting

Apabila terjadi masalah selama instalasi:

- Pastikan seluruh dependency telah terpasang.
- Periksa konfigurasi pada file `.env`.
- Pastikan versi Python sesuai kebutuhan proyek.
- Pastikan hak akses folder proyek mencukupi.
- Periksa log aplikasi untuk informasi kesalahan.

---

# 9. Dokumen Terkait

- README.md
- CONFIGURATION.md
- DATABASE.md
- API.md
- MT4.md

---

# 10. Versi Dokumen

| Informasi | Nilai |
|------------|--------|
| Project | OHTATS |
| Document | INSTALLATION.md |
| Version | 1.0.0 |
| Status | Active |

---

# 11. Penutup

Dokumen ini menjadi acuan utama dalam proses instalasi OHTATS.

Apabila terdapat perubahan pada proses instalasi di masa mendatang, dokumen ini harus diperbarui agar tetap sesuai dengan implementasi sistem.