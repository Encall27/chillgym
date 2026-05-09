# ChillGym — Design Handoff

## Overview
Mobile-first fitness/workout-tracking app (412×868 iPhone canvas). Two themes
share the same layout system: **Warm Editorial** (default, light) and
**Dark Performance** (dark mode). Four core screens shipped: Today, Active
Workout, Progress, Calendar.

## About the Design Files
The HTML/JSX in this bundle are **design references** — React prototypes
rendered with inline Babel for fast iteration. They are NOT production code.
Recreate these designs in your target codebase (React Native, SwiftUI, Flutter,
or web React) using its established component library and patterns. If no app
environment exists yet, pick the framework appropriate for the platform and
implement against the design tokens below.

## Fidelity
**High-fidelity.** Final colors, typography, spacing, and structure. Match
pixel values. Tweak only where the target platform's component library forces
a different idiom (e.g. native iOS list rows vs custom rows).

## Layout System (shared by both themes)
Each screen is a vertical stack inside a 412×868 phone frame:

1. **Status bar** — 54px reserved at top (handled by the device frame, not the screen)
2. **Top nav bar** — `padding: 8px 18px 10px`, bottom border. Two rows:
   - leading text (left) / trailing text (right) — 14px, ink2
   - optional **large title block**: tiny uppercase eyebrow (10px / 0.18em tracking / ink3) + display title (28px serif italic in Warm; 24px Inter bold in Dark)
3. **Scroll body** — `flex: 1; overflow: auto; padding: 14px 16px 16px`
4. **Bottom tab bar** — 5 tabs: Today / Log / Progress / Calendar / You. `padding: 8px 8px 30px`, top border, active item shows a 18×2px amber underline above the icon.

The screen root has `boxSizing: border-box` and `paddingTop: 54` so it slots
into the device frame without overflowing the bezel.

## Screens

### 1. Today / Home
- **Streak hero card** — circular progress ring (radius 34, stroke 6) showing day count, gradient backdrop, eyebrow "● ON FIRE", 14-segment progress bar.
- **Next-up card** — full-bleed accent card (ink black in Warm; amber in Dark). Eyebrow "NEXT UP", title "Push Day · A", meta "5 EXERCISES · ~52 MIN", 50px play button.
- **2×2 metric grid** — 7-day volume / Est 1RM / Bodyweight / Sessions. Each card has a colored eyebrow, large number, unit, sparkline.
- **Recent list** — date / session label / sets · volume / chevron.

### 2. Active Workout
- **Top nav** — back chevron + elapsed timer.
- **Rest banner** — 64px ring + "RESTING" / "1:24" + +15s / Skip pills. Amber-tinted background.
- **Current exercise card** — eyebrow "EXERCISE 3 OF 5", title, "+8 KG" pill, set table (5-col grid: # / weight / reps / RIR / status).
- **Add Set / Repeat** — primary ink button + secondary ↻ button.
- **AI nudge** — amber-tinted callout with left border accent, "● THAT'S GOOD".
- **Up Next** list.
- **Bottom action bar** — Finish + Next.

### 3. Progress
- **Hero chart** — Est 1RM big number (56–52px serif/Inter), "↑ +8 kg" sage delta. Area-fill line chart, 12 weekly points, dot on latest.
- **Range chips** — 1M / 3M / 6M / 1Y / ALL. 3M selected.
- **Personal Bests list** — colored 4×28 marker bar / exercise name / weight × reps / "★ NEW" badge.

### 4. Calendar
- **Month grid** — 7×5 cells, weekday headers, intensity-based amber fill (0 / 0.35 / 0.7 / 1), selected cell with amber outline.
- **Heatmap legend** — LESS · 4 swatches · MORE.
- **Day detail card** — eyebrow "● 05.05 · TUESDAY", session title, 3 stat tiles (SETS / VOLUME / MAX) with colored eyebrows.
- **PR callout** — amber-tinted card with "★ NEW PR".

## Design Tokens

### Warm Editorial (light, default)
```
bg:         #F6F1E7   page background (cream)
bg2:        #EFE7D5   inset surfaces (calendar cells, stat tiles)
card:       #FFFFFF   cards, tab bar
border:     #E5DCCB   hairlines
ink:        #1B1814   primary text, dark accent surface
ink2:       #5C5247   secondary text
ink3:       #8A8076   tertiary / muted
amber:      #E0A82E   primary accent
amberDeep:  #9A6B12   amber on light (text), deep accent
amberPale:  #FBF5E8   amber tint backgrounds
good:       #3F6B4A   positive delta
rose:       #B5532A   warning / Push category
sage:       #6B8E76   secondary accent
sky:        #3A6B8C   secondary accent
```

### Dark Performance (dark)
```
bg:        #0B0B0F    page background
bg2:       #13141A    inset surfaces
card:      #1A1B22    cards
border:    #262833    hairlines
ink:       #F1EFE8    primary text
ink2:      #9C9DA8    secondary text
ink3:      #6E6F7A    tertiary
amber:     #FFB627    primary accent (matched to amber in light)
amberDim:  #3A2E10    amber tint background
lime:      #C8FF00    positive / accent
pink:      #FF4D8D    accent
cyan:      #5BE9F2    accent
good:      #3F8E5C
```

Glow effects in dark mode use `filter: drop-shadow(0 0 6px <color>)` on amber line/dot/stripe elements, plus `boxShadow: 0 0 20px <amber>33` on the next-up CTA. The light theme uses none of these shadows.

### Typography
- **Body / UI** — Inter (400, 500, 600, 700, 800)
- **Display (Warm Editorial only)** — Fraunces, italic, weight 300–500. Used for screen titles, hero numbers (`104`), session names ("Pull Day"), exercise names ("Bench Press"), and pull quotes (the AI nudge).
- **Numerics** — `font-variant-numeric: tabular-nums` everywhere a number is rendered.

Type scale (px):
```
hero number       56 (Warm 300 weight)  /  52 (Dark 800 weight)
display title     28 italic (Warm)      /  24 bold (Dark)
section heading   20 italic (Warm)      /  18 bold (Dark)
body              14
secondary         12
eyebrow / label   10  letter-spacing 0.14–0.18em  uppercase  weight 600
```

### Spacing & shape
- Card radius: **20px** (hero/feature), **16px** (medium), **12px** (small/pills).
- Pill radius: **999px**.
- Card padding: **18** (hero), **16** (standard), **14** (compact).
- Vertical rhythm between cards: **12px**.
- Hairlines (1px, theme `border` color) between list rows.
- Tab bar: 5 cells, `padding: 8px 8px 30px` (last 30px is iOS home-indicator clearance).

## Interactions
- Tabs route between Today / Log / Progress / Calendar / You.
- Tapping a recent session opens its detail.
- During active workout: tapping a set's "○" status logs the set and starts rest timer.
- "+15s" / "Skip" affect the rest timer countdown.
- Range chips (1M/3M/6M/1Y/ALL) refilter the Progress chart.
- Theme switch: respect system preference; allow manual override.
- All transitions: 150ms ease-out for state changes; 250ms ease for theme swap.

## State
- `theme`: 'light' | 'dark'
- `streak.days`, `streak.record`
- `activeWorkout`: { startedAt, exercises: [{ name, sets: [{ weight, reps, rir, done }] }], currentExerciseIdx, restingUntil }
- `progress.lift`: which lift is selected on Progress screen
- `progress.range`: '1M' | '3M' | '6M' | '1Y' | 'ALL'
- `calendar.selectedDate`

## Files
- `ChillGym UI Templates.html` — entry point (loads Babel + screens, mounts the canvas)
- `ios-frame.jsx` — iPhone bezel + status bar
- `design-canvas.jsx` — pan/zoom presentation grid (NOT for production)
- `screens/warm-editorial.jsx` — light theme, all 4 screens
- `screens/dark-performance.jsx` — dark theme, all 4 screens

The two `screens/*.jsx` files are the source of truth for the visual designs.
Open them side-by-side; the layout structure is intentionally identical between
themes so a single component tree can render both with a token swap.
