# OHTATS — Event System Blueprint

> Menetapkan event-driven coordination OHTATS dan membedakan domain event dari authoritative persistence.

# Status

**EVENT SYSTEM BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principles

- Events untuk asynchronous coordination.
- Event tidak menggantikan authoritative business state.
- Event schema harus versioned.
- Consumer harus idempotent.
- Event harus memiliki correlation/causation identity bila relevan.
- Sensitive payload harus disanitasi.
- Delivery failure harus dapat di-retry.

# 2. Event Categories

1. Domain events — perubahan penting pada domain.
2. Integration events — komunikasi dengan external system.
3. Workflow events — lifecycle workflow.
4. Security/audit events — security dan audit evidence.
5. Operational events — health/job/system state.
6. Notification events — trigger notifikasi.

# 3. Canonical Envelope

```json
{
  "event_id": "uuid",
  "event_type": "order.accepted",
  "event_version": 1,
  "occurred_at": "UTC",
  "producer": "trading-engine",
  "correlation_id": "...",
  "causation_id": "...",
  "subject_type": "order",
  "subject_id": "...",
  "payload": {}
}
```

Envelope metadata harus stabil; payload mengikuti event contract.

# 4. Event Lifecycle

```text
Domain State Change
      ↓
Persist State
      ↓
Create Event
      ↓
Publish / Outbox
      ↓
Transport
      ↓
Consumer
      ↓
Ack / Retry / Dead Letter
```

Untuk critical transactional event, publish harus dirancang agar tidak terjadi state committed tetapi event hilang.

# 5. Event Ownership

| Event Domain | Producer |
|---|---|
| Strategy | Strategy Manager |
| Risk | Risk Manager |
| Trading | Trading Engine |
| Market Data | Market Data Manager |
| AI | AI Manager |
| Workflow | Workflow Engine |
| Copy Trading | Copy Trading Engine |
| Plugin | Plugin Manager |
| License | Licensing Manager |
| Notification | Notification Manager |
| Security/Audit | Security & Audit Manager |
| Operations | Operations Manager |

# 6. Consumer Rules

Consumer wajib:

- validasi event version;
- menangani duplicate delivery;
- menangani out-of-order event bila domain memungkinkan;
- retry transient failure;
- dead-letter permanent failure;
- tidak mengubah event historical;
- tidak menggunakan event sebagai pengganti source-of-record.

# 7. Trading Events

Contoh canonical lifecycle:

```text
trading_request.created
trading_request.risk_checked
order.created
order.submitted
order.accepted
order.rejected
order.cancelled
order.execution_received
deal.created
position.updated
position.closed
```

Trading event tidak boleh digunakan sebagai jalur eksekusi baru yang melewati Trading Engine.

# 8. Event Versioning

Breaking payload changes menghasilkan event version baru. Consumer lama tetap dipertahankan selama compatibility window yang ditetapkan.

# 9. Security

Event tidak boleh membawa plaintext password, API key, token, private key, atau credential.

# 10. Auditability

Critical events harus dapat ditelusuri melalui correlation/causation identity dan audit records bila diwajibkan domain.

# 11. Acceptance Criteria

- event ownership jelas;
- envelope versioned;
- idempotency defined;
- retry/dead-letter defined;
- persistence/event consistency defined;
- no event bypass terhadap risk/trading/security;
- schema konsisten dengan `DATA_FLOW.md` dan `DATABASE_DESIGN.md`.

# 12. Related Blueprints

- `DATA_FLOW.md`
- `MESSAGE_QUEUE.md`
- `ERROR_HANDLING.md`
- `DATABASE_DESIGN.md`
- `ARCHITECTURE.md`

# END OF EVENT_SYSTEM.md
