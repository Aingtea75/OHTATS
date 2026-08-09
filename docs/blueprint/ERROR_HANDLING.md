# OHTATS — Error Handling Blueprint

> Menetapkan klasifikasi error, propagation, retry, recovery, observability, dan security rules OHTATS.

# Status

**ERROR HANDLING BASELINE — REVIEW**

**Version:** 1.0.0

# 1. Principles

- Error harus classified.
- Error harus aman diekspos ke consumer.
- Internal detail tidak boleh bocor ke client.
- Retry hanya untuk operasi retry-safe.
- Trading retry wajib idempotent.
- Permanent failure tidak boleh diulang tanpa diagnosis.
- Critical failure harus dapat diaudit.

# 2. Error Classes

| Class | Contoh | Default |
|---|---|---|
| Validation | invalid request | Reject |
| Authentication | invalid/expired credential | Reject |
| Authorization | permission denied | Reject |
| Policy | entitlement/risk/policy rejection | Reject |
| Domain | invalid lifecycle/state | Reject |
| Conflict | optimistic/concurrency conflict | Retry/readjust |
| Connector | broker/provider failure | Retry if safe |
| Timeout | external operation timeout | Retry if idempotent |
| Rate Limit | provider throttling | Delayed retry |
| Infrastructure | DB/queue/storage unavailable | Retry |
| Unknown | unexpected failure | Fail safe + alert |

# 3. Error Envelope

```json
{
  "error": {
    "code": "RISK_LIMIT_EXCEEDED",
    "message": "Request rejected by risk policy",
    "request_id": "...",
    "details": {}
  }
}
```

Client message harus aman dan tidak mengekspos stack trace, SQL, secret, provider token, atau credential.

# 4. Error Ownership

- API/application errors → Application/API layer.
- Domain errors → owning domain module.
- Connector errors → Connector Manager/adapter.
- Persistence errors → Persistence service.
- Queue errors → Queue/worker service.
- Security errors → Security & Audit Manager.

# 5. Retry Rules

Retry wajib mempertimbangkan:

1. apakah operation idempotent;
2. apakah external side effect sudah mungkin terjadi;
3. apakah error transient;
4. maximum attempts;
5. backoff;
6. dead-letter/escalation.

Tidak boleh retry blindly pada trading side effect.

# 6. Trading Failure

```text
Trading Request
      ↓
Validation
      ↓
Risk
      ↓
Order
      ↓
Connector
      ↓
Timeout / Unknown Result
      ↓
Reconciliation / Broker Query
      ↓
Resolve State
```

Jika broker result tidak diketahui, sistem harus melakukan reconciliation sebelum membuat instruction baru.

# 7. Transaction Failure

Database transaction harus rollback bila atomic operation gagal.

External operation tidak boleh dipertahankan di dalam long-running DB transaction hanya untuk menunggu response provider.

Gunakan state machine/outbox/compensation sesuai kebutuhan.

# 8. Event / Queue Failure

- transient delivery error → retry;
- repeated failure → dead letter;
- malformed event → reject/quarantine;
- duplicate event → idempotent handling;
- incompatible schema → version compatibility handling.

# 9. Logging

Log harus:

- structured;
- correlation-aware;
- sanitized;
- severity-aware.

Jangan log password, API key, token, private key, atau raw secret.

# 10. Audit

Critical errors yang memengaruhi security, risk, trading, authorization, configuration, atau administrative action harus menghasilkan audit evidence sesuai policy.

# 11. Recovery

Recovery action harus dapat ditelusuri dan tidak boleh diam-diam menghapus historical evidence.

# 12. Acceptance Criteria

- error classes defined;
- safe client contract defined;
- retry rules defined;
- trading unknown-result handling defined;
- queue/event failure defined;
- secrets protected;
- audit/observability defined;
- consistent with `DATA_FLOW.md`, `API_DESIGN.md`, and `MESSAGE_QUEUE.md`.

# 13. Related Blueprints

- `DATA_FLOW.md`
- `API_DESIGN.md`
- `EVENT_SYSTEM.md`
- `MESSAGE_QUEUE.md`
- `SECURITY.md`
- `TRADING_ENGINE.md`

# END OF ERROR_HANDLING.md
