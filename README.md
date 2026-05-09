# gymwhenyouready

A cross-platform app for logging gym workouts and tracking long-term improvement.

## Goals

- Make logging a workout faster than writing it on a notepad.
- Give the user a clear, honest signal each session: are you under-training, training well, or have headroom for more?
- Show progress over weeks/months so motivation compounds.

## Non-goals (v1)

Saying no upfront protects the MVP. The following are explicitly out of scope for v1:

- Nutrition / calorie tracking
- Public social feed or follower graph
- AI form analysis from video
- Standalone wearable / watch companion app
- Coaching marketplace

## Tech stack

- **Flutter** — single codebase for iOS, Android, and Web.
- **Backend** — **Firebase** (Auth + Firestore + Storage + Cloud Messaging). Account-bound from day one; offline cache via a local DB (Drift or Isar) for in-gym reliability.
- **Theming** — Material 3 with `ColorScheme.fromSeed(warmSeed)`. One warm seed colour drives both light and dark modes.

## Launch plan

- **First platform: iOS.** TestFlight for beta, then App Store.
- Android and Web follow once iOS is stable.
- **Pricing: free** at launch. Revisit (freemium / paid tiers) only after there's real usage data.

> Note: iOS launch requires a paid Apple Developer account ($99/year) and App Store review (1–7 days per submission). Budget for this in the timeline.

---

## 0. Foundation (applies to all features)

### Authentication

- **SSO**: Apple, Google. (Apple is required by App Store policy if any other SSO is offered on iOS.)
- **Email + password** as a fallback for users who don't want to use SSO.
- ~~Microsoft SSO~~ — removed; not common in consumer fitness apps.
- ~~Guest / local-only mode~~ — removed from MVP. SSO already implies an account; guest mode complicates sync and is rarely used.

### Storage

- **Cloud-first** with local cache:
  - Source of truth lives in **Firestore**.
  - Local DB (Drift / Isar) caches recent sessions for offline-in-gym use.
  - Writes queue locally and sync when reconnected.
  - Media (progress photos, machine photos) lives in **Firebase Storage**.
- Export at any time: JSON / CSV.
- "Delete my data" control in settings (required for App Store and GDPR).

### Navigation

Bottom tabs (mobile) / side rail (web): **Log**, **History**, **Progress**, **Calendar**, **Library**, **Profile**.

---

## 1. User profile & training preferences

- Profile: name, height, current bodyweight, goal (strength / muscle / general fitness).
- Units: kg / lb, cm / in.
- Bodyweight tracked over time (lightweight — single number per day).
- Training preferences:
  - RIR / RPE prompts on / off.
  - Default rest timer per set type.
  - Warmup rule (auto-suggest warmup sets based on top weight).

---

## 2. Exercise library

- Built-in catalog of common strength exercises with muscle group tags.
- Search + filter by movement pattern (push / pull / squat / hinge / carry) and muscle group.
- **Custom exercises**: user-defined name, primary + secondary muscle tags, optional photo.
- Cardio exercises (running, cycling, rowing, etc.) supported with cardio-specific fields (see §3).

---

## 3. Workout logging (the core)

### 3.1 Session model

- A **session** has: date, optional workout type, optional location, optional tags.
- A session contains **exercises**, each with one or more **sets**.

### 3.2 Set fields

**Strength sets**:
- Weight, reps (required)
- RIR or RPE (optional, prompted if enabled in preferences)
- Tempo (optional, advanced)
- Per-set free-text notes
- Rest timer (auto-starts on set completion)

**Cardio sets**:
- Distance, duration, avg heart rate (optional)
- Notes

### 3.3 Logging UX

- **One-tap repeat last set** — duplicates weight/reps from the previous set.
- **Repeat last session for this exercise** — pre-fills sets from your most recent session of the same exercise.
- **Plate calculator** — tap a weight, see the plate combination per side (kg or lb bars).
- Edit / delete sessions and individual sets.
- "Top set" auto-tracked per exercise (heaviest set with reps ≥ 1) for progress charts.

### 3.4 Workout templates / routines  *(NEW — MVP)*

- User defines a reusable template: ordered list of exercises with target sets/reps.
- Examples: "Push Day", "Pull Day", "Legs A".
- One-tap **start session from template** pre-populates the day's plan; user fills in actual numbers.
- This is the single biggest UX win for repeat users — templates remove 80% of typing.

---

## 4. Training feedback: "One more set / That's good / Not enough"

### 4.1 What the user sees

After logging an exercise, show:
- Summary line: total sets, reps, load (and est. 1RM, see §6).
- A status badge: **Not enough**, **That's good**, or **One more set**.
- A short rationale ("Volume is below your 4-week average for this exercise").
- Optional next-session suggestion (e.g. "+2.5 kg next time" or "+1 set").

### 4.2 What drives the suggestion

Three inputs feed the rule-based engine:

1. **Volume** — current session volume (sets × reps × weight) vs. user's typical recent volume for that exercise.
2. **Effort** — RIR / RPE if provided. Closer to failure = lower confidence in "one more set".
3. **Recovery guardrails** — don't suggest more sets if the user trained the same muscle group < 48 h ago, or if session count this week is already high.

### 4.3 Cold start  *(important — added)*

A new user has no history. Without a cold-start path the feature is broken on day 1.

- For the first ~3 sessions per exercise, compare against **experience-level reference bands** (beginner / intermediate / advanced volume targets per muscle group). User picks experience level on signup.
- After ~3 sessions, transition to personal-history-based comparison.

### 4.4 Worked example

User logs **4 sets × 8 reps @ 55 kg** on pull-ups.

> "Solid session — 4×8 @ 55 kg. That's in line with your last 3 weeks."
>
> Next session, try one of:
> - **Conservative**: same weight, add 1 set.
> - **Progress**: 60 kg for 3–4 sets of 4–6 reps if form holds.

---

## 5. Photo attachments  *(MVP-lite — full camera recognition deferred)*

### MVP

- Attach a photo to an exercise (e.g. machine setup, form note).
- Generate a **share card** image summarising a workout (date, top set, total volume) for posting via the system share sheet to Instagram / wherever.
- Optional: scan a QR sticker the user places on their own gym machines, mapping the QR to a saved custom exercise.

### Phase 3 (deferred)

- Auto-recognise machine / equipment from a photo (OCR of labels, then later image recognition). This is brittle across gym brands and not worth the complexity in v1.

---

## 6. Progress tracking

### 6.1 Per-exercise charts

- Weight over time (top set).
- Reps over time at a given weight.
- Total volume per session.

### 6.2 Personal bests

- Best weight × reps combination.
- Best total set volume.
- **Estimated 1RM** using Epley / Brzycki formulas (clearly labelled "estimate"). Promoted from optional to standard — users expect it.

### 6.3 Bodyweight trend

- Line chart over time with a 7-day rolling average.

---

## 7. Calendar, streaks & tags

### 7.1 Calendar  *(MVP)*

- Heatmap of training days (GitHub-style).
- Tap a day → see that day's session(s).
- **Streaks** — current streak and longest streak. *Promoted to MVP — streaks are the primary in-app retention mechanic.*
- Days trained this week / month at a glance.

### 7.2 Tags per session

- **Place / gym** — saved gym list, optional location pin.
- **Weather** — manual selection at MVP; auto-fetch from location + timestamp later.
- **Friends trained with** — manual tag in MVP (free-text or from contacts). Friend graph deferred to Phase 3.

---

## 8. Body composition & progress photos

### 8.1 InBody / body composition  *(simplified for MVP)*

- **MVP**: manual entry of fat %, lean mass, weight; optional photo of the InBody report attached to the entry.
- **Phase 3**: OCR-assisted extraction with user confirmation. Deferred because InBody report layouts vary by machine model and OCR will be unreliable without per-format tuning.

### 8.2 Progress photos

- Upload daily / weekly body photos.
- Pose guide overlay to encourage consistent framing.
- Generate side-by-side and grid **collages** for 1 / 3 / 6 / 12 month milestones.
- ~~Auto-generated progress video~~ — deferred to Phase 3 due to compute cost and privacy considerations (rendering on-device requires care; cloud rendering means uploading body photos).

---

## 9. Health platform integration  *(NEW — MVP)*

- **Apple Health** (iOS) and **Health Connect** (Android) read/write.
- Write: workout duration, type, optional calorie estimate.
- Read: bodyweight, heart rate (when available, feeds smarter feedback later).
- Web: skip — these APIs don't exist on web.

This integration is small effort but big retention impact: users with rings / watches expect their workouts to flow into the platform health store.

---

## 10. Notifications  *(NEW — MVP)*

- Rest timer end (local notification).
- "You haven't trained in N days" nudge — keeps streaks alive.
- Weekly recap on Sunday evening.

Without notifications, streaks (§7.1) don't work — users forget.

---

## Roadmap

### Phase 1 — MVP

- SSO (Apple + Google) + Email/password
- Cloud-first storage with offline cache
- Exercise library (built-in + custom)
- Workout logging with all set fields including notes
- **Workout templates**
- Plate calculator
- Calendar + heatmap + **streaks**
- Per-exercise progress charts + estimated 1RM
- Feedback engine ("Not enough / That's good / One more set") with **cold-start reference bands**
- Photo attachment + share card export
- **Health platform integration** (Apple Health / Health Connect)
- **Notifications** (rest timer + inactivity nudge)
- Bodyweight tracking
- Data export (JSON/CSV) + delete-my-data

### Phase 2 — Body composition & richer media

- Manual InBody entry + photo attachment + trend charts
- Progress photo collages (1 / 3 / 6 / 12 month)
- Weather auto-tagging from location
- Tempo field rolled out + advanced analytics (muscle group volume balance, weekly load)

### Phase 3 — Smarter recognition & social depth

- Camera-based exercise / equipment recognition (OCR → image recognition)
- InBody OCR extraction with confirmation
- Progress video generation
- Friend graph + co-workout feed
- Public profile + opt-in social share
