# PLATFORM PHILOSOPHY

## 1. Identitas Platform

OHTATS (Om Hend Trader AI Trading System) merupakan sebuah Platform Trading Automation berbasis Artificial Intelligence yang dirancang sebagai ekosistem digital terpadu (Integrated Trading Ecosystem), bukan sekadar aplikasi trading.

Platform ini dibangun untuk menyediakan infrastruktur yang mampu menghubungkan pengguna, akun trading, broker, AI Provider, Workflow Automation, Plugin, Marketplace, serta berbagai layanan pihak ketiga ke dalam satu sistem yang terintegrasi.

OHTATS tidak berfokus pada satu teknologi atau satu platform tertentu, melainkan menyediakan fondasi yang fleksibel agar mampu mengikuti perkembangan teknologi, kebutuhan pengguna, dan dinamika industri trading dalam jangka panjang.

Seluruh komponen sistem dirancang secara modular sehingga setiap modul dapat dikembangkan, diperbarui, maupun diganti tanpa mengganggu komponen lainnya.

## 2. Open Ecosystem Philosophy

OHTATS dibangun dengan filosofi Open Ecosystem, yaitu platform yang dapat diperluas, dikembangkan, dan diintegrasikan dengan berbagai layanan tanpa harus mengubah arsitektur inti sistem.

Seluruh fitur utama dirancang menggunakan pendekatan modular sehingga setiap kemampuan baru dapat ditambahkan melalui mekanisme Plugin, API, Workflow, maupun Integrasi Eksternal.

Pendekatan ini memungkinkan OHTATS untuk terus berkembang mengikuti perubahan teknologi tanpa harus melakukan perubahan besar pada sistem inti.

Prinsip Open Ecosystem meliputi:

- Mendukung Plugin resmi maupun Plugin pihak ketiga.
- Mendukung integrasi API dari berbagai penyedia layanan.
- Mendukung Workflow Automation yang dapat dikustomisasi.
- Mendukung AI Provider yang dapat dipilih pengguna.
- Mendukung Marketplace sebagai pusat distribusi komponen.
- Mendukung penambahan modul baru tanpa mengubah Core System.

## 3. Multi Platform Philosophy

OHTATS tidak dibangun untuk satu platform trading tertentu.

Seluruh platform diperlakukan sebagai Trading Provider yang berada di atas lapisan abstraksi (Abstraction Layer), sehingga seluruh modul internal menggunakan antarmuka yang sama tanpa bergantung pada implementasi masing-masing platform.

Dengan pendekatan ini, penambahan platform baru tidak memerlukan perubahan pada modul inti OHTATS.

Platform yang didukung meliputi:

- MetaTrader 4 (MT4)
- MetaTrader 5 (MT5)
- TradingView
- Broker API
- Crypto Exchange
- Stock Broker
- Futures Broker
- CFD Provider
- Platform lain melalui Plugin atau API Integration.

Pendekatan ini memastikan OHTATS tetap fleksibel terhadap perkembangan teknologi trading di masa depan.

## 4. AI Independence

Artificial Intelligence merupakan salah satu komponen utama OHTATS, namun platform tidak bergantung pada satu penyedia AI tertentu.

OHTATS menerapkan filosofi AI Independence, yaitu memberikan kebebasan kepada pengguna untuk memilih, mengganti, maupun menggabungkan berbagai AI Provider sesuai kebutuhan.

Workflow, Analisis Pasar, Risk Management, maupun Trading Automation dapat menggunakan satu atau beberapa AI secara bersamaan.

Contoh AI Provider yang dapat digunakan antara lain:

- OpenAI
- Google Gemini
- Anthropic Claude
- Grok
- Local LLM
- AI Provider lainnya yang mendukung standar integrasi OHTATS.

Dengan pendekatan ini, perkembangan AI di masa depan dapat langsung dimanfaatkan tanpa harus mengubah arsitektur sistem.

## 5. Bring Your Own Key (BYOK)

OHTATS menerapkan filosofi Bring Your Own Key (BYOK), yaitu memberikan kebebasan kepada pengguna untuk menggunakan API Key miliknya sendiri.

Pengguna dapat memilih salah satu dari beberapa mode penggunaan AI berikut:

- BYOK (Bring Your Own Key)
- OHTATS Managed AI
- Hybrid Mode

Pada mode BYOK, seluruh biaya penggunaan AI ditanggung langsung oleh pengguna kepada penyedia AI.

Pada mode OHTATS Managed AI, biaya penggunaan AI dikelola melalui layanan OHTATS sesuai paket layanan yang dipilih.

Hybrid Mode memungkinkan kedua pendekatan tersebut digunakan secara bersamaan.

Filosofi ini memberikan fleksibilitas, transparansi biaya, serta menghindari ketergantungan terhadap satu penyedia layanan AI.

## Status

Draft v1.0

## Tujuan

Dokumen ini menjadi landasan filosofis pengembangan OHTATS.

Seluruh keputusan desain, arsitektur, pengembangan fitur, database, API, AI, dan integrasi harus mengacu pada prinsip-prinsip yang terdapat dalam dokumen ini.

Dokumen ini berada pada tingkat tertinggi dalam Blueprint OHTATS.

## Visi Filosofi

OHTATS dibangun sebagai platform orkestrasi trading berbasis AI yang memberikan kebebasan kepada setiap pengguna untuk memilih teknologi terbaik sesuai kebutuhan mereka.

OHTATS tidak mengunci pengguna pada AI tertentu, broker tertentu, atau platform trading tertentu.

Nilai utama OHTATS adalah menyediakan ekosistem yang terintegrasi, aman, fleksibel, dapat diaudit, dan mudah dikembangkan sehingga pengguna dapat membangun workflow trading mereka sendiri.

OHTATS berperan sebagai penghubung (orchestrator) antara berbagai layanan, bukan sebagai pengganti layanan tersebut.

## Core Principles

Platform OHTATS dibangun berdasarkan prinsip-prinsip berikut:

1. Freedom of AI
2. Freedom of Broker
3. Freedom of Platform
4. Bring Your Own Provider (BYOP)
5. Official OHTATS Components
6. Workflow over Vendor
7. AI-Agnostic Architecture
8. Open Ecosystem
9. Scalability First
10. Transparency & Auditability
11. Security by Design
12. Quality Before Release

## 5.1. Freedom of AI

### Prinsip

OHTATS tidak mengunci pengguna pada penyedia AI tertentu.

Pengguna bebas memilih, mengganti, atau menggunakan lebih dari satu AI sesuai kebutuhan dan kebijakan mereka.

### Tujuan

- Memberikan kebebasan kepada pengguna.
- Menghindari ketergantungan pada satu penyedia AI.
- Mempermudah integrasi AI baru di masa depan.
- Memberikan fleksibilitas dalam pengelolaan biaya penggunaan AI.

### Implementasi

OHTATS menyediakan AI Provider Layer sehingga setiap AI dapat dihubungkan melalui antarmuka (interface) yang seragam.

Contoh AI yang dapat didukung:

- ChatGPT
- Gemini
- Claude
- Grok
- DeepSeek
- Ollama (Local AI)
- OpenRouter
- AI Provider lainnya

## 5.2. Freedom of Broker

### Prinsip

OHTATS tidak mengunci pengguna pada broker tertentu.

Pengguna memiliki kebebasan penuh untuk memilih broker yang sesuai dengan kebutuhan, regulasi, lokasi, dan strategi trading mereka.

### Tujuan

- Memberikan kebebasan memilih broker.
- Menghindari ketergantungan pada satu broker.
- Mempermudah integrasi broker baru.
- Mendukung perdagangan lintas pasar dan lintas negara.

### Implementasi

OHTATS menyediakan Broker Provider Layer sehingga setiap broker dapat diintegrasikan menggunakan konektor yang terstandarisasi.

OHTATS tidak menerima dana pengguna, tidak bertindak sebagai broker, dan tidak memaksa penggunaan broker tertentu.

### Peran OHTATS

OHTATS dapat menyediakan informasi dan analisis mengenai broker, seperti:

- Status regulasi.
- Dukungan platform (MT4, MT5, cTrader, API, dll.).
- Ketersediaan API.
- Kualitas eksekusi.
- Spread dan komisi (berdasarkan data yang tersedia).
- Rekam jejak dan indikator kualitas layanan.

Seluruh keputusan pemilihan broker tetap berada di tangan pengguna.

## 5.3. Freedom of Platform

### Prinsip

OHTATS tidak membatasi pengguna pada satu platform trading tertentu.

Pengguna dapat menghubungkan satu atau beberapa platform trading yang didukung sesuai kebutuhan mereka.

### Tujuan

- Memberikan fleksibilitas dalam penggunaan platform trading.
- Mendukung berbagai ekosistem trading.
- Mempermudah integrasi platform baru di masa depan.
- Mengurangi ketergantungan pada satu vendor.

### Implementasi

OHTATS menyediakan Platform Provider Layer yang memungkinkan integrasi berbagai platform melalui konektor yang terstandarisasi.

Contoh platform yang dapat didukung:

- MetaTrader 4 (MT4)
- MetaTrader 5 (MT5)
- TradingView
- cTrader
- DXtrade
- Broker API
- Platform lain yang memenuhi standar integrasi OHTATS.

### Peran OHTATS

OHTATS menyediakan workflow, analitik, AI, dan otomatisasi yang bekerja di atas platform trading pilihan pengguna.

OHTATS bukan pengganti platform trading, melainkan penghubung yang menyatukan berbagai platform dalam satu ekosistem.

## 5.4. Bring Your Own Provider (BYOP)

### Prinsip

OHTATS memberikan kebebasan kepada pengguna untuk menghubungkan layanan yang telah mereka miliki tanpa harus berpindah ke penyedia layanan lain.

Pengguna dapat menggunakan layanan pihak ketiga maupun layanan resmi OHTATS secara bersamaan sesuai kebutuhan.

### Tujuan

- Menghindari vendor lock-in.
- Memanfaatkan investasi pengguna yang sudah ada.
- Memberikan fleksibilitas dalam membangun workflow trading.
- Mempermudah integrasi teknologi baru.

### Implementasi

Melalui Provider Layer, pengguna dapat menghubungkan berbagai layanan, seperti:

- AI Provider
- Broker Provider
- Trading Platform Provider
- News Provider
- Market Data Provider
- Notification Provider
- Storage Provider
- Payment Provider
- VPS / Cloud Provider
- Local AI Provider

Seluruh provider dikelola melalui Provider Center sehingga konfigurasi tetap terpusat dan mudah dikelola.

### Filosofi

OHTATS tidak memaksa pengguna meninggalkan layanan yang telah mereka gunakan.

Sebaliknya, OHTATS menjadi penghubung yang menyatukan seluruh layanan tersebut dalam satu workflow yang terintegrasi.

### Analogi

OHTATS dapat dianalogikan sebagai sebuah bandara internasional.

Bandara menyediakan infrastruktur, sistem, keamanan, dan koordinasi, tetapi tidak memiliki seluruh maskapai yang beroperasi di dalamnya.

Demikian pula OHTATS menyediakan platform, workflow, dan orkestrasi, sementara pengguna bebas memilih AI, broker, platform trading, dan layanan lainnya.

## 5.5. Official OHTATS Components

### Prinsip

Selain mendukung layanan pihak ketiga, OHTATS menyediakan komponen resmi yang dikembangkan, diuji, didokumentasikan, dan dipelihara oleh tim OHTATS.

Komponen resmi ini dirancang agar pengguna dapat langsung menggunakannya (plug and play) tanpa harus membangun semuanya dari awal.

### Tujuan

- Memberikan solusi siap pakai dengan standar kualitas tinggi.
- Mempercepat proses implementasi pengguna.
- Menjamin kualitas dan kompatibilitas dengan platform OHTATS.
- Menjadi nilai tambah bagi pelanggan OHTATS.

### Komponen Resmi

Komponen resmi dapat mencakup:

- Official Expert Advisor (EA)
- Official Indicator
- Official Strategy
- Official Dashboard
- Official Risk Management
- Official Money Management
- Official AI Prompt Library
- Official Plugin
- Official Template
- Official Workflow

### Standar Kualitas

Setiap komponen resmi wajib melalui proses berikut sebelum dirilis:

1. Perancangan
2. Pengembangan
3. AI Review
4. Code Review
5. Backtest
6. Forward Test
7. Stress Test
8. Dokumentasi
9. Validasi
10. Official Release

### Sertifikasi

Komponen yang telah memenuhi seluruh standar akan memperoleh status:

**OHTATS Certified**

Status ini menunjukkan bahwa komponen telah melalui proses pengujian dan validasi sesuai standar kualitas OHTATS.

### Filosofi

OHTATS tidak hanya menyediakan platform, tetapi juga menyediakan kumpulan komponen resmi yang siap digunakan oleh pengguna dengan tingkat kualitas yang dapat dipertanggungjawabkan.

## 6. Cloud & Local First Philosophy

OHTATS dirancang dengan filosofi Cloud & Local First, yaitu platform yang dapat dijalankan baik secara lokal (Local Installation) maupun melalui layanan Cloud tanpa mengubah pengalaman penggunaan.

Pengguna memiliki kebebasan untuk menentukan model implementasi sesuai kebutuhan, kapasitas, maupun kebijakan organisasi.

Mode implementasi yang didukung meliputi:

- Local Installation (Windows, Linux, atau Server pribadi)
- Private Server (VPS atau Dedicated Server)
- Private Cloud
- Public Cloud
- Hybrid Deployment

Seluruh modul OHTATS dirancang agar tetap konsisten pada berbagai model implementasi melalui arsitektur yang modular dan independen terhadap lingkungan deployment.

Pendekatan ini memberikan fleksibilitas, meningkatkan kemandirian pengguna, serta mempermudah proses migrasi dari lingkungan lokal menuju cloud maupun sebaliknya.

## 7. Marketplace Philosophy

OHTATS menyediakan Marketplace sebagai pusat distribusi komponen yang dapat digunakan oleh seluruh pengguna platform.

Marketplace bukan hanya menyediakan Plugin, tetapi juga menjadi ekosistem distribusi berbagai aset digital yang mendukung aktivitas trading dan otomatisasi.

Komponen yang dapat tersedia di Marketplace antara lain:

- Trading Strategy
- Workflow
- Plugin
- AI Prompt
- AI Agent
- Dashboard Template
- Indicator
- Expert Advisor (EA)
- Script
- Template Konfigurasi
- Risk Profile
- Backtest Dataset
- Komponen lain yang mendukung pengembangan OHTATS.

Marketplace dirancang untuk mendukung distribusi resmi dari OHTATS maupun karya komunitas dan pengembang pihak ketiga dengan mekanisme validasi, versioning, serta pengelolaan lisensi yang terstruktur.

## 8. Workflow First Philosophy

Workflow merupakan pusat otomatisasi pada OHTATS.

Seluruh proses bisnis dapat diimplementasikan sebagai Workflow yang dapat disusun, dimodifikasi, dan dijalankan tanpa harus mengubah kode program inti.

Workflow dapat menghubungkan berbagai modul seperti AI, Trading Engine, Broker, Notification, Plugin, Scheduler, maupun layanan eksternal.

Pendekatan Workflow First memberikan keuntungan berupa:

- Fleksibilitas otomatisasi.
- Kemudahan pengembangan.
- Reusability Workflow.
- Integrasi antar modul.
- Kemudahan audit proses bisnis.

Dengan filosofi ini, sebagian besar logika bisnis dapat dikonfigurasi melalui Workflow sehingga platform menjadi lebih adaptif terhadap kebutuhan pengguna.

## 9. Automation First Philosophy

OHTATS dibangun dengan prinsip bahwa setiap proses yang dapat diotomatisasi sebaiknya dapat dijalankan secara otomatis.

Automation tidak hanya diterapkan pada aktivitas trading, tetapi juga pada pengelolaan sistem secara keseluruhan.

Contoh proses yang dapat diotomatisasi meliputi:

- Analisis pasar.
- Validasi risiko.
- Eksekusi trading.
- Sinkronisasi data broker.
- Monitoring posisi.
- Pengiriman notifikasi.
- Backup sistem.
- Pembaruan Plugin.
- Eksekusi Workflow.
- Monitoring kesehatan sistem.

Pengguna tetap memiliki kendali penuh untuk menentukan apakah suatu proses dijalankan secara manual, semi otomatis, atau otomatis penuh.

## 10. Security by Design

Keamanan merupakan bagian yang dirancang sejak awal pengembangan sistem, bukan ditambahkan setelah sistem selesai dibuat.

Seluruh modul OHTATS harus menerapkan prinsip Security by Design pada setiap proses pengembangan maupun implementasi.

Prinsip keamanan yang diterapkan meliputi:

- Authentication.
- Authorization.
- Encryption.
- Secure API.
- Audit Logging.
- Least Privilege.
- Secure Secret Management.
- Secure Communication.
- Data Integrity.
- Backup & Recovery.

Pendekatan ini memastikan keamanan menjadi fondasi utama seluruh komponen platform.

## 11. Data Ownership Philosophy

Seluruh data yang dihasilkan pengguna tetap menjadi milik pengguna.

OHTATS hanya menyediakan platform untuk menyimpan, mengelola, dan memproses data sesuai hak akses yang diberikan.

Pengguna memiliki hak untuk:

- Mengekspor data.
- Menghapus data.
- Memindahkan data.
- Melakukan Backup.
- Melakukan Restore.
- Mengatur lokasi penyimpanan data.

Filosofi ini mendukung transparansi, portabilitas data, serta mengurangi ketergantungan terhadap penyedia layanan tertentu.

## 12. Scalability Philosophy

Seluruh komponen OHTATS dirancang agar mampu berkembang secara bertahap sesuai kebutuhan pengguna.

Arsitektur sistem mendukung peningkatan kapasitas tanpa harus mengubah fondasi platform.

Scalability diterapkan pada berbagai aspek, antara lain:

- Jumlah pengguna.
- Jumlah Trading Account.
- Jumlah Broker.
- Jumlah AI Provider.
- Jumlah Workflow.
- Jumlah Plugin.
- Volume transaksi.
- Kapasitas penyimpanan.
- Infrastruktur deployment.

Pendekatan ini memastikan OHTATS dapat digunakan mulai dari pengguna individu hingga organisasi berskala besar.

## 13. Future Ready Philosophy

OHTATS dirancang sebagai platform yang siap menghadapi perkembangan teknologi di masa depan.

Seluruh desain sistem mengutamakan fleksibilitas, modularitas, interoperabilitas, dan kemudahan integrasi sehingga platform dapat beradaptasi terhadap inovasi baru tanpa memerlukan perubahan mendasar pada arsitektur inti.

Pengembangan OHTATS akan selalu mempertimbangkan kompatibilitas terhadap teknologi baru, termasuk Artificial Intelligence, Trading Platform, Cloud Computing, Internet of Things (IoT), Edge Computing, Blockchain, maupun teknologi lain yang relevan.

Dengan filosofi ini, OHTATS diharapkan tetap menjadi platform yang relevan, berkelanjutan, dan mudah dikembangkan dalam jangka panjang.

## 14. Transparency & Auditability

### Prinsip

Setiap keputusan, analisis, rekomendasi, dan proses otomatis yang dilakukan oleh OHTATS harus dapat ditelusuri, dijelaskan, dan diaudit sesuai dengan hak akses pengguna.

Transparansi merupakan fondasi utama untuk membangun kepercayaan terhadap sistem berbasis AI.

### Tujuan

- Memberikan kejelasan terhadap setiap keputusan sistem.
- Mempermudah proses audit dan investigasi.
- Meningkatkan kepercayaan pengguna.
- Mendukung kebutuhan kepatuhan (compliance) dan tata kelola.

### Implementasi

OHTATS menyediakan mekanisme audit yang mencatat aktivitas penting, antara lain:

- Login dan autentikasi.
- Perubahan konfigurasi.
- Aktivitas AI.
- Perubahan workflow.
- Eksekusi trading.
- Aktivitas plugin.
- Aktivitas provider.
- Perubahan data penting.
- Aktivitas administrator.

Seluruh log disimpan dengan mekanisme yang aman dan dapat ditelusuri sesuai kebijakan retensi data.

### Filosofi

Keputusan yang tidak dapat dijelaskan akan sulit dipercaya.

OHTATS mengutamakan transparansi sehingga pengguna dapat memahami bagaimana suatu keputusan dihasilkan.

### Prinsip Audit

Audit dalam OHTATS harus memenuhi karakteristik berikut:

- Akurat.
- Konsisten.
- Dapat ditelusuri.
- Tidak mudah dimanipulasi.
- Memiliki jejak waktu (timestamp).
- Mendukung kebutuhan forensik apabila diperlukan.

## 15. Quality Before Release

### Prinsip

Seluruh komponen OHTATS harus memenuhi standar kualitas yang telah ditetapkan sebelum dirilis kepada pengguna.

Tidak ada fitur, plugin, workflow, EA, indikator, maupun integrasi yang boleh dirilis tanpa melalui proses validasi yang sesuai.

### Tujuan

- Menjamin kualitas produk.
- Mengurangi risiko bug dan kesalahan.
- Meningkatkan kepercayaan pengguna.
- Menjaga reputasi platform OHTATS.

### Implementasi

Sebelum dirilis, setiap komponen harus melalui tahapan berikut:

1. Perencanaan
2. Analisis Kebutuhan
3. Desain
4. Implementasi
5. Code Review
6. AI Review (bila digunakan)
7. Unit Testing
8. Integration Testing
9. System Testing
10. Performance Testing (jika diperlukan)
11. Security Review
12. Dokumentasi
13. Validasi
14. Approval
15. Official Release

### Kriteria Rilis

Sebuah komponen dinyatakan layak dirilis apabila:

- Lulus seluruh pengujian yang diwajibkan.
- Memiliki dokumentasi yang lengkap.
- Tidak memiliki bug kritis.
- Memenuhi standar keamanan.
- Memenuhi standar performa yang ditetapkan.
- Telah memperoleh persetujuan sesuai proses pengembangan.

### Filosofi

Lebih baik menunda rilis daripada merilis produk yang belum memenuhi standar kualitas.

Kualitas merupakan investasi jangka panjang bagi keberhasilan OHTATS.

### Continuous Improvement

Setelah dirilis, setiap komponen tetap dipantau, dievaluasi, dan disempurnakan berdasarkan:

- Bug Report
- Feedback Pengguna
- Hasil Monitoring
- Perubahan Teknologi
- Perubahan Regulasi
- Kebutuhan Bisnis