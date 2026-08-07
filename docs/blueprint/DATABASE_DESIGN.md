# DATABASE_DESIGN.md

# OHTATS Database Design

> Dokumen ini menjelaskan rancangan database untuk platform **OH-TRADER AI Trading System (OHTATS)**.

Database dirancang sebagai fondasi utama platform agar mampu mendukung:

- operasi trading multi-platform,
- integrasi berbagai AI Provider,
- Workflow Automation,
- Plugin System,
- Audit dan Logging,
- Backtesting,
- Copy Trading,
- skalabilitas enterprise,
- serta pengembangan fitur di masa depan.

Dokumen ini menjadi acuan resmi implementasi database OHTATS.
---

# 1. Tujuan

Database OHTATS dirancang untuk menyimpan seluruh informasi yang diperlukan oleh sistem secara konsisten, aman, dan mudah dikembangkan.

Database harus mampu mendukung:

- Multi User
- Multi Broker
- Multi Trading Account
- Multi Platform (MT4, MT5, TradingView)
- Multi AI Provider
- Multi Workflow
- Plugin System
- Audit Trail
- Logging
- Notification
- Backtesting
- Copy Trading
- Scalability
- Security
- High Availability

---

# 2. Prinsip Desain

Database OHTATS dibangun berdasarkan prinsip:

- Modular Architecture
- Data Normalization (hingga minimal Third Normal Form/3NF)
- Scalability
- Maintainability
- Auditability
- Security by Design
- Performance Optimization
- Backup & Recovery
- High Availability Ready
- Extensibility
- Menghindari duplikasi data.

---

# 3. Domain Data

Domain utama OHTATS meliputi:

- User Management
- Security
- Trading
- Broker Integration
- AI Engine
- Strategy
- Risk Management
- Workflow Engine
- Plugin System
- Notification
- Audit & Logging
- Configuration
- Licensing
- Subscription
- External Integration
- API Management
- Backup & Recovery
- Scheduler & Job Queue
- Market Data
- Backtesting
- Copy Trading

---

# 4. Entitas Utama (Core Business Entities)

Berdasarkan domain sistem yang telah ditentukan, OHTATS memiliki entitas bisnis utama (Core Business Entities) sebagai fondasi seluruh proses operasional platform.

Entitas-entitas ini menggambarkan objek bisnis utama yang akan direpresentasikan ke dalam satu atau lebih tabel pada desain database.

---

## 4.1 User

Mewakili pengguna sistem OHTATS.

Setiap pengguna memiliki identitas unik dan hak akses sesuai Role (Peran) yang dimilikinya.

Seorang User dapat memiliki:

- Satu atau lebih Trading Account
- Satu atau lebih Strategy
- AI Session
- Plugin
- License
- Subscription
- Notification
- Riwayat aktivitas pada Audit Log

---

## 4.2 Trading Account

Mewakili akun trading yang terhubung ke OHTATS.

Satu User dapat memiliki lebih dari satu Trading Account yang berasal dari broker yang sama maupun broker yang berbeda.

Trading Account menjadi pusat seluruh aktivitas trading pada sistem.

---

## 4.3 Broker

Mewakili broker atau penyedia layanan trading yang digunakan oleh pengguna.

Contoh:

- MetaTrader Broker
- Broker API
- Crypto Exchange
- Futures Broker

Broker menyediakan akses terhadap:

- Order
- Position
- Deal
- Market Data
- Informasi Akun Trading

---

## 4.4 Strategy

Mewakili strategi trading yang digunakan untuk mengambil keputusan transaksi.

Satu Strategy dapat digunakan oleh satu atau lebih Trading Account sesuai konfigurasi pengguna.

Strategy dapat dijalankan:

- Secara Manual
- Menggunakan Expert Advisor (EA)
- Menggunakan Workflow
- Menggunakan AI Engine

---

## 4.5 Trade

Trade merupakan aktivitas perdagangan (Trading Activity) secara konseptual.

Pada implementasi database OHTATS, Trade direpresentasikan melalui beberapa entitas yang saling berhubungan, yaitu:

- Orders
- Positions
- Deals

Pendekatan ini dipilih agar sistem mampu mendukung berbagai platform trading seperti MT4, MT5, Broker API, maupun integrasi platform lain di masa mendatang.

Setiap Trade selalu berhubungan dengan:

- Trading Account
- Broker
- Strategy
- Risk Management
- Symbol

---

### 4.5.1 Trading Symbol

Mewakili instrumen atau aset yang diperdagangkan.

Contoh:

- EURUSD
- GBPUSD
- USDJPY
- XAUUSD
- BTCUSD
- ETHUSD
- NAS100
- US30

Setiap aktivitas Trade selalu mengacu pada satu Symbol.

---

## 4.6 Position

Mewakili posisi trading yang sedang berjalan maupun yang telah ditutup.

Position merupakan hasil dari eksekusi Order dan menjadi dasar perhitungan:

- Floating Profit/Loss
- Swap
- Commission
- Risk Monitoring

---

## 4.7 AI Session

Menyimpan riwayat interaksi antara pengguna dengan AI Provider.

AI Session digunakan untuk:

- Analisis Market
- Konsultasi Strategy
- Evaluasi Trading
- Pengambilan Keputusan berbasis AI
- Aktivitas AI lainnya

---

## 4.8 Backtest

Menyimpan hasil pengujian Strategy menggunakan data historis.

Backtest digunakan untuk mengevaluasi performa Strategy sebelum digunakan pada akun trading nyata.

---

## 4.9 Plugin

Mewakili modul atau komponen tambahan yang dapat dipasang pada OHTATS untuk memperluas fungsionalitas sistem tanpa mengubah inti aplikasi.

---

## 4.10 Notification

Menyimpan seluruh riwayat notifikasi yang dikirimkan kepada pengguna.

Notifikasi dapat berasal dari:

- AI Engine
- Trading Engine
- Workflow
- System
- Plugin

---

## 4.11 Audit Log

Menyimpan seluruh aktivitas penting yang terjadi di dalam sistem.

Audit Log digunakan untuk:

- Audit Keamanan
- Pelacakan Aktivitas
- Troubleshooting
- Compliance
- Investigasi

---

## 4.12 System Configuration

Menyimpan seluruh konfigurasi global sistem yang dapat dikelola oleh Administrator.

Konfigurasi ini menjadi dasar pengaturan berbagai modul OHTATS, termasuk:

- AI Engine
- Trading Engine
- Workflow
- Plugin
- Notification
- Security
- Fitur Sistem lainnya

# 5. Hubungan Antar Entitas (Entity Relationships)

Hubungan antar entitas dirancang untuk menjaga integritas data, menghindari duplikasi data, serta memastikan seluruh modul OHTATS dapat saling berinteraksi secara konsisten.

Hubungan antar entitas pada dokumen ini menggambarkan hubungan konseptual antar objek bisnis. Implementasi teknis hubungan tersebut dijelaskan lebih rinci pada bagian desain tabel dan ERD.

---

## 5.1 User

Satu User dapat memiliki:

- Banyak Trading Account
- Banyak Strategy
- Banyak AI Session
- Banyak Backtest
- Banyak Notification
- Banyak API Key
- Banyak License
- Banyak Audit Log

Relasi:

```
User (1) -------- (N) Trading Account
User (1) -------- (N) Strategy
User (1) -------- (N) AI Session
User (1) -------- (N) Backtest
User (1) -------- (N) Notification
User (1) -------- (N) API Key
User (1) -------- (N) License
User (1) -------- (N) Audit Log
```

---

## 5.2 Trading Account

Satu Trading Account:

- Dimiliki oleh satu User.
- Terhubung ke satu Broker.
- Memiliki banyak Order.
- Memiliki banyak Position.
- Memiliki banyak Deal.

Relasi:

```
Trading Account (N) -------- (1) Broker
Trading Account (N) -------- (1) User
Trading Account (1) -------- (N) Orders
Trading Account (1) -------- (N) Positions
Trading Account (1) -------- (N) Deals
```

---

## 5.3 Broker

Satu Broker dapat digunakan oleh banyak Trading Account.

Relasi:

```
Broker (1) -------- (N) Trading Account
```

---

## 5.4 Strategy

Satu Strategy dapat digunakan oleh:

- Banyak Order
- Banyak Position
- Banyak Deal
- Banyak Backtest

Relasi:

```
Strategy (1) -------- (N) Orders
Strategy (1) -------- (N) Positions
Strategy (1) -------- (N) Deals
Strategy (1) -------- (N) Backtest
```

---

## 5.5 Trading Symbol

Satu Trading Symbol dapat digunakan oleh:

- Banyak Order
- Banyak Position
- Banyak Deal

Relasi:

```
Trading Symbol (1) -------- (N) Orders
Trading Symbol (1) -------- (N) Positions
Trading Symbol (1) -------- (N) Deals
```

---

## 5.6 Orders

Setiap Order:

- Berasal dari satu Trading Account.
- Menggunakan satu Strategy.
- Mengacu pada satu Trading Symbol.
- Dapat menghasilkan satu Position.

Relasi:

```
Trading Account (1) -------- (N) Orders
Strategy (1) -------- (N) Orders
Trading Symbol (1) -------- (N) Orders
Orders (1) -------- (0..1) Positions
```

---

## 5.7 Positions

Setiap Position:

- Berasal dari satu Order (jika ada).
- Dimiliki oleh satu Trading Account.
- Menggunakan satu Strategy.
- Menggunakan satu Trading Symbol.
- Dapat menghasilkan satu atau lebih Deal.

Relasi:

```
Orders (1) -------- (0..1) Positions
Trading Account (1) -------- (N) Positions
Strategy (1) -------- (N) Positions
Trading Symbol (1) -------- (N) Positions
Positions (1) -------- (N) Deals
```

---

## 5.8 Deals

Setiap Deal:

- Berasal dari satu Position.
- Dimiliki oleh satu Trading Account.
- Menggunakan satu Trading Symbol.

Relasi:

```
Positions (1) -------- (N) Deals
Trading Account (1) -------- (N) Deals
Trading Symbol (1) -------- (N) Deals
```

---

## 5.9 AI Session

Satu AI Session dimiliki oleh satu User.

Relasi:

```
User (1) -------- (N) AI Session
```

---

## 5.10 Backtest

Satu Backtest menggunakan satu Strategy.

Relasi:

```
Strategy (1) -------- (N) Backtest
```

---

## 5.11 Plugin

Plugin dapat memiliki banyak Plugin Version.

Setiap Plugin Version dapat dipasang pada banyak instalasi.

Relasi:

```
Plugin (1) -------- (N) Plugin Version

Plugin Version (1) -------- (N) Plugin Installation
```

---

## 5.12 Workflow

Workflow dapat memiliki banyak Workflow Version.

Setiap Workflow Version dapat dijalankan berkali-kali melalui Workflow Execution.

Relasi:

```
Workflow (1) -------- (N) Workflow Version

Workflow Version (1) -------- (N) Workflow Execution
```

---

## 5.13 License

Satu Subscription Plan dapat dimiliki oleh banyak License.

Relasi:

```
Subscription Plan (1) -------- (N) License
```

---

## 5.14 Notification

Notification dikirim kepada satu User.

Relasi:

```
User (1) -------- (N) Notification
```

---

## 5.15 Audit Log

Audit Log mencatat seluruh aktivitas yang dilakukan oleh User maupun sistem.

Relasi:

```
User (1) -------- (N) Audit Log
```

## 6.2 Tabel Brokers

### Tujuan

Menyimpan informasi seluruh broker, exchange, maupun platform trading yang didukung oleh OHTATS.

Tabel ini menjadi fondasi integrasi **Multi Platform**, sehingga sistem dapat terhubung dengan berbagai penyedia layanan trading tanpa bergantung pada satu vendor tertentu.

Broker yang dapat didukung antara lain:

- MetaTrader 4
- MetaTrader 5
- TradingView
- Binance
- Bybit
- OKX
- Interactive Brokers
- Broker Forex lainnya
- Crypto Exchange
- Platform tambahan melalui Plugin

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| broker_code | VARCHAR(30) | Kode unik broker |
| broker_name | VARCHAR(100) | Nama broker |
| broker_type | ENUM(FOREX, CRYPTO, STOCK, FUTURES, CFD) | Jenis broker |
| platform | ENUM(MT4, MT5, TRADINGVIEW, API) | Platform trading |
| country | VARCHAR(100) | Negara asal broker |
| server_name | VARCHAR(150) | Nama server broker |
| website | VARCHAR(255) | Website resmi broker |
| broker_logo | VARCHAR(255) | Lokasi file logo broker |
| api_supported | BOOLEAN | Mendukung API |
| api_version | VARCHAR(50) | Versi API |
| websocket_supported | BOOLEAN | Mendukung WebSocket |
| plugin_required | BOOLEAN | Membutuhkan Plugin Integration |
| status | ENUM(ACTIVE, INACTIVE) | Status broker |
| notes | TEXT | Catatan tambahan |
| description | TEXT | Deskripsi broker |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- broker_code harus unik.
- broker_name tidak boleh kosong.
- Kombinasi broker_name dan server_name harus unik.
- website bersifat opsional.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Broker dapat memiliki banyak Trading Account.
- Satu Broker dapat digunakan oleh banyak Strategy.
- Satu Broker dapat mendukung banyak Trading Symbol.
- Digunakan oleh modul Multi Platform.

---

### Index

- PK(id)
- UNIQUE(broker_code)
- UNIQUE(broker_name, server_name)
- INDEX(platform)
- INDEX(status)

---

### Catatan

Tabel Brokers merupakan pusat integrasi seluruh platform trading yang didukung OHTATS.

Seluruh koneksi menuju MT4, MT5, TradingView, Broker API, maupun platform tambahan melalui Plugin harus mengacu pada tabel ini.

---

### Future Development

Pada versi berikutnya tabel ini dapat dikembangkan untuk mendukung:

- FIX API
- REST API Configuration
- WebSocket Configuration
- Broker Health Monitoring
- Auto Discovery Broker Server
- Broker Performance Analytics

## 6.3 Tabel Trading Accounts

### Tujuan

Menyimpan informasi seluruh akun trading yang dimiliki oleh pengguna.

Trading Account menjadi penghubung utama antara User dengan Broker serta menjadi pusat seluruh aktivitas trading pada OHTATS.

Digunakan oleh:

- Trading Engine
- AI Engine
- Workflow Engine
- Backtest
- Copy Trading
- Risk Management
- Dashboard
- Multi Platform Integration

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| user_id | UUID | Pemilik akun |
| broker_id | UUID | Broker yang digunakan |
| account_number | VARCHAR(100) | Nomor akun trading |
| account_name | VARCHAR(100) | Nama akun |
| account_type | ENUM(DEMO, REAL) | Jenis akun |
| platform | ENUM(MT4, MT5, TRADINGVIEW, API) | Platform trading |
| server | VARCHAR(150) | Nama server broker |
| currency | VARCHAR(10) | Mata uang akun |
| leverage | VARCHAR(20) | Leverage akun |
| balance | DECIMAL(18,2) | Saldo terakhir |
| equity | DECIMAL(18,2) | Equity |
| margin | DECIMAL(18,2) | Margin digunakan |
| free_margin | DECIMAL(18,2) | Margin bebas |
| status | ENUM(ACTIVE, DISABLED) | Status akun |
| is_default | BOOLEAN | Akun utama |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- user_id wajib mengacu ke tabel Users.
- broker_id wajib mengacu ke tabel Brokers.
- account_number harus unik dalam satu Broker.
- account_type hanya boleh DEMO atau REAL.
- platform mengikuti platform yang didukung Broker.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Banyak Trading Account dimiliki oleh satu User.
- Banyak Trading Account menggunakan satu Broker.
- Satu Trading Account memiliki banyak Orders.
- Satu Trading Account memiliki banyak Positions.
- Satu Trading Account memiliki banyak Deals.

---

### Index

- PK(id)
- INDEX(user_id)
- INDEX(broker_id)
- UNIQUE(broker_id, account_number)
- INDEX(status)

---

### Catatan

Trading Account merupakan identitas akun trading yang dihubungkan ke MT4, MT5, TradingView, maupun Broker API.

Seluruh aktivitas trading pada OHTATS selalu mengacu pada Trading Account.

---

### Future Development

- Multi Currency Account
- Hedging Account
- Netting Account
- Portfolio Account
- Account Synchronization
- Auto Reconnect

## 6.4 Tabel Strategy

### Tujuan

Menyimpan seluruh konfigurasi strategi trading yang digunakan oleh OHTATS.

Strategy menjadi pusat pengambilan keputusan bagi AI Engine, Trading Engine, Workflow, Backtest, Risk Management, dan Copy Trading.

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| strategy_code | VARCHAR(50) | Kode unik strategi |
| strategy_name | VARCHAR(150) | Nama strategi |
| description | TEXT | Deskripsi strategi |
| category | VARCHAR(100) | Kategori strategi |
| market_type | ENUM(FOREX, CRYPTO, STOCK, FUTURES, CFD) | Jenis pasar |
| timeframe | VARCHAR(20) | Timeframe |
| symbol_id | UUID | Referensi ke Trading Symbol |
| broker_id | UUID | Broker yang direkomendasikan |
| risk_level | ENUM(LOW, MEDIUM, HIGH) | Tingkat risiko |
| max_open_trade | INTEGER | Maksimum posisi terbuka |
| stop_loss | DECIMAL(18,2) | Default Stop Loss |
| take_profit | DECIMAL(18,2) | Default Take Profit |
| trailing_stop | BOOLEAN | Menggunakan trailing stop |
| ai_enabled | BOOLEAN | Menggunakan AI |
| backtest_ready | BOOLEAN | Siap untuk Backtest |
| copy_trade_ready | BOOLEAN | Siap untuk Copy Trading |
| status | ENUM(DRAFT, ACTIVE, ARCHIVED) | Status strategi |
| version | VARCHAR(20) | Semantic Version |
| created_by | UUID | Pembuat strategi |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- strategy_code harus unik.
- strategy_name tidak boleh kosong.
- symbol_id wajib mengacu ke tabel Trading Symbols.
- broker_id wajib mengacu ke tabel Brokers.
- created_by wajib mengacu ke tabel Users.
- risk_level hanya boleh LOW, MEDIUM, atau HIGH.
- max_open_trade minimal bernilai 1.
- stop_loss dan take_profit tidak boleh bernilai negatif.
- status hanya boleh DRAFT, ACTIVE, atau ARCHIVED.
- version mengikuti Semantic Versioning.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu User dapat memiliki banyak Strategy.
- Satu Broker dapat digunakan oleh banyak Strategy.
- Satu Trading Symbol dapat digunakan oleh banyak Strategy.
- Satu Strategy dapat digunakan oleh banyak Orders.
- Satu Strategy dapat digunakan oleh banyak Positions.
- Satu Strategy dapat digunakan oleh banyak Deals.
- Satu Strategy dapat digunakan oleh banyak Backtest.
- Satu Strategy dapat digunakan oleh AI Engine.
- Satu Strategy dapat digunakan oleh Copy Trading.

---

### Index

- PK(id)
- UNIQUE(strategy_code)
- INDEX(strategy_name)
- INDEX(symbol_id)
- INDEX(broker_id)
- INDEX(status)

---

### Catatan

Strategy merupakan inti dari sistem OHTATS.

Seluruh proses AI, Backtest, Trading Automation, Workflow Engine, Copy Trading, Risk Management, dan Analytics menggunakan Strategy sebagai pusat pengambilan keputusan.

Desain Strategy dibuat fleksibel agar mampu mendukung berbagai metode trading saat ini maupun yang akan datang.

---

### Future Development

- Strategy Marketplace
- Strategy Rating
- Strategy Version Control
- AI Strategy Optimization
- Strategy Performance Analytics
- Auto Strategy Deployment

## 6.5 Tabel Trading Symbols

### Tujuan

Menyimpan seluruh simbol atau instrumen trading yang didukung oleh OHTATS.

Tabel ini menjadi referensi utama bagi seluruh aktivitas trading sehingga seluruh modul menggunakan data simbol yang konsisten dan terhindar dari duplikasi.

Digunakan oleh:

- Trading Engine
- AI Engine
- Workflow Engine
- Backtest
- Copy Trading
- Dashboard
- Multi Platform Integration

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| symbol_code | VARCHAR(30) | Kode unik simbol |
| symbol_name | VARCHAR(100) | Nama simbol |
| market_type | ENUM(FOREX, CRYPTO, STOCK, FUTURES, CFD, INDEX, COMMODITY) | Jenis pasar |
| base_currency | VARCHAR(20) | Mata uang dasar |
| quote_currency | VARCHAR(20) | Mata uang pembanding |
| digits | INTEGER | Jumlah digit harga |
| tick_size | DECIMAL(18,8) | Ukuran tick |
| contract_size | DECIMAL(18,2) | Ukuran kontrak |
| minimum_lot | DECIMAL(10,2) | Lot minimum |
| maximum_lot | DECIMAL(10,2) | Lot maksimum |
| lot_step | DECIMAL(10,2) | Kelipatan lot |
| swap_supported | BOOLEAN | Mendukung swap |
| trading_session | VARCHAR(100) | Jadwal perdagangan |
| status | ENUM(ACTIVE, INACTIVE) | Status simbol |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- symbol_code harus unik.
- symbol_name tidak boleh kosong.
- minimum_lot tidak boleh lebih besar dari maximum_lot.
- lot_step harus lebih besar dari 0.
- digits minimal bernilai 0.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Trading Symbol dapat digunakan oleh banyak Strategy.
- Satu Trading Symbol dapat digunakan oleh banyak Orders.
- Satu Trading Symbol dapat digunakan oleh banyak Positions.
- Satu Trading Symbol dapat digunakan oleh banyak Deals.
- Satu Trading Symbol dapat digunakan oleh banyak Backtest.

---

### Index

- PK(id)
- UNIQUE(symbol_code)
- INDEX(symbol_name)
- INDEX(market_type)
- INDEX(status)

---

### Catatan

Seluruh modul trading di OHTATS wajib menggunakan referensi dari tabel Trading Symbols agar seluruh data instrumen tetap konsisten.

---

### Future Development

- Dynamic Symbol Synchronization
- Market Session Calendar
- Trading Hours Exception
- Corporate Action Support
- Symbol Category Management
- Symbol Performance Analytics

## 6.6 Tabel Orders

### Tujuan

Menyimpan seluruh instruksi trading yang dikirim ke broker.

Tabel Orders menjadi titik awal proses trading pada OHTATS dan berfungsi sebagai penghubung antara Trading Account, Strategy, Trading Symbol, Position, serta Broker.

Digunakan oleh:

- Trading Engine
- AI Engine
- Workflow Engine
- Risk Management
- Dashboard
- Multi Platform Integration
- Audit System

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Account |
| position_id | UUID | Relasi ke Position (nullable) |
| strategy_id | UUID | Relasi ke Strategy (nullable) |
| symbol_id | UUID | Relasi ke Trading Symbols |
| broker_order_id | VARCHAR(100) | ID Order dari Broker |
| order_type | ENUM(MARKET, LIMIT, STOP, STOP_LIMIT) | Jenis Order |
| side | ENUM(BUY, SELL) | Arah Order |
| volume | DECIMAL(18,8) | Volume Order |
| price | DECIMAL(18,8) | Harga Order |
| stop_loss | DECIMAL(18,8) | Stop Loss |
| take_profit | DECIMAL(18,8) | Take Profit |
| status | ENUM(PENDING, PARTIALLY_FILLED, FILLED, CANCELLED, EXPIRED, REJECTED) | Status Order |
| placed_at | DATETIME | Waktu Order dibuat |
| executed_at | DATETIME | Waktu Order dieksekusi |
| cancelled_at | DATETIME | Waktu Order dibatalkan |
| expiration_at | DATETIME | Waktu kedaluwarsa |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- account_id wajib mengacu ke tabel Trading Accounts.
- position_id mengacu ke tabel Positions (opsional).
- strategy_id mengacu ke tabel Strategy (opsional).
- symbol_id wajib mengacu ke tabel Trading Symbols.
- broker_order_id harus unik dalam satu Trading Account.
- volume harus lebih besar dari 0.
- status hanya boleh menggunakan nilai ENUM yang telah ditentukan.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Trading Account memiliki banyak Order.
- Banyak Order dapat membentuk satu Position.
- Satu Strategy dapat digunakan oleh banyak Order.
- Satu Trading Symbol dapat digunakan oleh banyak Order.
- AI Analysis dapat menghasilkan rekomendasi Order.
- Seluruh Order divalidasi oleh Risk Management.
- Seluruh aktivitas Order dicatat pada Audit Log.

---

### Index

- PK(id)
- INDEX(account_id)
- INDEX(position_id)
- INDEX(strategy_id)
- INDEX(symbol_id)
- UNIQUE(account_id, broker_order_id)
- INDEX(status)
- INDEX(created_at)

---

### Catatan

Order merupakan instruksi trading yang dikirim ke broker.

Tidak semua Order akan menghasilkan Position.

Order dapat dibuat secara manual, oleh Expert Advisor (EA), AI Engine, maupun Workflow Engine.

---

### Future Development

- Advanced Order Routing
- Smart Order Management
- Partial Fill Optimization
- Multi Broker Order Synchronization
- Order Replay
- Order Performance Analytics

## 6.7 Tabel Positions

### Tujuan

Menyimpan seluruh posisi trading yang sedang berjalan maupun yang telah ditutup.

Tabel Positions menjadi pusat monitoring posisi trading dan digunakan oleh AI Engine, Risk Management, Dashboard, Workflow Engine, serta Analytics.

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Account |
| strategy_id | UUID | Relasi ke Strategy (nullable) |
| symbol_id | UUID | Relasi ke Trading Symbols |
| broker_position_id | VARCHAR(100) | ID Position dari Broker |
| position_type | ENUM(BUY, SELL) | Jenis Position |
| volume | DECIMAL(18,8) | Volume Position |
| open_price | DECIMAL(18,8) | Harga pembukaan |
| current_price | DECIMAL(18,8) | Harga saat ini |
| stop_loss | DECIMAL(18,8) | Stop Loss |
| take_profit | DECIMAL(18,8) | Take Profit |
| unrealized_profit | DECIMAL(18,2) | Floating Profit/Loss |
| swap | DECIMAL(18,2) | Swap |
| commission | DECIMAL(18,2) | Komisi |
| status | ENUM(OPEN, PARTIALLY_CLOSED, CLOSED) | Status Position |
| opened_at | DATETIME | Waktu pembukaan |
| closed_at | DATETIME | Waktu penutupan |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- account_id wajib mengacu ke tabel Trading Accounts.
- strategy_id mengacu ke tabel Strategy (opsional).
- symbol_id wajib mengacu ke tabel Trading Symbols.
- broker_position_id harus unik dalam satu Trading Account.
- volume harus lebih besar dari 0.
- opened_at wajib diisi.
- closed_at hanya boleh diisi jika status = CLOSED atau PARTIALLY_CLOSED.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Trading Account memiliki banyak Position.
- Satu Strategy dapat digunakan oleh banyak Position.
- Satu Trading Symbol dapat digunakan oleh banyak Position.
- Satu Position dapat terbentuk dari satu atau lebih Order.
- Satu Position dapat memiliki banyak Deal.
- Satu Position dapat memiliki banyak AI Analysis.
- Satu Position mengikuti aturan Risk Management.
- Satu Position memiliki satu Trading Journal.
- Seluruh aktivitas Position dicatat pada Audit Log.

---

### Index

- PK(id)
- INDEX(account_id)
- INDEX(strategy_id)
- INDEX(symbol_id)
- UNIQUE(account_id, broker_position_id)
- INDEX(status)
- INDEX(opened_at)

---

### Catatan

Position merepresentasikan posisi trading yang aktif maupun yang telah ditutup.

Selama Position masih terbuka, nilai `current_price` dan `unrealized_profit` akan diperbarui secara berkala.

Position dapat dibuka secara manual, oleh Expert Advisor (EA), AI Engine, maupun Workflow Engine.

---

### Future Development

- Netting Position Support
- Hedging Position Support
- Position Snapshot
- Position Synchronization
- Multi Broker Position Aggregation
- Position Performance Analytics

## 6.8 Tabel Deals

### Tujuan

Menyimpan setiap hasil eksekusi trading yang telah dikonfirmasi oleh broker.

Tabel Deals merupakan catatan permanen seluruh transaksi yang telah dieksekusi dan menjadi sumber utama perhitungan Realized Profit/Loss, Audit, Trading History, serta Performance Analytics.

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| order_id | UUID | Relasi ke Orders |
| position_id | UUID | Relasi ke Positions |
| account_id | UUID | Relasi ke Trading Account |
| symbol_id | UUID | Relasi ke Trading Symbols |
| broker_deal_id | VARCHAR(100) | ID Deal dari Broker |
| side | ENUM(BUY, SELL) | Arah transaksi |
| volume | DECIMAL(18,8) | Volume yang dieksekusi |
| execution_price | DECIMAL(18,8) | Harga eksekusi |
| realized_profit | DECIMAL(18,2) | Profit/Loss yang direalisasikan |
| commission | DECIMAL(18,2) | Komisi |
| swap | DECIMAL(18,2) | Swap |
| fee | DECIMAL(18,2) | Biaya tambahan |
| executed_at | DATETIME | Waktu eksekusi |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- order_id wajib mengacu ke tabel Orders.
- position_id wajib mengacu ke tabel Positions.
- account_id wajib mengacu ke tabel Trading Accounts.
- symbol_id wajib mengacu ke tabel Trading Symbols.
- broker_deal_id harus unik dalam satu Trading Account.
- volume harus lebih besar dari 0.
- execution_price harus lebih besar dari 0.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Order dapat menghasilkan satu atau lebih Deal.
- Satu Position dapat memiliki banyak Deal.
- Satu Trading Account memiliki banyak Deal.
- Satu Trading Symbol dapat digunakan oleh banyak Deal.
- Deal dapat direferensikan pada Trading Journal.
- Seluruh aktivitas Deal dicatat pada Audit Log.

---

### Index

- PK(id)
- INDEX(order_id)
- INDEX(position_id)
- INDEX(account_id)
- INDEX(symbol_id)
- UNIQUE(account_id, broker_deal_id)
- INDEX(executed_at)

---

### Catatan

Deals merupakan catatan permanen hasil eksekusi broker.

Nilai `realized_profit` hanya tersedia setelah transaksi benar-benar dieksekusi.

Deals menjadi sumber utama laporan transaksi, histori trading, rekonsiliasi broker, dan Performance Analytics.

---

### Future Development

- Multi Broker Deal Synchronization
- Deal Replay
- Commission Breakdown
- Liquidity Provider Tracking
- Slippage Analytics
- Execution Performance Analytics

## 6.9 Tabel Trading Journal

### Tujuan

Menyimpan jurnal, evaluasi, dan pembelajaran dari setiap aktivitas trading.

Trading Journal menjadi media dokumentasi alasan entry, exit, evaluasi AI, evaluasi pengguna, serta pembelajaran yang digunakan untuk meningkatkan kualitas Strategy dan AI Engine.

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Account |
| position_id | UUID | Relasi ke Positions |
| strategy_id | UUID | Relasi ke Strategy (nullable) |
| ai_analysis_id | UUID | Relasi ke AI Analysis (nullable) |
| entry_reason | TEXT | Alasan membuka posisi |
| exit_reason | TEXT | Alasan menutup posisi |
| market_condition | VARCHAR(100) | Kondisi pasar |
| emotion | VARCHAR(50) | Catatan psikologi trader (opsional) |
| ai_confidence | DECIMAL(5,2) | Tingkat keyakinan AI (%) |
| user_rating | SMALLINT | Penilaian pengguna (1–5) |
| lesson_learned | TEXT | Pelajaran yang diperoleh |
| notes | TEXT | Catatan tambahan |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- account_id wajib mengacu ke tabel Trading Accounts.
- position_id wajib mengacu ke tabel Positions.
- strategy_id mengacu ke tabel Strategy (opsional).
- ai_analysis_id mengacu ke tabel AI Analysis (opsional).
- user_rating hanya boleh bernilai 1 sampai 5.
- ai_confidence berada pada rentang 0.00 sampai 100.00.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Satu Trading Account memiliki banyak Trading Journal.
- Satu Position memiliki satu Trading Journal utama.
- Satu Strategy dapat digunakan oleh banyak Trading Journal.
- Satu AI Analysis dapat direferensikan oleh banyak Trading Journal.
- Seluruh perubahan Trading Journal dicatat pada Audit Log.

---

### Index

- PK(id)
- INDEX(account_id)
- INDEX(position_id)
- INDEX(strategy_id)
- INDEX(ai_analysis_id)
- INDEX(created_at)

---

### Catatan

Trading Journal dapat diisi secara manual oleh pengguna maupun secara otomatis oleh AI Engine atau Workflow Engine.

Data pada tabel ini menjadi dasar evaluasi performa Strategy, AI, serta pengembangan sistem pembelajaran OHTATS.

---

### Future Development

- AI Trading Review
- Screenshot Attachment
- Voice Note Journal
- Emotion Analytics
- Strategy Improvement Recommendation
- AI Learning Dataset

## 6.10 Tabel AI Analysis

### Tujuan

Menyimpan seluruh hasil analisis AI terhadap kondisi pasar sebagai dasar pengambilan keputusan trading, evaluasi strategi, Explainable AI (XAI), dan pembelajaran model AI.

Digunakan oleh:

- Trading Engine
- Workflow Engine
- Dashboard
- Trading Journal
- Backtest
- AI Evaluation

---

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|--------|------|------------|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Account (nullable) |
| strategy_id | UUID | Relasi ke Strategy (nullable) |
| provider_id | UUID | Relasi ke AI Provider |
| symbol_id | UUID | Relasi ke Trading Symbols |
| timeframe | VARCHAR(20) | Timeframe analisis |
| analysis_type | ENUM(PRE_TRADE, IN_TRADE, POST_TRADE, MARKET_SCAN) | Jenis analisis |
| recommendation | ENUM(BUY, SELL, HOLD, CLOSE, NONE) | Rekomendasi AI |
| confidence_score | DECIMAL(5,2) | Tingkat keyakinan (%) |
| summary | TEXT | Ringkasan hasil analisis |
| reasoning | TEXT | Penjelasan rekomendasi |
| input_tokens | INTEGER | Jumlah token input |
| output_tokens | INTEGER | Jumlah token output |
| response_time_ms | INTEGER | Waktu respons AI |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

---

### Constraint

- Primary Key menggunakan UUID.
- account_id mengacu ke Trading Accounts (opsional).
- strategy_id mengacu ke Strategy (opsional).
- provider_id wajib mengacu ke AI Providers.
- symbol_id wajib mengacu ke Trading Symbols.
- confidence_score berada pada rentang 0.00–100.00.
- response_time_ms tidak boleh bernilai negatif.
- Soft Delete menggunakan kolom `deleted_at`.

---

### Relasi

- Trading Account memiliki banyak AI Analysis.
- Strategy memiliki banyak AI Analysis.
- AI Provider memiliki banyak AI Analysis.
- Trading Symbol memiliki banyak AI Analysis.
- AI Analysis dapat digunakan oleh Trading Journal.
- AI Analysis dapat digunakan oleh Workflow.
- Aktivitas AI Analysis dicatat pada Audit Log.

---

### Index

- PK(id)
- INDEX(provider_id)
- INDEX(account_id)
- INDEX(strategy_id)
- INDEX(symbol_id)
- INDEX(timeframe)
- INDEX(analysis_type)
- INDEX(created_at)

---

### Catatan

AI Analysis dapat digunakan oleh berbagai modul OHTATS.

Kolom `reasoning` mendukung prinsip Explainable AI (XAI).

Informasi token bersifat opsional karena tidak semua AI Provider menyediakannya.

---

### Future Development

- Prompt Versioning
- AI Comparison
- Multi AI Consensus
- AI Cost Analytics
- AI Hallucination Detection
- AI Performance Benchmark

## 6.11 Tabel Workflows

### Tujuan

Menyimpan identitas dan metadata seluruh Workflow OHTATS yang digunakan untuk mengotomatisasi proses bisnis dan trading.

Workflow berfungsi sebagai master dan pusat konfigurasi otomatisasi sistem, sedangkan definisi dan riwayat versi Workflow disimpan pada tabel Workflow Versions.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| name | VARCHAR(150) | Nama Workflow |
| code | VARCHAR(100) | Kode unik Workflow |
| description | TEXT | Deskripsi Workflow |
| category | VARCHAR(100) | Kategori Workflow |
| status | ENUM(DRAFT,ACTIVE,INACTIVE,ARCHIVED) | Status Workflow |
| trigger_type | ENUM(MANUAL,SCHEDULE,EVENT,AI,API) | Jenis pemicu Workflow |
| is_official | BOOLEAN | Menandai Workflow resmi OHTATS |
| created_by | UUID | User pembuat Workflow |
| updated_by | UUID | User yang terakhir mengubah metadata Workflow |
| created_at | DATETIME | Waktu Workflow dibuat |
| updated_at | DATETIME | Waktu metadata Workflow diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- `code` harus unik.
- Foreign Key: `created_by → users.id`.
- Foreign Key: `updated_by → users.id`.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `trigger_type` hanya boleh menggunakan nilai yang telah ditentukan.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | Workflow dibuat dan dapat diperbarui oleh User |
| Workflow Versions | One to Many | Satu Workflow memiliki banyak Workflow Version |
| Workflow Executions | One to Many | Satu Workflow memiliki banyak Workflow Execution |
| Strategies | Konseptual | Workflow dapat menggunakan Strategy sebagai bagian dari proses |
| AI Analysis | Konseptual | Workflow dapat menggunakan hasil AI Analysis |
| Audit Logs | One to Many | Aktivitas penting Workflow dapat dicatat pada Audit Log |

### Catatan

- Workflow menyimpan identitas dan metadata Workflow.
- Definisi Workflow disimpan pada `Workflow Versions.definition`.
- Riwayat perubahan definisi Workflow disimpan pada tabel Workflow Versions.
- Setiap eksekusi Workflow harus mengacu pada Workflow Version yang digunakan saat eksekusi.
- Perubahan definisi Workflow tidak mengubah histori Workflow Execution yang telah terjadi.
- Workflow dapat berupa Workflow resmi OHTATS maupun Workflow yang dibuat oleh User.
- Metadata Workflow dapat diperbarui selama Workflow masih dikelola oleh sistem.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(code)`
- `INDEX(status)`
- `INDEX(category)`
- `INDEX(trigger_type)`
- `INDEX(created_by)`
- `INDEX(created_at)`

### Future Development

- Visual Workflow Builder
- Workflow Marketplace
- Workflow Template
- Workflow Simulation
- Workflow Sharing
- Workflow Validation Engine
- Workflow Dependency Management

## 6.12 Tabel Workflow Executions

### Tujuan

Menyimpan seluruh riwayat eksekusi Workflow OHTATS sebagai dasar monitoring, audit, debugging, troubleshooting, dan analisis performa.

Workflow Execution merepresentasikan satu proses eksekusi terhadap versi Workflow tertentu.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| workflow_id | UUID | Relasi ke Workflows |
| workflow_version_id | UUID | Relasi ke Workflow Versions yang dieksekusi |
| account_id | UUID | Relasi ke Trading Account (nullable) |
| strategy_id | UUID | Relasi ke Strategy (nullable) |
| ai_analysis_id | UUID | Relasi ke AI Analysis (nullable) |
| trigger_type | ENUM(MANUAL,SCHEDULE,EVENT,AI,API) | Pemicu Workflow |
| execution_status | ENUM(PENDING,RUNNING,SUCCESS,FAILED,CANCELLED) | Status eksekusi |
| started_at | DATETIME | Waktu eksekusi dimulai (nullable) |
| finished_at | DATETIME | Waktu eksekusi selesai (nullable) |
| duration_ms | INTEGER | Durasi eksekusi dalam milidetik (nullable) |
| error_message | TEXT | Pesan kesalahan (nullable) |
| execution_log | TEXT | Ringkasan proses eksekusi |
| created_at | DATETIME | Waktu record dibuat |
| updated_at | DATETIME | Waktu record diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `workflow_id → workflows.id`.
- Foreign Key: `workflow_version_id → workflow_versions.id`.
- Foreign Key: `account_id → trading_accounts.id` (nullable).
- Foreign Key: `strategy_id → strategies.id` (nullable).
- Foreign Key: `ai_analysis_id → ai_analysis.id` (nullable).
- `workflow_version_id` harus mengacu pada Workflow Version yang berasal dari `workflow_id` yang sama.
- `trigger_type` hanya boleh menggunakan nilai yang telah ditentukan.
- `execution_status` hanya boleh menggunakan nilai yang telah ditentukan.
- `duration_ms` tidak boleh bernilai negatif.
- `finished_at` tidak boleh lebih awal dari `started_at`.
- `duration_ms` harus merepresentasikan durasi antara `started_at` dan `finished_at` apabila keduanya tersedia.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Workflows | Many to One | Execution berasal dari satu Workflow |
| Workflow Versions | Many to One | Execution menggunakan satu Workflow Version tertentu |
| Trading Accounts | Many to One | Execution dapat terkait dengan Trading Account |
| Strategies | Many to One | Execution dapat menggunakan Strategy |
| AI Analysis | Many to One | Execution dapat menggunakan hasil AI Analysis |
| Audit Logs | One to Many | Aktivitas penting Workflow Execution dapat dicatat pada Audit Log |
| Job Queue | Konseptual | Workflow Execution dapat dijalankan melalui asynchronous Job |

### Catatan

- Satu Workflow Execution mewakili satu proses eksekusi Workflow.
- `workflow_version_id` mencatat versi Workflow yang benar-benar digunakan saat eksekusi.
- Workflow Execution tidak mengubah definisi Workflow maupun Workflow Version.
- Workflow Version yang telah digunakan tetap dapat ditelusuri meskipun Workflow telah memiliki versi yang lebih baru.
- Execution log digunakan untuk monitoring dan troubleshooting.
- Error detail dapat disimpan pada `error_message` apabila eksekusi gagal.
- Data Workflow Execution dapat digunakan untuk analisis performa dan reliability Workflow.

### Index yang Disarankan

- `PK(id)`
- `INDEX(workflow_id)`
- `INDEX(workflow_version_id)`
- `INDEX(account_id)`
- `INDEX(strategy_id)`
- `INDEX(ai_analysis_id)`
- `INDEX(execution_status)`
- `INDEX(started_at)`
- `INDEX(created_at)`

### Future Development

- Execution Replay
- Distributed Execution
- Queue Monitoring
- Performance Analytics
- Automatic Retry
- Workflow Timeline
- Execution Trace
- Execution Comparison

## 6.13 Tabel Workflow Versions

### Tujuan

Menyimpan seluruh riwayat versi Workflow OHTATS.

Workflow Version digunakan untuk:

- Menyimpan snapshot definisi Workflow.
- Mendukung version control.
- Mendukung rollback.
- Menyediakan histori perubahan Workflow.
- Mendukung audit dan reproducibility Workflow Execution.
- Memastikan Workflow Execution dapat ditelusuri ke definisi yang digunakan pada saat eksekusi.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| workflow_id | UUID | Relasi ke Workflows |
| version | VARCHAR(20) | Semantic Version |
| definition | JSON | Snapshot definisi Workflow |
| change_summary | TEXT | Ringkasan perubahan |
| is_current | BOOLEAN | Menandai versi aktif saat ini |
| created_by | UUID | User pembuat versi |
| created_at | DATETIME | Waktu versi dibuat |

### Constraint

- Primary Key: `id`.
- Foreign Key: `workflow_id → workflows.id`.
- Foreign Key: `created_by → users.id`.
- Kombinasi `(workflow_id, version)` harus unik.
- `version` harus mengikuti Semantic Versioning.
- Hanya satu Workflow Version yang dapat memiliki `is_current = TRUE` untuk setiap Workflow.
- `definition` wajib berisi snapshot definisi Workflow.
- Workflow Version bersifat immutable setelah dibuat.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Workflows | Many to One | Workflow Version merupakan versi dari satu Workflow |
| Users | Many to One | Workflow Version dibuat oleh satu User |
| Workflow Executions | One to Many | Satu Workflow Version dapat digunakan oleh banyak Workflow Execution |
| Audit Logs | One to Many | Aktivitas pembuatan dan perubahan status versi dapat dicatat pada Audit Log |

### Catatan

- Setiap perubahan pada definisi Workflow menghasilkan Workflow Version baru.
- `definition` menyimpan snapshot lengkap definisi Workflow pada versi tersebut.
- Workflow Version tidak boleh diubah setelah dibuat.
- Workflow Version tidak boleh dihapus secara langsung.
- `is_current = TRUE` menunjukkan versi aktif yang digunakan sebagai versi terkini Workflow.
- Workflow Execution menyimpan `workflow_version_id` agar eksekusi dapat direproduksi dan diaudit berdasarkan definisi yang benar-benar digunakan.
- Rollback dilakukan dengan memilih Workflow Version sebelumnya sebagai versi aktif baru, bukan dengan mengubah isi Workflow Version lama.
- Riwayat versi menjadi dasar audit dan version control Workflow.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(workflow_id, version)`
- `INDEX(workflow_id)`
- `INDEX(is_current)`
- `INDEX(created_by)`
- `INDEX(created_at)`

### Future Development

- Visual Version Diff
- Rollback Wizard
- Branch Workflow
- Merge Workflow
- Approval Workflow Version
- Version Comparison
- Version Integrity Verification
- Workflow Version Deployment

## 6.14 Tabel Plugins

### Tujuan

Menyimpan metadata seluruh Plugin yang tersedia pada platform OHTATS.

Plugins berfungsi sebagai pusat pengelolaan komponen tambahan OHTATS, baik yang dikembangkan oleh OHTATS maupun pihak ketiga.

Plugin mendukung:

- Ekstensi kemampuan platform.
- Integrasi dengan sistem eksternal.
- EA dan Indicator.
- Dashboard dan Utility.
- Komponen AI.
- Plugin Marketplace.
- Pengelolaan lifecycle Plugin.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| name | VARCHAR(150) | Nama Plugin |
| code | VARCHAR(100) | Kode unik Plugin |
| plugin_type | VARCHAR(50) | Jenis Plugin seperti Integration, EA, Indicator, Dashboard, AI, Utility, dan lainnya |
| category | VARCHAR(100) | Kategori Plugin |
| developer_name | VARCHAR(150) | Nama Developer atau Publisher |
| description | TEXT | Deskripsi Plugin |
| status | ENUM(DRAFT,ACTIVE,DISABLED,DEPRECATED) | Status Plugin |
| is_official | BOOLEAN | Menandai Plugin resmi OHTATS |
| homepage | VARCHAR(255) | Website resmi Plugin (nullable) |
| documentation_url | VARCHAR(255) | URL dokumentasi Plugin (nullable) |
| created_at | DATETIME | Waktu Plugin dibuat |
| updated_at | DATETIME | Waktu metadata Plugin diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- `code` harus unik.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `plugin_type` wajib menggunakan kategori Plugin yang didukung oleh sistem.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Plugin Versions | One to Many | Satu Plugin memiliki banyak Plugin Version |
| Plugin Installations | One to Many | Satu Plugin dapat dipasang pada banyak Trading Account |
| Audit Logs | One to Many | Aktivitas penting Plugin dapat dicatat pada Audit Log |

### Catatan

- Plugin dapat dikembangkan oleh OHTATS maupun pihak ketiga.
- Plugin merupakan metadata/master Plugin, sedangkan riwayat versi disimpan pada Plugin Versions.
- Plugin dapat dinonaktifkan tanpa menghapus metadata maupun riwayat versinya.
- `code` menjadi identitas unik Plugin di dalam platform.
- Plugin resmi OHTATS ditandai menggunakan `is_official = TRUE`.
- Status `DEPRECATED` digunakan untuk Plugin yang tidak lagi direkomendasikan tetapi masih perlu dipertahankan untuk kompatibilitas dan histori.
- Credential, API Key, Token, Secret, Password, dan data sensitif lainnya tidak boleh disimpan pada tabel Plugins.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(code)`
- `INDEX(plugin_type)`
- `INDEX(category)`
- `INDEX(developer_name)`
- `INDEX(status)`
- `INDEX(is_official)`
- `INDEX(created_at)`

### Future Development

- Plugin Marketplace
- Plugin Rating
- Plugin Review
- Dependency Management
- Plugin License Management
- Plugin Compatibility Management
- Automatic Plugin Update
- Plugin Security Verification

## 6.15 Tabel Plugin Versions

### Tujuan

Menyimpan seluruh riwayat versi Plugin OHTATS.

Plugin Versions digunakan untuk:

- Mengelola version control Plugin.
- Menyimpan paket Plugin berdasarkan versi.
- Mendukung rollback.
- Memastikan kompatibilitas Plugin.
- Memverifikasi integritas paket.
- Mendukung distribusi Plugin.
- Menyediakan histori versi untuk audit.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| plugin_id | UUID | Relasi ke Plugins |
| version | VARCHAR(20) | Semantic Version |
| release_notes | TEXT | Catatan perubahan versi |
| package_file | VARCHAR(255) | Referensi lokasi paket Plugin |
| checksum | VARCHAR(128) | Hash untuk verifikasi integritas paket |
| checksum_algorithm | ENUM(SHA256,SHA512) | Algoritma checksum |
| file_size | BIGINT | Ukuran paket dalam byte |
| minimum_ohtats_version | VARCHAR(20) | Minimum versi OHTATS yang didukung |
| is_current | BOOLEAN | Menandai versi aktif/terkini |
| released_at | DATETIME | Waktu versi dirilis |
| created_at | DATETIME | Waktu record versi dibuat |

### Constraint

- Primary Key: `id`.
- Foreign Key: `plugin_id → plugins.id`.
- Kombinasi `(plugin_id, version)` harus unik.
- `version` harus mengikuti Semantic Versioning.
- `file_size` tidak boleh bernilai negatif.
- `checksum` wajib tersedia untuk paket Plugin yang telah dirilis.
- `checksum_algorithm` wajib diisi apabila `checksum` memiliki nilai.
- Hanya satu Plugin Version yang dapat memiliki `is_current = TRUE` untuk setiap Plugin.
- Plugin Version bersifat immutable setelah dibuat.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Plugins | Many to One | Plugin Version merupakan versi dari satu Plugin |
| Plugin Installations | One to Many | Satu Plugin Version dapat digunakan oleh banyak instalasi |
| Audit Logs | One to Many | Aktivitas penting Plugin Version dapat dicatat pada Audit Log |

### Catatan

- Setiap versi Plugin memiliki kombinasi `(plugin_id, version)` yang unik.
- Plugin Version menyimpan snapshot paket Plugin pada versi tertentu.
- Plugin Version tidak boleh diubah setelah dirilis.
- Plugin Version tidak boleh dihapus secara langsung.
- `is_current = TRUE` menunjukkan versi terbaru/aktif yang digunakan sebagai versi utama Plugin.
- Checksum digunakan untuk memastikan integritas paket Plugin.
- Paket Plugin dapat disimpan pada penyimpanan lokal maupun cloud.
- Credential penyimpanan, API Key, Secret, Token, dan data autentikasi tidak disimpan pada tabel ini.
- Rollback dilakukan dengan memilih versi Plugin sebelumnya, bukan dengan mengubah isi versi lama.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(plugin_id, version)`
- `INDEX(plugin_id)`
- `INDEX(is_current)`
- `INDEX(released_at)`
- `INDEX(minimum_ohtats_version)`

### Future Development

- Digital Signature
- Delta Update
- Compatibility Checker
- Rollback Package
- Multi Repository Support
- Automatic Integrity Verification
- Plugin Security Scanner
- Dependency Locking

## 6.16 Tabel Plugin Installations

### Tujuan

Mencatat seluruh instalasi Plugin pada Trading Account OHTATS.

Plugin Installation digunakan untuk:

- Mengelola instalasi Plugin.
- Mengaktifkan dan menonaktifkan Plugin.
- Menentukan versi Plugin yang digunakan.
- Mendukung pembaruan Plugin.
- Mendukung rollback Plugin.
- Menyimpan histori lifecycle instalasi.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Accounts |
| plugin_id | UUID | Relasi ke Plugins |
| plugin_version_id | UUID | Relasi ke Plugin Versions |
| installation_status | ENUM(INSTALLED,ACTIVE,DISABLED,UNINSTALLED) | Status instalasi |
| installed_at | DATETIME | Waktu instalasi |
| activated_at | DATETIME | Waktu aktivasi (nullable) |
| updated_at | DATETIME | Waktu terakhir instalasi diperbarui |
| uninstalled_at | DATETIME | Waktu Plugin dihapus dari Account (nullable) |
| created_at | DATETIME | Waktu record dibuat |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `account_id → trading_accounts.id`.
- Foreign Key: `plugin_id → plugins.id`.
- Foreign Key: `plugin_version_id → plugin_versions.id`.
- `plugin_version_id` harus mengacu pada Plugin Version yang berasal dari `plugin_id` yang sama.
- Kombinasi `(account_id, plugin_id)` harus unik untuk instalasi aktif.
- `installation_status` hanya boleh menggunakan nilai yang telah ditentukan.
- `activated_at` wajib tersedia apabila status `ACTIVE`.
- `uninstalled_at` wajib tersedia apabila status `UNINSTALLED`.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Trading Accounts | Many to One | Instalasi dimiliki oleh satu Trading Account |
| Plugins | Many to One | Instalasi menggunakan satu Plugin |
| Plugin Versions | Many to One | Instalasi menggunakan satu versi Plugin tertentu |
| Audit Logs | One to Many | Aktivitas instalasi Plugin dapat dicatat pada Audit Log |

### Catatan

- Satu Trading Account dapat memiliki banyak Plugin Installation.
- Satu Plugin dapat dipasang pada banyak Trading Account.
- Satu Plugin Version dapat digunakan oleh banyak instalasi.
- Instalasi selalu mengacu pada satu versi Plugin tertentu.
- Plugin dapat dinonaktifkan tanpa menghapus metadata Plugin.
- Perubahan versi Plugin pada instalasi harus dicatat sebagai perubahan lifecycle instalasi.
- Rollback Plugin dilakukan dengan memilih Plugin Version yang kompatibel.
- Credential Plugin tidak boleh disimpan secara plaintext pada tabel Plugin Installations.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(account_id, plugin_id)`
- `INDEX(plugin_version_id)`
- `INDEX(installation_status)`
- `INDEX(installed_at)`
- `INDEX(created_at)`

### Future Development

- Automatic Plugin Update
- Plugin Dependency Resolver
- Plugin Rollback
- Plugin Health Monitoring
- Remote Installation
- Bulk Plugin Deployment
- Plugin Compatibility Validation
- Installation Repair

## 6.17 Tabel External Integrations

### Tujuan

Menyimpan konfigurasi dan metadata integrasi OHTATS dengan layanan eksternal.

External Integrations digunakan untuk:

- Komunikasi API.
- Webhook.
- Notifikasi.
- Sinkronisasi data.
- Penyimpanan cloud.
- Integrasi TradingView.
- Integrasi layanan komunikasi.
- Integrasi layanan eksternal lainnya.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| account_id | UUID | Relasi ke Trading Accounts (nullable) |
| integration_name | VARCHAR(150) | Nama Integrasi |
| integration_type | ENUM(API,WEBHOOK,EMAIL,TELEGRAM,DISCORD,TRADINGVIEW,GOOGLE_DRIVE,ONEDRIVE,DROPBOX,OTHER) | Jenis Integrasi |
| provider | VARCHAR(150) | Nama penyedia layanan |
| authentication_type | VARCHAR(50) | Jenis autentikasi seperti API Key, OAuth, Token, atau Basic Auth |
| endpoint_url | VARCHAR(255) | URL Endpoint (nullable) |
| configuration | JSON | Konfigurasi non-rahasia Integrasi |
| status | ENUM(ACTIVE,INACTIVE,ERROR) | Status Integrasi |
| last_sync_at | DATETIME | Waktu sinkronisasi terakhir (nullable) |
| last_error | TEXT | Error terakhir (nullable) |
| created_at | DATETIME | Waktu Integrasi dibuat |
| updated_at | DATETIME | Waktu Integrasi diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `account_id → trading_accounts.id` (nullable).
- `integration_type` hanya boleh menggunakan nilai yang telah ditentukan.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `configuration` hanya boleh menyimpan konfigurasi non-rahasia.
- Credential, API Key, Access Token, Refresh Token, Secret, Password, dan data autentikasi sensitif tidak boleh disimpan dalam bentuk plaintext pada tabel ini.
- Secret wajib dikelola melalui mekanisme Secret Management yang sesuai.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Trading Accounts | Many to One | Integrasi dapat dimiliki oleh satu Trading Account |
| Workflow Executions | Konseptual | Workflow Execution dapat menggunakan External Integration |
| API Usage | One to Many | Penggunaan API melalui integrasi dapat dicatat pada API Usage |
| Audit Logs | One to Many | Aktivitas penting External Integration dapat dicatat pada Audit Log |

### Catatan

- External Integration dapat bersifat global atau terkait dengan Trading Account tertentu.
- `account_id = NULL` menunjukkan integrasi tidak terikat pada satu Trading Account tertentu.
- `configuration` digunakan untuk menyimpan konfigurasi non-rahasia yang fleksibel.
- Credential dan secret wajib menggunakan mekanisme Secret Management.
- `authentication_type` menjelaskan metode autentikasi tanpa menyimpan credential aktual.
- Integrasi dapat dinonaktifkan tanpa menghapus histori konfigurasi dan aktivitas.
- Endpoint dan konfigurasi harus divalidasi sebelum Integrasi diaktifkan.
- Integrasi yang mengalami error dapat tetap dipertahankan untuk troubleshooting dan audit.

### Index yang Disarankan

- `PK(id)`
- `INDEX(account_id)`
- `INDEX(integration_type)`
- `INDEX(provider)`
- `INDEX(status)`
- `INDEX(last_sync_at)`
- `INDEX(created_at)`

### Future Development

- OAuth Integration
- Secret Vault Integration
- Health Check Monitoring
- Connection Pool
- Integration Marketplace
- Automatic Reconnect
- Webhook Management
- Integration Permission Management
- Integration Health Dashboard

## 6.18 Tabel Notifications

### Tujuan

Menyimpan seluruh notifikasi yang dihasilkan oleh sistem OHTATS.

Notifications digunakan untuk:

- Menyampaikan informasi kepada User.
- Menyampaikan peringatan dan Alert.
- Menyampaikan hasil proses sistem.
- Mendukung berbagai kanal komunikasi.
- Menyimpan riwayat pengiriman notifikasi.
- Menyimpan status pembacaan notifikasi.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| user_id | UUID | Relasi ke Users |
| account_id | UUID | Relasi ke Trading Accounts (nullable) |
| notification_type | ENUM(INFO,WARNING,ERROR,SUCCESS,ALERT) | Jenis Notifikasi |
| priority | ENUM(LOW,NORMAL,HIGH,CRITICAL) | Prioritas Notifikasi |
| channel | ENUM(IN_APP,EMAIL,TELEGRAM,DISCORD,WEBHOOK,PUSH,SMS) | Kanal pengiriman |
| title | VARCHAR(200) | Judul Notifikasi |
| message | TEXT | Isi Notifikasi |
| related_entity | VARCHAR(100) | Nama entitas terkait (nullable) |
| related_entity_id | UUID | ID entitas terkait (nullable) |
| status | ENUM(PENDING,SENT,FAILED) | Status pengiriman |
| is_read | BOOLEAN | Status pembacaan User |
| sent_at | DATETIME | Waktu pengiriman (nullable) |
| read_at | DATETIME | Waktu dibaca (nullable) |
| created_at | DATETIME | Waktu Notifikasi dibuat |
| updated_at | DATETIME | Waktu Notifikasi diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `user_id → users.id`.
- Foreign Key: `account_id → trading_accounts.id` (nullable).
- `notification_type` hanya boleh menggunakan nilai yang telah ditentukan.
- `priority` hanya boleh menggunakan nilai yang telah ditentukan.
- `channel` hanya boleh menggunakan nilai yang telah ditentukan.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `read_at` wajib tersedia apabila `is_read = TRUE`.
- `read_at` tidak boleh lebih awal daripada `sent_at` apabila keduanya memiliki nilai.
- `sent_at` wajib tersedia apabila `status = SENT`.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | Notification ditujukan kepada satu User |
| Trading Accounts | Many to One | Notification dapat terkait dengan satu Trading Account |
| Workflow Executions | Konseptual | Notification dapat berasal dari Workflow Execution |
| Orders | Konseptual | Notification dapat terkait dengan Order |
| Positions | Konseptual | Notification dapat terkait dengan Position |
| Audit Logs | One to Many | Aktivitas penting Notification dapat dicatat pada Audit Log |
| Job Queue | Konseptual | Pengiriman Notification dapat diproses melalui asynchronous Job |

### Catatan

- Notification tetap disimpan sebagai histori meskipun telah dibaca.
- `status` menunjukkan status pengiriman, sedangkan `is_read` menunjukkan status pembacaan User.
- `status = SENT` tidak berarti Notification telah dibaca.
- `related_entity` dan `related_entity_id` memungkinkan Notification dikaitkan dengan berbagai modul OHTATS secara fleksibel.
- Relasi polymorphic melalui `related_entity` dan `related_entity_id` tidak menggunakan Foreign Key langsung.
- Notification yang gagal dikirim dapat diproses ulang melalui mekanisme Queue.
- Isi Notification tidak boleh menyimpan credential, API Key, Token, Password, atau Secret.
- Data Notification dapat digunakan untuk monitoring dan analisis pengiriman.

### Index yang Disarankan

- `PK(id)`
- `INDEX(user_id)`
- `INDEX(account_id)`
- `INDEX(notification_type)`
- `INDEX(priority)`
- `INDEX(channel)`
- `INDEX(status)`
- `INDEX(is_read)`
- `INDEX(created_at)`

### Future Development

- Notification Queue
- Scheduled Notification
- Notification Template
- Multi-language Notification
- Notification Analytics
- User Notification Preference
- Notification Retry
- Notification Digest
- Real-time Notification
- Notification Delivery Tracking

## 6.19 Tabel Audit Logs

### Tujuan

Mencatat seluruh aktivitas penting yang terjadi pada sistem OHTATS.

Audit Logs digunakan untuk:

- Audit sistem.
- Keamanan.
- Troubleshooting.
- Compliance.
- Digital forensics.
- Tracing aktivitas User dan sistem.
- Investigasi perubahan konfigurasi dan data.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| user_id | UUID | Relasi ke Users (nullable) |
| account_id | UUID | Relasi ke Trading Accounts (nullable) |
| session_id | UUID | Relasi ke Session (nullable) |
| request_id | VARCHAR(100) | ID request untuk tracing (nullable) |
| event_source | ENUM(UI,API,WORKFLOW,WORKER,SYSTEM,PLUGIN,EXTERNAL) | Sumber aktivitas |
| module | VARCHAR(100) | Nama modul |
| entity_name | VARCHAR(100) | Nama entitas terkait (nullable) |
| entity_id | UUID | ID entitas terkait (nullable) |
| action | ENUM(CREATE,UPDATE,DELETE,LOGIN,LOGOUT,EXECUTE,IMPORT,EXPORT,APPROVE,REJECT,ENABLE,DISABLE) | Jenis aktivitas |
| severity | ENUM(INFO,WARNING,ERROR,CRITICAL) | Tingkat prioritas |
| old_value | JSON | Data sebelum perubahan (nullable) |
| new_value | JSON | Data setelah perubahan (nullable) |
| ip_address | VARCHAR(50) | Alamat IP (nullable) |
| user_agent | TEXT | Informasi perangkat/browser (nullable) |
| execution_result | ENUM(SUCCESS,FAILED) | Hasil eksekusi (nullable) |
| error_message | TEXT | Pesan kesalahan (nullable) |
| created_at | DATETIME | Waktu kejadian |

### Constraint

- Primary Key: `id`.
- Foreign Key: `user_id → users.id` (nullable).
- Foreign Key: `account_id → trading_accounts.id` (nullable).
- `event_source` hanya boleh menggunakan nilai yang telah ditentukan.
- `action` hanya boleh menggunakan nilai yang telah ditentukan.
- `severity` hanya boleh menggunakan nilai yang telah ditentukan.
- `execution_result` hanya digunakan apabila aktivitas menghasilkan status eksekusi.
- `entity_id` bersifat nullable karena tidak semua aktivitas terkait dengan satu entitas tertentu.
- Audit Log bersifat immutable dan append-only.
- Audit Log tidak boleh diubah atau dihapus melalui operasi normal sistem.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | Aktivitas dapat dilakukan oleh User |
| Trading Accounts | Many to One | Aktivitas dapat terkait dengan Trading Account |
| Sessions | Many to One | Aktivitas dapat berasal dari Session tertentu |
| Orders | Konseptual | Audit dapat mereferensikan Order |
| Positions | Konseptual | Audit dapat mereferensikan Position |
| Workflows | Konseptual | Audit dapat mereferensikan Workflow |
| Plugins | Konseptual | Audit dapat mereferensikan Plugin |
| AI Analysis | Konseptual | Audit dapat mereferensikan AI Analysis |

### Catatan

- Audit Log bersifat immutable dan append-only.
- Audit Log tidak boleh diubah setelah dibuat.
- Audit Log tidak menggunakan mekanisme Soft Delete.
- Setiap koreksi atau kejadian baru dicatat sebagai Audit Log baru.
- Audit Log merupakan sumber utama investigasi, keamanan, troubleshooting, dan kepatuhan sistem.
- Data credential, secret, token, password, API key, dan informasi sensitif wajib di-redact sebelum disimpan.
- Data sensitif tidak boleh direkam secara plaintext pada `old_value`, `new_value`, `error_message`, maupun field lainnya.
- `request_id` digunakan untuk menghubungkan aktivitas dari satu request atau proses.
- `event_source` digunakan untuk mengetahui sumber aktivitas.

### Index yang Disarankan

- `PK(id)`
- `INDEX(user_id)`
- `INDEX(account_id)`
- `INDEX(session_id)`
- `INDEX(request_id)`
- `INDEX(event_source)`
- `INDEX(module)`
- `INDEX(entity_name, entity_id)`
- `INDEX(action)`
- `INDEX(severity)`
- `INDEX(created_at)`

### Future Development

- Centralized Logging
- Log Retention Policy
- Log Encryption
- SIEM Integration
- Real-time Monitoring
- Security Incident Detection
- Tamper Detection
- Immutable Log Storage
- Audit Log Archiving

## 6.20 Tabel System Settings

### Tujuan

Menyimpan konfigurasi global platform OHTATS agar dapat dikelola tanpa mengubah source code.

System Settings digunakan untuk:

- Konfigurasi global platform.
- Pengaturan perilaku sistem.
- Pengaturan default modul.
- Pengaturan AI Provider.
- Pengaturan Workflow.
- Pengaturan Notification.
- Pengaturan operasional platform.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| category | VARCHAR(100) | Kategori pengaturan |
| setting_key | VARCHAR(150) | Nama konfigurasi |
| setting_value | TEXT | Nilai konfigurasi aktif |
| default_value | TEXT | Nilai bawaan |
| value_type | ENUM(STRING,INTEGER,BOOLEAN,FLOAT,JSON) | Jenis data |
| description | TEXT | Penjelasan konfigurasi |
| is_editable | BOOLEAN | Dapat diubah melalui Dashboard |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Kombinasi `(category, setting_key)` harus unik.
- `value_type` hanya boleh menggunakan nilai yang telah ditentukan.
- `setting_value` harus mengikuti `value_type`.
- `default_value` harus mengikuti `value_type`.
- Credential, API Key, Token, Secret, Password, dan data autentikasi sensitif tidak boleh disimpan pada tabel ini.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Audit Logs | One to Many | Perubahan System Setting dicatat pada Audit Log |
| AI Providers | Konseptual | System Setting dapat memengaruhi konfigurasi AI Provider |
| Workflows | Konseptual | System Setting dapat memengaruhi perilaku Workflow |
| Notifications | Konseptual | System Setting dapat memengaruhi sistem Notification |
| Feature Flags | Konseptual | System Setting dapat digunakan bersama Feature Flags |

### Catatan

- System Settings menyimpan konfigurasi global, bukan credential atau secret.
- Nilai konfigurasi dapat berupa String, Integer, Boolean, Float, maupun JSON.
- `setting_value` harus divalidasi berdasarkan `value_type`.
- Seluruh perubahan konfigurasi penting harus dicatat pada Audit Log.
- Pengaturan yang bersifat sensitif harus menggunakan Secret Management.
- Pengaturan yang tidak boleh diubah User ditandai dengan `is_editable = FALSE`.
- Soft Delete digunakan untuk mempertahankan histori konfigurasi yang pernah tersedia.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(category, setting_key)`
- `INDEX(category)`
- `INDEX(is_editable)`
- `INDEX(created_at)`

### Future Development

- Configuration Versioning
- Configuration Profile
- Environment Override
- Import / Export Configuration
- Configuration Validation
- Dynamic Reload
- Configuration Rollback
- Configuration Schema Validation
- Secret Management Integration

## 6.21 Tabel Feature Flags

### Tujuan

Mengelola fitur yang dapat diaktifkan maupun dinonaktifkan secara dinamis tanpa melakukan deploy ulang aplikasi.

Feature Flags digunakan untuk:

- Mengaktifkan atau menonaktifkan fitur.
- Mengontrol peluncuran fitur secara bertahap.
- Mengatur rollout fitur.
- Mendukung Canary Release.
- Mendukung eksperimen dan A/B Testing.
- Membatasi fitur berdasarkan License atau Subscription.
- Mengurangi risiko saat merilis fitur baru.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| feature_key | VARCHAR(150) | Kode unik fitur |
| feature_name | VARCHAR(150) | Nama fitur |
| category | VARCHAR(100) | Kategori fitur |
| description | TEXT | Deskripsi fitur |
| is_enabled | BOOLEAN | Status global fitur |
| rollout_percentage | SMALLINT | Persentase rollout 0–100 |
| minimum_license | VARCHAR(50) | Minimum License yang diperlukan (nullable) |
| expires_at | DATETIME | Waktu berakhir Feature Flag (nullable) |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- `feature_key` harus unik.
- `rollout_percentage` harus berada pada rentang `0–100`.
- `minimum_license` bersifat nullable.
- `expires_at` bersifat nullable.
- Feature Flag yang telah melewati `expires_at` harus dianggap tidak aktif oleh sistem.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Audit Logs | One to Many | Perubahan Feature Flag dicatat pada Audit Log |
| System Settings | Konseptual | Feature Flag dapat bekerja bersama System Settings |
| Licenses | Konseptual | Feature Flag dapat membatasi fitur berdasarkan License |
| Subscription Plans | Konseptual | Feature Flag dapat digunakan berdasarkan Subscription Plan |

### Catatan

- Feature Flag memungkinkan peluncuran fitur secara bertahap tanpa mengubah source code.
- `is_enabled = FALSE` berarti fitur dinonaktifkan secara global.
- `rollout_percentage = 100` berarti fitur tersedia untuk seluruh target yang memenuhi persyaratan.
- `rollout_percentage = 0` berarti tidak ada target yang mendapatkan fitur.
- Feature Flag dapat digunakan untuk membatasi fitur berdasarkan License atau Subscription.
- Feature Flag yang telah melewati `expires_at` harus otomatis dianggap tidak aktif.
- Perubahan Feature Flag wajib dicatat pada Audit Log.
- Evaluasi Feature Flag harus dilakukan secara konsisten agar User tidak berpindah status rollout secara tidak terduga.
- Mekanisme targeting yang lebih kompleks dapat dikembangkan tanpa mengubah konsep dasar Feature Flags.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(feature_key)`
- `INDEX(category)`
- `INDEX(is_enabled)`
- `INDEX(minimum_license)`
- `INDEX(expires_at)`
- `INDEX(created_at)`

### Future Development

- Percentage Rollout
- A/B Testing
- Canary Release
- User Targeting
- Region-based Rollout
- Organization Targeting
- Automatic Expiration
- Feature Dependency
- Feature Flag Environment
- Feature Flag Audit Dashboard

## 6.22 Tabel Licenses

### Tujuan

Menyimpan informasi lisensi dan hak akses pengguna terhadap platform OHTATS.

License digunakan untuk:

- Mengelola masa aktif akses ke platform OHTATS.
- Menentukan paket langganan yang digunakan oleh User.
- Menentukan batas penggunaan fitur dan resource.
- Mendukung berbagai siklus langganan.
- Menentukan mode penggunaan AI.
- Menjadi dasar validasi hak akses dan pembatasan fitur.
- Menyimpan snapshot hak akses yang berlaku pada saat License diterbitkan.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| user_id | UUID | Relasi ke Users |
| subscription_plan_id | UUID | Relasi ke Subscription Plans |
| license_code | VARCHAR(100) | Kode License unik |
| billing_cycle | ENUM(WEEKLY,MONTHLY,YEARLY,LIFETIME) | Siklus langganan |
| status | ENUM(PENDING,ACTIVE,SUSPENDED,EXPIRED,CANCELLED) | Status License |
| max_accounts | INTEGER | Maksimum Trading Account yang diizinkan |
| max_plugins | INTEGER | Maksimum Plugin aktif yang diizinkan |
| max_workflows | INTEGER | Maksimum Workflow yang diizinkan |
| ai_mode | ENUM(BYOK,OHTATS,HYBRID) | Mode penggunaan AI |
| start_date | DATETIME | Waktu mulai berlaku |
| end_date | DATETIME | Waktu berakhir (nullable untuk Lifetime) |
| auto_renew | BOOLEAN | Menandai perpanjangan otomatis |
| created_at | DATETIME | Waktu License dibuat |
| updated_at | DATETIME | Waktu License diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `user_id → users.id`.
- Foreign Key: `subscription_plan_id → subscription_plans.id`.
- `license_code` harus unik.
- `max_accounts` tidak boleh bernilai negatif.
- `max_plugins` tidak boleh bernilai negatif.
- `max_workflows` tidak boleh bernilai negatif.
- `end_date` harus lebih besar atau sama dengan `start_date` apabila memiliki nilai.
- License dengan `billing_cycle = LIFETIME` tidak wajib memiliki `end_date`.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `ai_mode` hanya boleh menggunakan nilai yang telah ditentukan.
- Hanya satu License `ACTIVE` yang dapat berlaku untuk setiap User pada waktu yang sama.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | License dimiliki oleh satu User |
| Subscription Plans | Many to One | License menggunakan satu Subscription Plan |
| Feature Flags | Konseptual | Menentukan fitur yang tersedia berdasarkan hak akses License |
| Trading Accounts | Konseptual | License membatasi jumlah Trading Account |
| Plugin Installations | Konseptual | License membatasi jumlah Plugin yang dapat digunakan |
| Workflows | Konseptual | License membatasi jumlah Workflow yang dapat digunakan |
| Audit Logs | One to Many | Aktivitas dan perubahan License dapat dicatat pada Audit Log |

### Catatan

- Satu User dapat memiliki banyak riwayat License.
- Hanya satu License `ACTIVE` yang dapat berlaku untuk satu User pada waktu yang sama.
- License selalu mengacu pada satu Subscription Plan.
- `license_code` harus unik.
- Nilai `max_accounts`, `max_plugins`, `max_workflows`, dan `ai_mode` menjadi snapshot hak akses License pada saat diterbitkan.
- Perubahan Subscription Plan tidak boleh mengubah hak akses License yang telah diterbitkan secara historis.
- Mode AI terdiri dari:
  - `BYOK` — Bring Your Own Key.
  - `OHTATS` — menggunakan layanan AI yang disediakan OHTATS.
  - `HYBRID` — kombinasi BYOK dan layanan AI OHTATS.
- Pembatasan fitur dapat menggunakan kombinasi License dan Feature Flags.
- Credential, API Key, Token, Secret, dan data sensitif tidak disimpan pada tabel License.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(license_code)`
- `INDEX(user_id)`
- `INDEX(subscription_plan_id)`
- `INDEX(status)`
- `INDEX(start_date)`
- `INDEX(end_date)`

### Future Development

- License Management Dashboard
- License Renewal Automation
- License Activation Service
- License Validation API
- Feature Entitlement Engine
- License Upgrade and Downgrade
- License Transfer
- License Expiration Notification

## 6.23 Tabel Subscription Plans

### Tujuan

Menyimpan daftar paket langganan yang tersedia pada platform OHTATS.

Subscription Plans menjadi master data untuk:

- Menentukan paket layanan yang tersedia.
- Menentukan harga dan mata uang.
- Menentukan siklus penagihan.
- Menentukan batas penggunaan sumber daya.
- Menentukan mode penggunaan AI.
- Menjadi dasar penerbitan License.
- Mendukung penambahan dan pengelolaan paket baru tanpa mengubah struktur database.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| plan_code | VARCHAR(50) | Kode unik paket |
| plan_name | VARCHAR(100) | Nama paket |
| description | TEXT | Deskripsi paket (nullable) |
| billing_cycle | ENUM(WEEKLY,MONTHLY,YEARLY,LIFETIME) | Siklus penagihan default |
| price | DECIMAL(18,2) | Harga paket |
| currency | VARCHAR(10) | Mata uang |
| max_accounts | INTEGER | Maksimum Trading Account |
| max_plugins | INTEGER | Maksimum Plugin |
| max_workflows | INTEGER | Maksimum Workflow |
| ai_mode | ENUM(BYOK,OHTATS,HYBRID) | Mode AI yang didukung |
| is_active | BOOLEAN | Status paket |
| created_at | DATETIME | Waktu dibuat |
| updated_at | DATETIME | Waktu diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- `plan_code` harus unik.
- `price` tidak boleh bernilai negatif.
- `max_accounts` tidak boleh bernilai negatif.
- `max_plugins` tidak boleh bernilai negatif.
- `max_workflows` tidak boleh bernilai negatif.
- `billing_cycle` hanya boleh menggunakan nilai yang telah ditentukan.
- `ai_mode` hanya boleh menggunakan nilai yang telah ditentukan.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Licenses | One to Many | Satu Subscription Plan dapat digunakan oleh banyak License |
| Feature Flags | Konseptual | Paket dapat menentukan fitur yang tersedia |
| Audit Logs | One to Many | Perubahan Subscription Plan dicatat dalam Audit Log |

### Catatan

- Subscription Plans merupakan master data paket layanan OHTATS.
- `plan_code` digunakan sebagai identitas unik paket.
- Perubahan harga atau konfigurasi paket tidak boleh mengubah histori License yang telah diterbitkan.
- Nilai entitlement pada License menjadi snapshot hak akses pada saat License diterbitkan.
- Paket dapat dinonaktifkan menggunakan `is_active = FALSE` tanpa menghapus histori paket.
- Paket yang tidak aktif tidak boleh digunakan untuk penerbitan License baru.
- `billing_cycle` menentukan siklus penagihan default paket.
- `ai_mode` menentukan mode AI yang didukung oleh paket.
- Credential, API Key, Token, Password, dan Secret tidak disimpan pada tabel Subscription Plans.
- Perubahan penting pada Subscription Plan wajib dicatat pada Audit Log.
- Soft Delete digunakan untuk mempertahankan histori data paket.

### Index yang Disarankan

- `PK(id)`
- `UNIQUE(plan_code)`
- `INDEX(plan_name)`
- `INDEX(billing_cycle)`
- `INDEX(is_active)`
- `INDEX(created_at)`

### Future Development

- Plan Versioning
- Promotional Pricing
- Discount Management
- Coupon Integration
- Regional Pricing
- Currency Management
- Feature Entitlement Mapping
- Usage-based Pricing
- Upgrade / Downgrade Management
- Subscription Comparison

## 6.24 Tabel Backup Metadata

### Tujuan

Menyimpan metadata seluruh proses backup yang dilakukan oleh platform OHTATS.

Backup Metadata digunakan untuk:

- Mencatat riwayat proses backup.
- Mendukung proses restore.
- Memantau status backup.
- Memverifikasi integritas file backup.
- Mengetahui lokasi penyimpanan backup.
- Mendukung audit dan troubleshooting.
- Mendukung pengelolaan backup lokal maupun cloud.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| backup_name | VARCHAR(200) | Nama backup |
| backup_type | ENUM(FULL,INCREMENTAL,DIFFERENTIAL) | Jenis backup |
| storage_provider | ENUM(LOCAL,S3,GOOGLE_DRIVE,ONEDRIVE,DROPBOX,FTP,OTHER) | Penyedia penyimpanan |
| storage_region | VARCHAR(100) | Region penyimpanan (nullable) |
| storage_path | VARCHAR(500) | Lokasi file backup |
| file_size | BIGINT | Ukuran file dalam byte |
| checksum | VARCHAR(128) | Hash untuk verifikasi integritas |
| checksum_algorithm | VARCHAR(20) | Algoritma checksum |
| encryption_type | VARCHAR(50) | Metode enkripsi backup |
| backup_status | ENUM(PENDING,RUNNING,SUCCESS,FAILED,CANCELLED) | Status proses backup |
| started_at | DATETIME | Waktu mulai backup |
| completed_at | DATETIME | Waktu backup selesai (nullable) |
| created_by | UUID | User/Admin yang membuat backup (nullable) |
| created_at | DATETIME | Waktu metadata dibuat |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- Foreign Key: `created_by → users.id` (nullable).
- `backup_type` hanya boleh menggunakan nilai yang telah ditentukan.
- `storage_provider` hanya boleh menggunakan nilai yang telah ditentukan.
- `backup_status` hanya boleh menggunakan nilai yang telah ditentukan.
- `file_size` tidak boleh bernilai negatif.
- `checksum` wajib tersedia apabila `backup_status = SUCCESS`.
- `completed_at` wajib tersedia apabila `backup_status = SUCCESS`.
- `completed_at` tidak boleh lebih awal daripada `started_at`.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | Backup dapat dibuat oleh User atau Administrator |
| Job Queue | Konseptual | Backup dapat diproses melalui Job Queue |
| Audit Logs | One to Many | Aktivitas Backup dicatat dalam Audit Log |
| External Integrations | Konseptual | Backup dapat menggunakan penyimpanan eksternal |

### Catatan

- File backup tidak disimpan langsung di dalam database.
- Database hanya menyimpan metadata backup.
- `storage_path` menyimpan lokasi atau identifier file backup.
- `checksum` digunakan untuk memverifikasi integritas file backup.
- `checksum_algorithm` menentukan algoritma yang digunakan untuk menghasilkan checksum.
- Backup dapat disimpan pada penyimpanan lokal maupun cloud.
- Backup yang sedang berjalan memiliki status `RUNNING`.
- Backup yang berhasil memiliki status `SUCCESS`.
- Backup yang gagal memiliki status `FAILED`.
- Backup yang dibatalkan memiliki status `CANCELLED`.
- `completed_at` hanya diisi setelah proses backup selesai.
- Metadata backup tetap disimpan untuk kebutuhan audit dan histori.
- File backup yang telah dihapus dari storage harus dapat ditandai atau dideteksi oleh sistem pada proses monitoring dan restore.
- Credential, API Key, Token, Password, dan Secret penyimpanan tidak boleh disimpan pada tabel ini.
- Soft Delete digunakan untuk mempertahankan histori metadata backup.

### Index yang Disarankan

- `PK(id)`
- `INDEX(backup_type)`
- `INDEX(storage_provider)`
- `INDEX(backup_status)`
- `INDEX(created_by)`
- `INDEX(started_at)`
- `INDEX(completed_at)`
- `INDEX(created_at)`

### Future Development

- Automated Backup Scheduler
- Backup Retention Policy
- Backup Rotation
- Remote Backup Monitoring
- Backup Integrity Verification
- Restore Verification
- Point-in-Time Recovery
- Encrypted Backup
- Backup Compression
- Multi-Storage Replication
- Disaster Recovery
- Backup Health Monitoring

## 6.25 Tabel Job Queue

### Tujuan

Menyimpan seluruh pekerjaan (Job) yang diproses secara asynchronous oleh platform OHTATS.

Job Queue digunakan untuk:

- Menjalankan proses background.
- Memisahkan proses berat dari request pengguna.
- Mendukung Scheduler dan Background Worker.
- Menjalankan Workflow secara asynchronous.
- Menjalankan proses AI dan analisis.
- Menjalankan proses Backup dan Maintenance.
- Mendukung mekanisme retry.
- Mendukung monitoring dan troubleshooting proses asynchronous.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| job_name | VARCHAR(150) | Nama Job |
| job_type | VARCHAR(100) | Jenis Job |
| queue_name | VARCHAR(100) | Nama antrean |
| payload | JSON | Data yang diproses |
| priority | ENUM(LOW,NORMAL,HIGH,CRITICAL) | Prioritas Job |
| status | ENUM(PENDING,QUEUED,RUNNING,COMPLETED,FAILED,RETRY,CANCELLED) | Status Job |
| retry_count | INTEGER | Jumlah percobaan |
| max_retry | INTEGER | Batas maksimum retry |
| scheduled_at | DATETIME | Waktu Job dijadwalkan (nullable) |
| started_at | DATETIME | Waktu Job mulai diproses (nullable) |
| completed_at | DATETIME | Waktu Job selesai diproses (nullable) |
| worker_name | VARCHAR(100) | Nama Worker yang memproses (nullable) |
| error_message | TEXT | Pesan kesalahan (nullable) |
| created_at | DATETIME | Waktu Job dibuat |
| updated_at | DATETIME | Waktu Job diperbarui |
| deleted_at | DATETIME | Soft Delete |

### Constraint

- Primary Key: `id`.
- `priority` hanya boleh menggunakan nilai yang telah ditentukan.
- `status` hanya boleh menggunakan nilai yang telah ditentukan.
- `retry_count` tidak boleh bernilai negatif.
- `max_retry` tidak boleh bernilai negatif.
- `retry_count` tidak boleh melebihi `max_retry`.
- `completed_at` tidak boleh lebih awal daripada `started_at`.
- `scheduled_at` bersifat nullable untuk Job yang harus segera diproses.
- Soft Delete menggunakan kolom `deleted_at`.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Workflow Executions | Konseptual | Job dapat menjalankan Workflow Execution |
| Notifications | Konseptual | Job dapat menghasilkan Notification |
| Backup Metadata | Konseptual | Job dapat menjalankan proses Backup |
| AI Analysis | Konseptual | Job dapat menjalankan proses AI Analysis |
| Audit Logs | One to Many | Aktivitas Job dicatat dalam Audit Log |

### Catatan

- Job Queue digunakan untuk proses yang tidak harus diselesaikan langsung dalam request pengguna.
- `queue_name` digunakan untuk memisahkan jenis pekerjaan berdasarkan kebutuhan Worker.
- `priority` menentukan tingkat prioritas pemrosesan Job.
- `status = PENDING` menunjukkan Job telah dibuat tetapi belum masuk antrean pemrosesan.
- `status = QUEUED` menunjukkan Job telah masuk antrean dan menunggu Worker.
- `status = RUNNING` menunjukkan Job sedang diproses oleh Worker.
- `status = COMPLETED` menunjukkan Job berhasil diselesaikan.
- `status = FAILED` menunjukkan Job gagal setelah proses atau setelah batas retry tercapai.
- `status = RETRY` menunjukkan Job dijadwalkan untuk dicoba kembali.
- `status = CANCELLED` menunjukkan Job dibatalkan sebelum selesai.
- `retry_count` digunakan untuk mencatat jumlah percobaan pemrosesan.
- `max_retry` menentukan batas maksimum percobaan ulang.
- `worker_name` digunakan untuk mengetahui Worker yang memproses Job.
- `payload` menyimpan parameter pekerjaan dalam format JSON.
- Payload tidak boleh menyimpan credential, password, API Key, Token, atau Secret secara plaintext.
- Riwayat Job tetap disimpan sebagai dasar audit, monitoring, troubleshooting, dan analisis performa.
- Job yang bersifat kritis harus memiliki mekanisme retry dan failure handling yang sesuai.
- Soft Delete digunakan untuk mempertahankan histori Job tanpa menghapus record secara permanen.

### Index yang Disarankan

- `PK(id)`
- `INDEX(queue_name)`
- `INDEX(status)`
- `INDEX(priority)`
- `INDEX(scheduled_at)`
- `INDEX(worker_name)`
- `INDEX(created_at)`
- `INDEX(status, priority, scheduled_at)`

### Future Development

- Distributed Job Queue
- Priority Scheduling
- Dead Letter Queue
- Exponential Backoff
- Automatic Retry
- Worker Health Monitoring
- Queue Monitoring Dashboard
- Job Cancellation
- Job Timeout
- Job Dependency
- Scheduled Jobs
- Job Deduplication
- Distributed Worker
- Execution Replay

## 6.26 Tabel API Usage

### Tujuan

Mencatat seluruh aktivitas penggunaan API pada platform OHTATS.

API Usage digunakan untuk:

- Memantau konsumsi API.
- Mengelola penggunaan dan Rate Limit.
- Mengukur performa API.
- Mencatat keberhasilan dan kegagalan request.
- Mengukur penggunaan Token pada layanan yang mendukung Token.
- Mengestimasi biaya penggunaan layanan AI maupun layanan eksternal.
- Mendukung audit dan troubleshooting.
- Mendukung optimasi penggunaan API.

### Struktur Tabel

| Kolom | Tipe | Keterangan |
|---|---|---|
| id | UUID | Primary Key |
| user_id | UUID | Relasi ke Users (nullable) |
| account_id | UUID | Relasi ke Trading Accounts (nullable) |
| provider_id | UUID | Relasi ke AI Providers / External Providers (nullable) |
| integration_id | UUID | Relasi ke External Integrations (nullable) |
| api_name | VARCHAR(150) | Nama API |
| endpoint | VARCHAR(255) | Endpoint yang dipanggil |
| request_type | ENUM(GET,POST,PUT,PATCH,DELETE) | Jenis HTTP Request |
| request_count | INTEGER | Jumlah request |
| input_tokens | INTEGER | Jumlah Token Input (nullable) |
| output_tokens | INTEGER | Jumlah Token Output (nullable) |
| estimated_cost | DECIMAL(18,8) | Estimasi biaya penggunaan |
| response_time_ms | INTEGER | Waktu respons dalam milidetik |
| rate_limit_status | ENUM(NORMAL,WARNING,LIMITED,BLOCKED) | Status Rate Limit |
| request_status | ENUM(SUCCESS,FAILED,TIMEOUT) | Status Request |
| error_message | TEXT | Pesan kesalahan (nullable) |
| created_at | DATETIME | Waktu aktivitas API |

### Constraint

- Primary Key: `id`.
- Foreign Key: `user_id → users.id` (nullable).
- Foreign Key: `account_id → trading_accounts.id` (nullable).
- Foreign Key: `provider_id → ai_providers.id` (nullable).
- Foreign Key: `integration_id → external_integrations.id` (nullable).
- `request_count` tidak boleh bernilai negatif.
- `input_tokens` tidak boleh bernilai negatif apabila digunakan.
- `output_tokens` tidak boleh bernilai negatif apabila digunakan.
- `estimated_cost` tidak boleh bernilai negatif.
- `response_time_ms` tidak boleh bernilai negatif.
- `request_type` hanya boleh menggunakan nilai HTTP Method yang telah ditentukan.
- `rate_limit_status` hanya boleh menggunakan nilai yang telah ditentukan.
- `request_status` hanya boleh menggunakan nilai yang telah ditentukan.
- Data credential, API Key, Token, Password, dan Secret tidak boleh disimpan pada tabel ini.

### Relasi

| Tabel | Jenis Relasi | Keterangan |
|---|---|---|
| Users | Many to One | Penggunaan API dapat dilakukan oleh User |
| Trading Accounts | Many to One | Penggunaan API dapat terkait dengan Trading Account |
| AI Providers | Many to One | API dapat menggunakan AI Provider |
| External Integrations | Many to One | Aktivitas API dapat berasal dari External Integration |
| Audit Logs | One to Many | Aktivitas API dapat dicatat pada Audit Log |

### Catatan

- Tidak semua Provider menggunakan sistem Token.
- `input_tokens` dan `output_tokens` bersifat nullable karena tidak semua API menyediakan informasi Token.
- `estimated_cost` dihitung berdasarkan tarif Provider yang digunakan apabila informasi tarif tersedia.
- Tidak semua API memiliki biaya penggunaan.
- `request_count` dapat merepresentasikan satu request maupun agregasi beberapa request sesuai implementasi sistem.
- Untuk kebutuhan monitoring detail, satu record dapat mewakili satu aktivitas API.
- Untuk kebutuhan agregasi, implementasi dapat mengelompokkan aktivitas berdasarkan Provider, API, User, Account, atau periode waktu.
- `response_time_ms` digunakan untuk mengukur performa API.
- `rate_limit_status` digunakan untuk memantau kondisi penggunaan terhadap batas API.
- `request_status` digunakan untuk membedakan request berhasil, gagal, atau timeout.
- `error_message` dapat digunakan untuk troubleshooting, tetapi tidak boleh mengandung credential atau Secret.
- API Usage dapat digunakan sebagai dasar monitoring biaya operasional layanan AI dan eksternal.
- Data API Usage dapat digunakan bersama Audit Logs untuk investigasi aktivitas API.
- Data API Usage bersifat historis dan tidak boleh digunakan sebagai tempat penyimpanan credential.

### Index yang Disarankan

- `PK(id)`
- `INDEX(user_id)`
- `INDEX(account_id)`
- `INDEX(provider_id)`
- `INDEX(integration_id)`
- `INDEX(api_name)`
- `INDEX(rate_limit_status)`
- `INDEX(request_status)`
- `INDEX(created_at)`
- `INDEX(provider_id, created_at)`
- `INDEX(user_id, created_at)`

### Future Development

- API Usage Dashboard
- Provider Cost Analytics
- Token Usage Analytics
- Rate Limit Monitoring
- Automatic Cost Alert
- Usage Quota Management
- Provider Usage Comparison
- API Performance Analytics
- Usage Forecasting
- Cost Optimization
- Billing Integration
- API Usage Export
- Anomaly Detection