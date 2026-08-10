# OHTATS Internationalization Foundation

> Dokumen ini mendefinisikan internationalization (i18n) dan localization (l10n)
> sebagai **cross-cutting capability** untuk platform global OHTATS.
>
> i18n/l10n mengatur preferensi bahasa, locale, presentasi, dan katalog terjemahan.
> i18n **bukan** domain owner untuk Trading, Risk, Workflow, Backtest, Copy Trading,
> Connector, atau Broker.
>
> Bahasa tidak boleh mengubah business logic, trading lifecycle, risk decision,
> atau semantics perintah broker.

**Status:** REVIEW

**Version:** 1.0.0

**Authority:** Internationalization & localization foundation reference

---

# 1. Purpose

Menyediakan foundation agar OHTATS dapat dilayani kepada pengguna dari berbagai
bahasa dan wilayah tanpa mengubah canonical architecture, trading path, atau risk controls.

Tujuan utama:

- presentasi multi-bahasa yang konsisten;
- locale-aware formatting (tanggal, waktu, angka, mata uang);
- preferensi bahasa pengguna yang jelas;
- governance katalog terjemahan;
- pemisahan identifier internal (language-neutral) dari label UI;
- dukungan presentasi RTL sebagai concern presentasi;
- boundary aman terhadap AI, notifikasi, error, dan security messaging.

---

# 2. Scope

**In scope**

- language preference;
- locale resolution;
- translation catalog governance;
- UI and user-documentation localization policy;
- AI language preference (presentation);
- date/time/number/currency **display** rules;
- timezone **display** vs internal time representation;
- RTL presentation rules;
- missing-translation and fallback behavior;
- testing expectations for i18n.

**Out of scope (this foundation does not implement)**

- shipping concrete language packs;
- installing i18n libraries;
- frontend code;
- database schema changes;
- API contract changes;
- trading/risk/workflow domain logic changes.

Availability of any specific language remains **planned** until implemented and validated.

---

# 3. Internationalization Principles

1. **Cross-cutting** — i18n applies across UI, docs, notifications, and messages without owning domains.
2. **Language-neutral core** — internal identifiers, schemas, and commands stay English-token or code-stable.
3. **Presentation only** — localization changes display, not trading semantics.
4. **Fail safe** — missing translations fall back; they do not change authorization or risk outcomes.
5. **User preference respected** within allowed catalogs.
6. **No invented availability** — do not claim a language is live until shipped.
7. **Security first** — translation content is untrusted input until reviewed for injection risks.
8. **Consistent fallbacks** — always have a defined fallback language path.
9. **Testable** — critical flows must be testable with locale variation without changing domain asserts.
10. **Blueprint precedence** — architecture/trading/risk blueprints win over presentation concerns.

---

# 4. Localization Principles

1. Localize labels, help text, and user-visible messages.
2. Do not localize canonical identifiers used in code, APIs, or audit keys.
3. Format numbers, dates, and currencies for display according to locale rules without mutating stored values.
4. Keep domain validation messages keyed; render localized text at the edge.
5. Respect text direction for supported locales (including RTL) as a presentation concern.
6. Prefer professional review for high-risk messaging (security, trading risk warnings).

---

# 5. Language vs Locale

| Concept | Meaning |
|---|---|
| **Language** | Human language for text (e.g. `en`, `id`) |
| **Locale** | Language + region + formatting conventions (e.g. `en-US`, `id-ID`) |

Language selects translation catalogs. Locale selects formatting (date, number, currency display patterns).

A user may have language `id` with locale `id-ID` for formatting while internal storage remains language-neutral.

---

# 6. Canonical Source Language

**Canonical source language for catalogs and blueprint prose:** English (`en`), unless a specific document is intentionally authored otherwise.

Internal keys, schema names, event type codes, and risk decision codes remain language-neutral tokens (typically English-based identifiers).

---

# 7. Supported Language Model

Languages are enabled through an explicit supported-language registry (implementation planned).

This foundation does **not** claim any particular language is already available in production.

Future registry entries should include at minimum:

- language code (BCP 47 style);
- locale examples;
- catalog version;
- maturity (PLANNED / DRAFT / REVIEW / APPROVED / PUBLISHED);
- RTL flag if applicable.

---

# 8. User Language Preference

Users may set a preferred language when the product surface supports it.

Preference is a user/tenant configuration concern, not a change to trading domain models.

If preference is unset, resolution follows §10.

---

# 9. Browser / Device Locale Detection

Clients may propose a detected locale (browser/device) as a **hint** only.

Detection must not override explicit user preference and must not expand privileges.

---

# 10. Locale Resolution Priority

Recommended resolution order (foundation):

1. Explicit user language/locale preference (if set and supported).
2. Explicit tenant/org default (if configured and supported).
3. Client-provided Accept-Language / device hint (if allowed and supported).
4. Platform default language (§11).
5. Fallback language (§12).

Unsupported codes resolve to the next priority step; they do not error the trading path.

---

# 11. Default Language

**Platform default language:** English (`en`), unless governance later documents a different default.

Default is for presentation fallback, not for rewriting historical audit records.

---

# 12. Fallback Language

If a key is missing in the selected language catalog:

1. try fallback language catalog (default: English);
2. if still missing, show a safe key-based or generic message without leaking secrets;
3. log/metric the missing key for catalog quality (without sensitive data).

Fallback must not alter HTTP status semantics of authorization/risk failures beyond presentation of the message body.

---

# 13. Translation Catalog

Translation catalogs map **stable keys** → localized strings.

Catalogs are versioned artifacts (implementation planned). They are not the source of truth for architecture.

Catalogs must not embed secrets, live credentials, or environment-specific private endpoints.

---

# 14. Translation Key Governance

Rules:

- keys are stable, language-neutral identifiers;
- keys describe meaning, not a particular English sentence forever frozen as the only source string if governance allows copy edits;
- renaming keys requires migration/compatibility notes;
- keys for security and risk warnings are high-care and require review.

Example key style (illustrative, not an API contract):

`risk.gate.denied`, `auth.session.expired`, `trading.request.accepted`

---

# 15. Translation Versioning

Catalogs should be versioned so deployments can pin or roll forward translations independently of domain logic when possible.

Breaking copy changes for legal/risk warnings should be reviewable and attributable.

---

# 16. UI Localization

UI strings (labels, buttons, empty states, help) are localized through catalogs when the client layer implements i18n.

This foundation does **not** invent specific screens or control labels.

UI localization must not expose debug-only internal identifiers as the only user communication for critical failures when a localized message exists.

---

# 17. User Documentation Localization

`docs/user-guide/` follows this blueprint for language strategy.

Translated user docs are **derivative** of approved content; they do not become architecture source of truth.

If translation and English user-guide conflict on controls, English blueprint + canonical guides are corrected first, then translations follow.

---

# 18. AI Language Handling

AI may interact in the user’s preferred language for conversational presentation when implemented.

AI systems must still:

- emit or map to **canonical structured outputs** where required by domain contracts;
- pass validation and the normal control path for any executable effect;
- never treat localized natural language as a substitute for schema identifiers.

---

# 19. AI Output Language Preference

Preferred response language may follow user preference (e.g. `id-ID` → Bahasa Indonesia).

Preferred language does **not**:

- grant broker access;
- bypass Risk Manager or Trading Engine;
- change risk decision codes or order state machines.

---

# 20. Date Formatting

Display dates according to active locale conventions.

Internal storage and APIs use consistent canonical representations; display formatting is a presentation concern.

---

# 21. Time Formatting

Display times according to locale and user timezone preference.

Do not redefine domain event ordering by local wall-clock alone; ordering follows canonical timestamps.

---

# 22. Timezone Handling

**Internal canonical time foundation:** UTC.

**Display:** user-selected timezone and locale formatting.

Rules:

- do not rewrite stored database timestamps because of UI language;
- user timezone is presentation/configuration metadata;
- trading session rules belonging to markets/brokers remain domain/connector concerns, not pure i18n.

---

# 23. Number Formatting

Locale may change grouping and decimal separators **for display**.

Parsing of user input must be explicit and safe; ambiguous localized input must not silently corrupt quantities.

Domain validation of quantity/price precision remains with trading/instrument rules, not with i18n alone.

---

# 24. Currency Formatting

Currency **display** (symbol placement, separators) is locale-aware.

Internal monetary representation and currency codes remain domain-defined.

Localization must **not** change monetary values solely due to locale.

Currency conversion, if ever offered, is a domain/service concern with explicit rates and audit—not an i18n side effect.

This foundation does **not** claim conversion features are available.

---

# 25. Decimal / Precision Rules

Instrument tick size, volume step, and price precision are **domain/instrument rules**.

i18n must not round away required precision for execution semantics.

Display may truncate/ellipsis only when clearly marked as display-only and never used as the executable source value.

---

# 26. Pluralization

Catalogs should support plural rules appropriate to the language when implemented.

Plural selection is a presentation concern and must not branch trading state machines.

---

# 27. Text Direction / RTL

RTL languages (e.g. Arabic) are supported as a **presentation** concern when those languages are enabled.

Rules:

- layout mirroring is UI-layer;
- domain logic does not special-case RTL;
- mixed LTR identifiers (codes, symbols) remain readable in RTL layouts via standard bidi practices.

No claim is made that Arabic or any RTL language is already shipped.

---

# 28. Locale-aware Notifications

Notification content may be localized using the recipient’s language preference when notification pipelines support catalogs.

Notification localization does not change delivery authorization or suppress security-critical notices.

---

# 29. Locale-aware Reporting

Reports may present headers and labels in the user’s language; underlying figures remain canonical values.

Export formats should preserve unambiguous numeric/date representations where downstream systems require it.

---

# 30. Locale-aware Error Messages

User-visible error messages may be localized by key.

Machine-oriented error codes remain stable and language-neutral.

Do not localize away the stable code needed for support diagnostics.

---

# 31. Locale-aware Security Messages

Security messages (login failure, lockout, revoke) may be localized but must remain clear and non-leaky.

High-risk security copy should prefer human review (§40).

Language choice must not weaken authentication or authorization outcomes.

---

# 32. Locale-aware Trading Display

Order/position/PnL **labels** may be localized.

State names shown to users may be localized mappings of canonical states.

Canonical state values used by Trading Engine remain language-neutral.

---

# 33. Canonical Trading Identifiers

Internal identifiers remain language-neutral. Examples of **token style** (not an exhaustive API list):

- `risk_gate`
- `trading_engine`
- `stop_loss`
- `take_profit`
- `backtest`
- `forward_test`
- `position`
- `order`

UI may show translated labels for these concepts. Code, events, and schemas must not use translated prose as primary identifiers.

---

# 34. API / Internal Identifier Language Rules

API field names, enum codes, and event type names are language-neutral.

Localized messages, if returned, are additive presentation fields and must not replace stable codes.

This blueprint does not invent concrete endpoints.

---

# 35. Database Language Rules

Persistent canonical entities follow `DATABASE_DESIGN.md` / `ERD.md`.

i18n foundation does **not** add schema.

If translations are stored in the future, they must not duplicate or replace authoritative financial history tables and must not store secrets.

Historical financial records are not rewritten when a user changes language.

---

# 36. Search / Sorting Localization

Locale-aware collation/search may be applied to user-visible text fields when implemented.

Canonical identifiers and codes sort by stable code order, not by translated labels, unless a dedicated display sort is explicitly defined.

---

# 37. User-generated Content

User-generated content (notes, names, comments) is stored as provided, subject to security validation.

i18n does not auto-translate UGC unless a future feature explicitly offers it with clear labeling.

UGC is untrusted for injection purposes.

---

# 38. Translation Quality

Quality bars increase with risk impact:

| Content class | Expected care |
|---|---|
| Marketing/help | Standard review |
| Trading risk warnings | Elevated review |
| Security messages | Elevated review |
| Legal/compliance text | Formal review when applicable |

---

# 39. Machine Translation Boundaries

Machine translation may assist draft catalogs.

Machine output is **not** automatically approved for security, risk, or legal messaging.

Machine translation must not invent product capabilities or financial promises.

---

# 40. Human Translation Review

Human review is required for elevated-care content before PUBLISHED status of those strings.

Review records should be attributable under normal documentation/governance practice.

---

# 41. Translation Security

Translation assets:

- must not contain secrets;
- must be integrity-protected in the delivery pipeline when implemented;
- must be treated as potentially hostile if sourced from untrusted contributors (marketplace/community).

Compromised catalogs are a security incident class (presentation integrity), not a reason to disable Risk Gate.

---

# 42. Translation Injection / Untrusted Content

Translated strings must not be executed as code.

Interpolation must prevent HTML/script injection in web clients and analogous injection in other clients.

Never interpolate untrusted user content into security message templates without encoding.

---

# 43. Accessibility

Localization should preserve accessibility:

- adequate contrast and readable truncation rules remain UI concerns;
- language changes must not remove text alternatives required for a11y where implemented;
- RTL layout must keep focus order usable.

Detailed a11y standards may live in future UI/accessibility docs; i18n must not regress them.

---

# 44. Testing Strategy

Aligned with `TESTING_STRATEGY.md` principles:

- unit tests for key resolution and fallback;
- tests that domain decisions are invariant across locales;
- tests that missing keys fall back safely;
- presentation tests for RTL when those languages are enabled;
- no live broker dependency for i18n tests;
- no production secrets in locale fixtures.

---

# 45. Missing Translation Handling

Missing key → fallback language → safe generic message.

Telemetry may count missing keys.

Missing translation is never an implicit allow for trading or authorization.

---

# 46. Fallback Failure Handling

If both primary and fallback catalogs fail to load:

- fail soft for pure presentation;
- keep authentication, authorization, and risk evaluation operational with stable codes;
- avoid user-visible stack traces or secret material.

---

# 47. Language Extension Process

To add a language (process foundation):

1. propose language/locale codes and RTL needs;
2. create catalog draft;
3. review elevated-care strings;
4. test fallback and critical flows;
5. publish with explicit maturity status;
6. document in the supported-language registry.

No language is “supported” merely by appearing as an example in this document.

---

# 48. Governance

- Document status: **REVIEW** (not APPROVED, not LOCKED).
- Changes to i18n rules that affect security or trading presentation of mandatory warnings require review.
- This document does not alter Constitution status vocabulary.
- User Guide localization follows this blueprint; blueprints remain architectural source of truth.

---

# 49. Acceptance Criteria

This foundation is ready for continued review when:

- i18n is defined as cross-cutting, not a trading/risk owner;
- language vs locale is explicit;
- canonical source and fallback languages are defined;
- internal identifiers remain language-neutral;
- UTC internal time vs local display is explicit;
- currency display vs monetary value separation is explicit;
- RTL is presentation-only;
- AI language preference cannot bypass controls;
- missing translation handling is fail-safe;
- no schema/API/source implementation is required for this PR;
- no specific language availability is falsely claimed.

---

# 50. Future Internationalization Extensions

Possible future work (not claimed as done):

- concrete language packs and CI catalog checks;
- translator workflow and review tooling;
- per-tenant language allowlists;
- advanced ICU plural/select rules;
- locale-aware search infrastructure;
- optional machine-translation assist with mandatory human gates for high-care strings.

Extensions must not:

- move risk authority out of Risk Manager;
- move trading lifecycle out of Trading Engine;
- allow AI/Workflow/Plugin/API direct broker access;
- alter canonical trading path semantics via translation.

---

# Related Documents

- `PROJECT_CONSTITUTION.md`
- `ARCHITECTURE.md`
- `MODULE_SPECIFICATION.md`
- `SECURITY.md`
- `TESTING_STRATEGY.md`
- `ROADMAP.md`
- `TRADING_ENGINE.md`
- `RISK_MANAGEMENT.md`
- `AI_ARCHITECTURE.md`
- `../user-guide/README.md`

---

# END OF INTERNATIONALIZATION.md
