# OHTATS Configuration Standard

> Dokumen ini menjadi standar pengelolaan konfigurasi pada seluruh proyek OH-TRADER AI Trading System (OHTATS).

---

# 1. Tujuan

Menjamin seluruh konfigurasi sistem memiliki struktur yang konsisten, mudah dipelihara, dan mudah dikembangkan.

---

# 2. Prinsip

Seluruh konfigurasi harus memenuhi prinsip:

- Centralized
- Modular
- Readable
- Environment Aware
- Secure
- Version Controlled

---

# 3. Format Konfigurasi

Format utama yang digunakan adalah:

- YAML (.yaml)

Format lain hanya digunakan apabila memang diperlukan, misalnya:

- JSON
- TOML
- ENV

---

# 4. Struktur Folder

Folder konfigurasi utama:

config/

Contoh struktur:

config/
├── app.yaml
├── ai.yaml
├── database.yaml
├── trading.yaml
├── mt4.yaml
├── mt5.yaml
├── tradingview.yaml
├── dashboard.yaml
├── notification.yaml
├── logging.yaml
└── security.yaml

---

# 5. Lingkungan Konfigurasi (Environment)

OHTATS mendukung beberapa lingkungan konfigurasi.

## 5.1 Default

Digunakan sebagai konfigurasi dasar sistem.

Folder:

config/default/

---

## 5.2 Development

Digunakan selama proses pengembangan.

Folder:

config/development/

---

## 5.3 Testing

Digunakan saat pengujian sistem.

Folder:

config/testing/

---

## 5.4 Production

Digunakan saat sistem berjalan secara nyata.

Folder:

config/production/

---

# 6. Prioritas Konfigurasi

Urutan prioritas konfigurasi adalah:

1. Default
2. Environment
3. User Override

Contoh:

Default
↓
Development
↓
User Setting

Konfigurasi pada level yang lebih tinggi akan menimpa konfigurasi sebelumnya apabila terdapat nilai yang sama.

---

# 7. Aturan Penamaan

- Gunakan huruf kecil.
- Gunakan nama yang jelas.
- Satu file untuk satu domain konfigurasi.

Contoh:

- app.yaml
- ai.yaml
- database.yaml
- mt4.yaml
- mt5.yaml
- tradingview.yaml
- dashboard.yaml
- logging.yaml
- security.yaml