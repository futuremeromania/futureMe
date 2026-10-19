# FutureMe — Backend API Specification

**Audience:** the backend developer building a standalone API service for the FutureMe Flutter app.
**Status:** the Flutter app is fully built. It currently talks *directly* to Firebase (Auth + Firestore) with no API layer in between. This document specifies the standalone backend that should replace that direct Firestore access, so the app can be repointed at a real API instead of a database SDK. **Nothing described here requires deleting the existing Firebase/Flutter code** — it stays as the reference implementation and fallback until the new backend is wired in screen by screen.

---

## 1. Why this backend exists

Today every screen in the app calls Firestore directly through three repository classes (`UserRepository`, `ModuleProgressRepository`, `ChatRepository`, all in `lib/core/data/`). There is no server-side logic anywhere — no validation, no AI calls, no payment verification. That was fine to ship a working prototype fast, but it means:

- The "AI chat" is a canned array of 3 rotating replies (`lib/feature/chat/chat_screen.dart`), not a real model.
- The "psychological profile" / "feedback" text shown after every module stage (INFJ profile, Big Five bars, decision-style labels, etc.) is **hardcoded illustrative copy**, identical for every user — it is not computed from their answers at all.
- The Module 5 "final report" (PDF + guided audio) does not exist. The app only writes `{status: 'not_generated'}` to Firestore and shows static screens.
- Subscription state is a client-set flag (`recordSubscriptionSelection`) with **zero server-side purchase verification**.
- The parent/guardian consent flow (for 14–15 year olds) doesn't send a real email or verify anything — the "Verifică acordul" button always succeeds.

The backend developer's job is to build the real thing behind those five gaps, exposed as a clean HTTP API the Flutter app can call. Everything else (screens, navigation, local state, Firebase Auth wiring) already works and should be treated as fixed UI contract to build against.

---

## 2. Recommended architecture

**Keep Firebase Authentication as the identity provider.** The app already has working, tested email/password, Google Sign-In, and Sign in with Apple flows wired through `firebase_auth` (`lib/core/auth/auth_service.dart`, `lib/core/auth/social_auth_config.dart`). Rebuilding that from scratch (password hashing, OAuth redirect handling, Apple's nonce dance) is real work with no product upside. Reusing it costs the backend nothing:

- The backend never touches passwords or OAuth tokens directly.
- Every API request from the app carries a **Firebase ID token** (`Authorization: Bearer <token>`).
- The backend verifies it server-side using the **Firebase Admin SDK** (`admin.auth().verifyIdToken(token)` in Node, or the equivalent in any language) — a few lines, no secret sharing, no custom JWT signing.
- The verified `uid` from the token is the user's identity for every endpoint below.

Everything *besides* auth — user profile, module answers, chat, AI report generation, subscriptions — moves out of direct Firestore access and into the new backend's own database (Postgres, Mongo, whatever the developer prefers). Firestore can be decommissioned for those collections once the migration is complete; it does not need to stay running long-term.

**Do not put business logic in Firestore Security Rules or Cloud Functions long-term.** The current `firestore.rules` (`allow read, write: if request.auth.uid == uid`) is intentionally permissive because the *client* currently does all the writing — that's exactly the pattern a standalone backend replaces. The new API server should be the only writer for anything server-computed (AI feedback, reports, entitlements).

```
Flutter app
   │  Authorization: Bearer <Firebase ID token>
   ▼
New backend API (this spec)  ──────►  Claude API (chat, analysis, report copy)
   │                                   │
   ▼                                   ▼
Backend's own DB                  PDF/audio generation, object storage
   (users, answers, chat,             (S3/GCS — signed URLs for download)
    reports, subscriptions)
   ▲
   │  verifies tokens against
   └──  Firebase Admin SDK
```

RevenueCat stays as the in-app-purchase layer (Apple/Google billing) — the backend's only job there is to receive RevenueCat's server-to-server webhook and record verified entitlement.

---

## 3. End-to-end user journey (what the API must support)

This is the exact sequence a user goes through today, screen by screen, so the backend developer can see where each endpoint gets called.

1. **Splash → Age gate.** User picks an age bracket: under 14 (blocked, restricted screen, no account created), 14–15 (parent/guardian consent required), 16–17 or 18+ (no consent step).
2. **Consent (14–15 only).** User enters a parent/guardian email. App currently *pretends* to send a link and lets the user self-confirm — see §6.4, this needs a real implementation.
3. **Sign up / log in.** Email+password, Google, or Apple, via Firebase Auth (client-side, unchanged). On first sign-in, the app calls the backend to create the user's profile, folding in the age bracket + consent state collected in steps 1–2.
4. **First name capture** → short onboarding video → **Dashboard**.
5. **Modules 1–5**, taken in order (a user can't skip ahead):
   - **Module 1** — 3 free-text questions ("Cunoaștere & context").
   - **Module 2** — 6 stages: MBTI-style point-split (32 pairs), then five 1–5 Likert-scale stages (Big Five/OCEAN, cognitive style, decision style, emotional patterns, locus of control — 50/25/20/30/20 statements respectively in the intended design, currently stubbed with 5-item placeholder banks). Each stage ends with a hardcoded "feedback" screen (needs to become real, see §6.2).
   - **Module 3** — 3 Likert-scale stages ("Interese & vocație").
   - **Module 4** — 1 Likert-scale stage ("Aptitudini & puncte forte").
   - **Module 5** — no new questions; synthesizes everything into direction cards, a 3-step plan, and triggers the **final report** (PDF + guided audio) — this is the AI report feedback download mentioned in scope, see §6.3.
6. **Chat.** Available from the dashboard and from every module's feedback screen, seeded with context about where the user came from (e.g. "Modulul 2 · Etapa 3 · Feedback scurt"). Needs to become a real Claude-backed conversation, grounded in the user's own answers/profile.
7. **Paywall.** Shown at a point in the flow the product team controls (currently reachable from the pricing screen); annual/monthly plan selection goes through native app-store billing (RevenueCat), not a custom checkout.
8. **Report download.** From the Module 5 report screens: preview, download (PDF), share, and listen to the guided audio.
9. **Retake.** "Reia evaluarea" resets all module statuses to `locked` (answer history is kept, not deleted) — capped at "3 evaluări / lună" per the paywall copy (not currently enforced anywhere; should be a backend-enforced limit).

---

## 4. Data model

These are the entities the backend needs to own. Field names below mirror what the Firestore prototype already uses (see `lib/core/data/*.dart`), so behavior stays consistent for the frontend team — but the backend developer is free to pick their own storage/schema as long as the API contract in §5 is met.

### User
```
uid                 string   — Firebase uid, primary key
email               string
displayName         string?
photoUrl            string?
authProvider        string   — 'password' | 'google.com' | 'apple.com'
ageBracket          string   — 'under14' | '14_15' | '16_17' | '18_plus'
consent: {
  required          bool
  status            string   — 'not_required' | 'pending' | 'confirmed'
  parentEmail       string?
  requestedAt       datetime?
  confirmedAt       datetime?
}
subscription: {
  status             string  — 'none' | 'active' | 'expired' | 'cancelled'
  plan               string? — 'annual' | 'monthly'
  provider           string  — 'revenuecat'
  entitlementId      string?
  currentPeriodEnd   datetime?
}
createdAt, updatedAt, lastLoginAt   datetime
```

### ModuleProgress (per user, per module)
```
moduleId    string   — 'module1' .. 'module5'
status      string   — 'locked' | 'in_progress' | 'completed'
startedAt, completedAt   datetime?
```

### Answer (per user, per module, per question)
```
questionKey     string   — e.g. 'q1', 'stage1_q7'
type            string   — 'text' | 'scale' | 'mbti'
value           any      — string for text; {selectedIndex} for scale (0-4);
                            {pointsForA, pointsForB} for mbti (sum to 5)
stage           int?     — module2/3 stage number
questionNumber  int?
updatedAt       datetime
```

### ChatMessage
```
sender          string   — 'user' | 'bot'
text            string
contextLabel    string   — which screen/module the chat was opened from
createdAt       datetime
```

### Report (one per user per completed run, or versioned per retake)
```
status          string   — 'not_generated' | 'generating' | 'ready' | 'failed'
pdfUrl          string?  — signed/expiring download URL once ready
audioUrl        string?  — guided audio file, once ready
summaryText     string?  — the synthesized profile text used to generate the PDF
generatedAt     datetime?
```

### Insight (per module/stage — the thing that replaces the hardcoded feedback copy)
```
scope           string   — 'module2_stage1', 'module2_stage2', ... 'module5_final'
profileLabel    string?  — e.g. "Profil orientativ"
profileValue    string?  — e.g. "INFJ", "Analitic"
profileDescription  string?
items: [{ icon, title, description, level: 'low'|'medium'|'high'|null, badgeLabel: string? }]
generatedAt     datetime
```

---

## 5. API surface

All endpoints require `Authorization: Bearer <Firebase ID token>` unless marked public. Base path suggestion: `/v1`.

### 5.1 Users & consent
| Method & path | Purpose |
|---|---|
| `POST /v1/users/bootstrap` | Called right after first Firebase sign-in. Body: `{ ageBracket, consentRequired, parentEmail?, firstName? }`. Creates the user profile server-side (replaces `UserRepository.createOrUpdateProfileOnSignIn`). Idempotent — logging in again just touches `lastLoginAt`. |
| `GET /v1/users/me` | Current user profile. |
| `PATCH /v1/users/me` | Update `displayName` etc. |
| `POST /v1/consent/request` | Body: `{ parentEmail }`. Sends the real guardian consent email (see §6.4). |
| `GET /v1/consent/status` | Poll consent state (`pending` / `confirmed`) so the app can unlock the flow once the guardian clicks the email link. |
| `GET /v1/consent/confirm?token=...` | **Public** (no auth header — opened by the *parent*, not the app). The link target from the consent email; marks consent confirmed. |

### 5.2 Modules & answers
| Method & path | Purpose |
|---|---|
| `GET /v1/modules/progress` | List of all 5 modules with `status`, `startedAt`, `completedAt`. Replaces `fetchCompletedCount`. |
| `POST /v1/modules/{moduleId}/start` | Marks a module `in_progress`. |
| `POST /v1/modules/{moduleId}/answers` | Body: `{ questionKey, type, value, stage?, questionNumber? }`. Upsert one answer (autosave-friendly — the app calls this ~every 600ms while typing, so it must be cheap/idempotent). |
| `GET /v1/modules/{moduleId}/answers` | All saved answers for a module (used to resume / prefill). |
| `POST /v1/modules/{moduleId}/complete` | Marks a module `completed`, and **triggers insight generation** for that module/stage (see §6.2) — the app expects the next screen's feedback content to be ready essentially immediately, so this should either return the insight synchronously or the client polls `GET /v1/modules/{moduleId}/insights`. |
| `GET /v1/modules/{moduleId}/insights?scope=...` | Fetch the generated feedback content for a stage/module (replaces the hardcoded `SummaryItem` lists in `module2_flow.dart` etc.). |
| `POST /v1/modules/reset` | Retake: resets all 5 modules to `locked`, keeps answer history. Must enforce the monthly retake cap (see §6.5). |

### 5.3 Chat
| Method & path | Purpose |
|---|---|
| `GET /v1/chat?contextLabel=...` | Message history for that context (replaces `ChatRepository.loadHistory`, capped/paginated similarly — currently limit 200). |
| `POST /v1/chat/messages` | Body: `{ contextLabel, text }`. Persists the user message, calls Claude with the user's profile/answers as context, persists and returns the bot reply. Should support streaming (SSE or chunked) since chat replies read out over Claude's API. |

### 5.4 Reports (the "AI report feedback download" endpoint)
| Method & path | Purpose |
|---|---|
| `POST /v1/reports/generate` | Triggered when the user finishes Module 5. Kicks off async generation: synthesize all answers + insights into report copy (Claude), render to PDF, generate/select the guided audio. Returns `{ status: 'generating' }` immediately — generation should NOT block the request (Figma's own spec assumes 15-20s+). |
| `GET /v1/reports/latest` | Poll status: `{ status, pdfUrl?, audioUrl? }`. The app polls this from the "Pregătim raportul tău" loading screen. |
| `GET /v1/reports/{reportId}/download` | Returns (or redirects to) the actual PDF bytes / a signed URL, for the download/share icons on the Report Preview screen. |

### 5.5 Subscription / entitlement
| Method & path | Purpose |
|---|---|
| `GET /v1/subscription` | Current entitlement status, for gating premium screens. |
| `POST /v1/webhooks/revenuecat` | **Public**, verified via RevenueCat's webhook signature/shared secret (not Firebase auth). Updates `subscription` on purchase/renewal/cancellation/expiration events. This is the piece that makes entitlement *real* instead of the current client-set "trust me" flag. |

---

## 6. The five things that need real implementation

These map 1:1 to the placeholders called out in §1 — this is the actual scope of backend work, everything above is just the plumbing to reach it.

### 6.1 AI chat (§5.3)
Replace `_placeholderBotReplies` with a real Claude API call. Ground each reply in: the user's profile bracket/first name, which module/stage they're chatting from (`contextLabel`), and their stored answers/insights so far — this is meant to feel like a coach who's read the user's answers, not a generic chatbot.

### 6.2 Per-stage insight generation (§5.2)
Every `ModuleFeedbackSummaryScreen` / `ModuleFinalFeedbackScreen` in the app today shows **the same hardcoded text for every user** (search `module2_flow.dart` for `SummaryItem` — the "INFJ" profile, the Big Five bars, etc. are static). The backend must actually compute this from the stored `Answer` records for that stage (Claude, or your own scoring logic for the MBTI/Likert stages) and return it in the `Insight` shape from §4, so the same UI renders real, per-user content.

### 6.3 Module 5 final report — PDF + audio (§5.4)
Currently just a Firestore stub (`recordModule5ReportPlaceholder` writes `{status: 'not_generated'}`). Needs: (1) a synthesis prompt to Claude that turns all 5 modules' answers + insights into report copy, (2) PDF rendering of that copy (any PDF lib server-side), (3) a guided audio file — either a pre-recorded pool of audio tracks selected by profile, or TTS over the synthesized text, and (4) object storage (S3/GCS) with signed download URLs.

### 6.4 Real parent/guardian consent (§5.1)
Today `SendEmailConsent` → `ConfirmConsent` is entirely simulated client-side — no email is sent, and the "Verifică acordul" button always succeeds regardless of what the guardian did. This is a GDPR-relevant flow for 14–15 year old users and needs to actually work: send a real email with a signed, single-use, expiring link; the guardian clicks it (no app install needed, plain web page is fine); the backend marks consent `confirmed`; the app polls or gets pushed the updated state before letting the user proceed past onboarding.

### 6.5 Real entitlement + retake limits (§5.5, §5.2)
Replace `recordSubscriptionSelection`'s unverified client flag with the RevenueCat webhook flow in §5.5. Also enforce the "2 din 3 evaluări disponibile luna aceasta" retake cap shown on the dashboard (`ModuleInfo`'s `_RetakeCard`) — currently just static copy, not an actual limit.

---

## 7. Non-functional notes

- **Locale:** all user-facing copy is Romanian. Any AI-generated content (chat replies, insights, report copy) must be generated in Romanian, matching the tone already established in the static copy (warm, non-clinical, avoids definitive/labeling language — e.g. "Acesta este un reper, nu o etichetă").
- **Minors:** ages 14–17 are core users. Treat all stored answers as sensitive data; the consent gate in §6.4 is a hard legal requirement, not a nice-to-have.
- **Idempotency:** answer autosave (§5.2) fires frequently and must handle rapid repeated calls cheaply — a plain upsert keyed on `(uid, moduleId, questionKey)` is sufficient.
- **Async by default:** report generation and possibly insight generation should never block the calling request — the client already has loading-screen UX built for polling.
- **Migration path:** since Firebase Auth stays, the safest rollout is repository-by-repository — point `ChatRepository` at the new API first (lowest risk, most visible AI upgrade), then `ModuleProgressRepository`/insights, then reports, then subscription. `UserRepository`'s profile-bootstrap call can move any time since it's a single write on signup.
