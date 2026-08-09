# OHTATS — Database Review Addendum

> **Status: REVIEW ADDENDUM — APPROVED CLARIFICATION**
>
> Addendum ini dibaca bersama `DATABASE_REVIEW.md`, `DATABASE_DESIGN.md`, `ERD.md`, dan `ADR-006-STRATEGY-BINDING-BOUNDARY.md`.

---

# 1. Purpose

Addendum ini mencatat satu klarifikasi yang ditemukan saat cross-check foundation architecture terhadap final database baseline.

Tidak ada perubahan terhadap schema canonical `DATABASE_DESIGN.md`.

---

# 2. Finding

`DATABASE_REVIEW.md` pada bagian Referential Integrity mencantumkan:

- Strategy → User
- Strategy → Symbol
- Strategy → Broker bila mandatory

Sementara `DATABASE_DESIGN.md` secara canonical memodelkan:

- `strategies` → `users` melalui `owner_user_id`;
- `strategy_versions` → `strategies`;
- `strategy_deployments` → `strategy_versions` dan optional `trading_accounts`;
- `trading_requests` → `instrument_id` dan `broker_symbol_id`;
- `orders` → `account_id`, `instrument_id`, dan `broker_symbol_id`;
- `positions` → `account_id`, `instrument_id`, dan `broker_symbol_id`.

Dengan demikian tidak ada kebutuhan untuk membuat direct `symbol_id` atau `broker_id` FK pada `strategies` hanya agar strategy dapat digunakan untuk execution.

---

# 3. Resolution

Canonical relationship adalah:

```text
User
  ↓
Strategy
  ↓
Strategy Version
  ↓
Strategy Deployment → Trading Account
  ↓
Trading Request → Instrument + Broker Symbol
  ↓
Order → Execution → Deal → Position
```

Strategy tetap reusable dan tidak terkunci pada satu broker/platform/symbol.

Execution context ditentukan pada deployment dan trading lifecycle.

---

# 4. Architecture Impact

Cross-check terhadap `SYSTEM_DESIGN.md`, `ARCHITECTURE.md`, dan `MODULE_SPECIFICATION.md` dinyatakan konsisten dengan resolution ini.

Tidak boleh dibuat duplicate ownership di domain/service layer yang mengubah strategy menjadi owner langsung atas broker atau trading position.

---

# 5. Implementation Gate

Implementasi wajib mempertahankan:

1. immutable strategy version;
2. deployment binding yang jelas;
3. canonical instrument model;
4. broker-specific symbol mapping;
5. trading request sebelum order;
6. risk gate sebelum executable action;
7. order/execution/deal/position lifecycle sesuai database baseline.

---

# 6. Conclusion

**DATABASE FOUNDATION CROSS-CHECK: PASS WITH CLARIFICATION**

Database baseline tetap menjadi sumber canonical persistence model.

Klarifikasi ini dicatat agar review, architecture, module ownership, dan implementation tidak menafsirkan Strategy → Symbol/Broker sebagai direct mandatory foreign key pada `strategies`.

---

# END OF DATABASE_REVIEW_ADDENDUM.md
