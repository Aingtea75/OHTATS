# ADR-006 — Strategy Binding Boundary

**Status:** Approved

## Decision

OHTATS tidak menjadikan `strategies` sebagai owner langsung untuk canonical `instrument` atau `broker` relationship.

Canonical ownership dan binding mengikuti lifecycle berikut:

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
Order / Execution / Deal / Position
```

`strategies` memiliki identity dan ownership terhadap user.

`strategy_versions` memiliki immutable executable definition.

`strategy_deployments` mengikat strategy version ke target execution/account bila deployment tersebut membutuhkan account.

`trading_requests`, `orders`, `deals`, dan `positions` membawa canonical instrument/broker-symbol references sesuai kebutuhan masing-masing lifecycle.

Broker ownership tetap berada pada `trading_accounts`, `connections`, `broker_platforms`, dan broker-specific entities.

## Rationale

`DATABASE_DESIGN.md` mendefinisikan:

- `strategies` → owner user;
- `strategy_versions` → immutable executable version;
- `strategy_deployments` → binding strategy version ke account/target;
- `trading_requests` → instrument dan broker symbol;
- `orders` → account, instrument, dan broker symbol;
- `positions` → account, instrument, dan broker symbol.

Model ini menjaga strategy tetap reusable dan tidak mengunci strategy identity ke satu broker atau symbol. Broker/platform-specific execution context baru ditentukan pada deployment/execution boundary.

## Consequences

1. Strategy tidak membutuhkan direct `symbol_id` atau `broker_id` foreign key hanya untuk menjadi executable.
2. Satu strategy version dapat digunakan pada beberapa account/platform sesuai deployment dan capability.
3. Instrument dan broker-symbol binding tetap authoritative pada trading lifecycle.
4. Architecture dan Module Specification tidak boleh memperkenalkan duplicate direct ownership relationship yang bertentangan dengan database baseline.
5. Pernyataan review lama yang menyatakan `Strategy → Symbol` sebagai minimum direct relationship harus ditafsirkan sebagai domain capability/binding requirement, bukan kewajiban FK langsung pada tabel `strategies`.

## Governance

ADR ini merupakan clarification terhadap boundary logical database dan architecture. ADR ini tidak mengubah schema `DATABASE_DESIGN.md`; implementasi harus mengikuti canonical ownership yang telah ditetapkan.

---

# END OF ADR-006
