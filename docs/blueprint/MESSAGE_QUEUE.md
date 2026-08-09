# OHTATS — Message Queue Blueprint

> Menetapkan queue/worker semantics untuk asynchronous processing tanpa menjadikan queue sebagai source of truth.

# Status

**MESSAGE QUEUE BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principles

- Queue adalah transport/work execution mechanism.
- Persistent domain state tetap authoritative pada database/domain store.
- At-least-once delivery adalah baseline yang aman; consumer harus idempotent.
- Retry harus bounded.
- Poison message harus masuk dead-letter state.
- Secret tidak boleh berada pada payload plaintext.

# 2. Queue Categories

- domain event delivery;
- workflow jobs;
- AI/background jobs;
- market-data ingestion;
- notification delivery;
- reporting/export;
- backup/recovery jobs;
- integration retry;
- maintenance jobs.

# 3. Message Envelope

```json
{
  "message_id": "uuid",
  "message_type": "workflow.execute",
  "schema_version": 1,
  "created_at": "UTC",
  "correlation_id": "...",
  "causation_id": "...",
  "attempt": 1,
  "payload": {}
}
```

# 4. Delivery

Baseline:

```text
Producer
  ↓
Queue
  ↓
Worker Lease
  ↓
Process
  ├── ACK
  ├── RETRY
  └── DEAD LETTER
```

Worker crash tidak boleh menghasilkan destructive duplicate execution.

# 5. Retry Policy

Retry harus membedakan:

- transient error → retry;
- rate limit → delayed retry;
- timeout → retry sesuai idempotency;
- validation error → reject/dead-letter;
- authorization error → reject;
- permanent connector error → dead-letter/escalate.

Backoff dan maximum attempts harus configurable per queue class.

# 6. Trading Jobs

Trading execution job wajib memiliki:

- account scope;
- trading request ID;
- idempotency key;
- correlation ID;
- attempt count;
- timeout/lease policy.

Retry tidak boleh membuat new trading instruction ketika message merupakan retry dari request yang sama.

# 7. Security

Payload tidak boleh menyimpan:

- password;
- API key;
- token;
- private key;
- raw broker credentials.

Gunakan reference ID ke secure secret boundary.

# 8. Ordering

Ordering hanya dijamin pada scope yang memang membutuhkan ordering, misalnya lifecycle entity tertentu. Sistem tidak boleh mengasumsikan global ordering.

# 9. Dead Letter

Dead-letter message harus menyimpan metadata yang cukup untuk diagnosis tanpa menyimpan secret.

Operator harus dapat re-drive message setelah root cause diperbaiki.

# 10. Observability

Queue metrics minimal:

- queue depth;
- processing latency;
- success rate;
- retry rate;
- dead-letter count;
- worker utilization;
- oldest message age.

# 11. Acceptance Criteria

- queue tidak menjadi source of truth;
- idempotency tersedia;
- retry bounded;
- dead-letter defined;
- security payload rules defined;
- worker lifecycle defined;
- trading retry safe;
- event contract konsisten dengan `EVENT_SYSTEM.md`.

# 12. Related Blueprints

- `EVENT_SYSTEM.md`
- `DATA_FLOW.md`
- `ERROR_HANDLING.md`
- `WORKFLOW_ENGINE.md`
- `DATABASE_DESIGN.md`

# END OF MESSAGE_QUEUE.md
