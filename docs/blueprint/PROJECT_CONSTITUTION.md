# OHTATS Project Constitution

> Dokumen ini menjadi aturan dasar (konstitusi) dalam perancangan, pengembangan, pengujian, dan pemeliharaan platform OH-TRADER AI Trading System (OHTATS).

---

# 1. Tujuan

Project Constitution dibuat untuk memastikan seluruh pengembangan OHTATS memiliki standar yang sama, terstruktur, terdokumentasi, dan mudah dikembangkan dalam jangka panjang.

Seluruh pengembang yang terlibat dalam proyek wajib mengikuti aturan yang tertulis pada dokumen ini.

---

# 2. Prinsip Utama

OHTATS dibangun berdasarkan prinsip berikut:

- Documentation First
- Blueprint Before Coding
- Modular Architecture
- AI Provider Agnostic
- Multi Platform
- Security by Design
- API First
- Plugin Based
- High Performance
- Maintainability

---

# 3. Filosofi Pengembangan

Sebelum menulis kode, setiap fitur wajib memiliki blueprint yang jelas.

Tidak ada implementasi tanpa perencanaan.

Blueprint menjadi sumber referensi utama dalam seluruh proses pengembangan.

---

# 4. Status Dokumen

Status dokumen blueprint dapat berupa:

- Draft
- Review
- Approved
- Deprecated

---

# 5. Standar Arsitektur

Seluruh sistem OHTATS wajib mengikuti arsitektur modular.

Setiap modul harus memiliki tanggung jawab yang jelas dan tidak saling bergantung secara langsung.

Komunikasi antar modul harus dilakukan melalui antarmuka (interface), service, atau API yang telah ditentukan.

Tidak diperbolehkan membuat ketergantungan yang menyebabkan perubahan pada satu modul merusak modul lainnya.

---

# 6. Standar Dokumentasi

Seluruh fitur wajib memiliki dokumentasi.

Minimal setiap fitur harus memiliki:

- Tujuan
- Fungsi
- Cara Kerja
- Diagram (jika diperlukan)
- Konfigurasi
- Dependensi
- Catatan Pengembangan

Dokumentasi harus diperbarui setiap kali terdapat perubahan besar.

---

# 7. Standar Penamaan

Nama folder, file, modul, class, function, dan variabel harus konsisten.

Gunakan nama yang jelas, mudah dipahami, dan menggambarkan fungsinya.

Hindari singkatan yang tidak umum.

Standar penamaan akan dijelaskan lebih rinci pada dokumen Coding Standard di masa mendatang.

---

# 8. Standar Konfigurasi

Seluruh konfigurasi sistem harus dipisahkan dari source code.

Konfigurasi disimpan pada folder `config/` menggunakan format yang telah ditentukan oleh proyek.

Tidak diperbolehkan menuliskan informasi konfigurasi secara langsung (hardcode) di dalam program, kecuali untuk nilai konstan yang memang menjadi bagian dari logika sistem.

Seluruh perubahan konfigurasi harus dapat dilakukan tanpa mengubah source code.

---

# 9. Standar Keamanan

Keamanan merupakan bagian dari desain sistem sejak awal (Security by Design).

Prinsip yang harus diterapkan:

- Least Privilege (hak akses minimum)
- Authentication untuk akses sistem
- Authorization berdasarkan peran (Role)
- Audit Log untuk aktivitas penting
- Enkripsi data sensitif
- Backup dan Restore

---

# 10. Standar Pengujian

Setiap modul harus dapat diuji secara mandiri.

Jenis pengujian yang akan digunakan antara lain:

- Unit Test
- Integration Test
- System Test
- Performance Test
- Backtest
- Forward Test
- Paper Trading

Tidak ada modul yang dinyatakan selesai sebelum melalui proses pengujian yang sesuai.

---

# 11. Standar Pengembangan AI

OHTATS dirancang sebagai platform AI Provider Agnostic.

Sistem tidak boleh bergantung pada satu penyedia AI tertentu.

Seluruh integrasi AI harus menggunakan AI Manager sehingga penambahan atau penggantian AI Provider tidak memerlukan perubahan pada modul inti.

AI Provider yang direncanakan meliputi:

- OpenAI
- Google Gemini
- Anthropic Claude
- xAI Grok
- DeepSeek
- OpenRouter
- Ollama
- LM Studio
- Custom API

Seluruh AI Provider bersifat opsional dan dapat diaktifkan atau dinonaktifkan melalui konfigurasi.

---

# 12. Standar Integrasi Platform Trading

OHTATS harus mendukung berbagai platform trading melalui sistem Connector.

Platform yang direncanakan meliputi:

- MetaTrader 4 (MT4)
- MetaTrader 5 (MT5)
- TradingView
- Broker REST API
- FIX API
- Crypto Exchange API

Setiap Connector dikembangkan sebagai modul terpisah sehingga tidak memengaruhi modul lain.

---

# 13. Standar Plugin

Seluruh fitur tambahan harus dikembangkan sebagai Plugin apabila memungkinkan.

Plugin harus dapat:

- Dipasang tanpa mengubah Core System.
- Diperbarui secara mandiri.
- Dinonaktifkan tanpa memengaruhi sistem utama.
- Memiliki dokumentasi sendiri.
- Memiliki konfigurasi sendiri.

---

# 14. Standar Version Control

Seluruh source code OHTATS wajib dikelola menggunakan Git.

Setiap perubahan harus memiliki riwayat yang jelas sehingga mudah ditelusuri, ditinjau, dan dikembalikan apabila diperlukan.

Branch utama yang digunakan:

- main
- develop
- feature/*
- hotfix/*
- release/*

---

# 15. Standar Audit

Seluruh aktivitas penting harus dapat diaudit.

Audit meliputi:

- Login
- Logout
- Perubahan Konfigurasi
- Aktivasi AI
- Eksekusi Trading
- Backtest
- Copy Trading
- Deployment
- Error System

Audit Log harus disimpan sehingga dapat digunakan untuk proses analisis maupun investigasi.

---

# 16. Penutup

Project Constitution merupakan dokumen dasar yang menjadi acuan seluruh proses pengembangan OHTATS.

Setiap perubahan terhadap dokumen ini harus melalui proses review sebelum diterapkan.

Seluruh blueprint berikutnya harus mengikuti prinsip-prinsip yang telah ditetapkan pada dokumen ini.

Perubahan pada dokumen harus dicatat dan ditinjau sebelum diterapkan.