# Math Puzzle App (Ages 7–12) — Project Overview

## One-liner
A free, cross-platform (iOS/Android/Web) math puzzle app for ages 7–12 with 5–10 puzzle types, multiple difficulty tiers, interactive tutorials, hints, and post-solve explanations.

## Product Goals
1. Make math practice feel like play through varied puzzle mechanics.
2. Support learning with scaffolding: tutorial → hints → explanation.
3. Keep kids engaged through progression, achievements, and a daily puzzle.
4. Run everywhere (mobile + web) with a single shared codebase.
5. Stay fully free to users (no paywalls, no IAP).

## Target Audience
- Primary: kids ages 7–12 (roughly grades 2–6)
- Secondary: parents/teachers who want progress visibility (optional reporting)

## Core Feature Set (MVP)
### Puzzle Types (initial 6; expandable to 10)
1. **Number Paths / Mazes** (rule-based navigation)
2. **Tiling / Polyomino Fit** (spatial packing)
3. **Sudoku Variant: Sumdoku** (row/col constraints + sums)
4. **Sudoku Variant: Inequality Sudoku** (>, < constraints)
5. **Arithmetic Crosswords / Skip-Counting Crosswords**
6. **Difference Pyramids** (number triangle relationships)

Optional later:
7. Pattern Riddles (find rule / missing number)
8. Balance Scales (equation intuition)
9. Symmetry/Transform puzzles
10. Logic Grid puzzles

### Learning Layer (must-have)
- **Interactive tutorial** for each puzzle type (guided example)
- **Hint ladder**: Hint 1 (general) → Hint 2 (directional) → Hint 3 (near-solution)
- **Post-solve explanation** (why it works + a reusable strategy tip)
- “Show solution” only after multiple hints or a confirm action

### Difficulty System
- 3 tiers per puzzle type (Easy / Medium / Hard)
- Within each tier: puzzles ordered by increasing challenge
- Optional adaptive suggestion: “Try Medium?” or “Drop to Easy?”

### Engagement
- Streak + **Daily Puzzle**
- Badges/achievements:
  - “Solved 10 in each category”
  - “No-hint solve”
  - “Daily streak 7”
- Lightweight progress map (“Academy rooms” per puzzle type)

### Profiles & Safety
- Multiple local profiles (family tablet)
- Minimal data collection; optional anonymous analytics
- Kid-safe: no chat, no public leaderboards in MVP

## Non-Goals (initially)
- Multiplayer, social feeds, real-time competitions
- Content marketplace, paid packs, subscriptions
- Large narrative campaign with cutscenes

## Tech Recommendation (cross-platform)
Pick one:

### Option A: Unity (best for puzzle interaction, animations, consistent UI)
- Pros: great for touch interaction and puzzle boards, easy builds to iOS/Android/WebGL
- Cons: heavier build size, WebGL constraints, dev style different from web stack

### Option B: Flutter (great UI, strong cross-platform)
- Pros: fast iteration, excellent UI control, runs on iOS/Android/Web
- Cons: some puzzle interactions require careful custom rendering

### Option C: React Native + Web (Expo + Next.js)
- Pros: web-friendly, strong ecosystem
- Cons: more complexity for custom board rendering, cross-platform parity work

**Default for this app:** Flutter (Option B) unless you strongly prefer Unity.

## Architecture (content-driven)
### Core layers
1. **Puzzle Engine**
   - data model for puzzle state
   - validators (is move legal? is puzzle solved?)
   - hint generator hooks
2. **Content Pack**
   - puzzle definitions in JSON
   - metadata: type, difficulty, skills, solution, hint steps, explanation text
3. **UI Layer**
   - puzzle renderer per type
   - shared shells: nav, profile switch, progress, achievements
4. **Telemetry (optional)**
   - only anonymous events: puzzle_start, hint_used, solved, time_to_solve

## Content Spec (JSON-ish)
Each puzzle:
- id, type, difficulty, recommended_age_band
- prompt + rules
- initial_state
- solution (canonical or set of valid solutions)
- hints: [hint1, hint2, hint3]
- explanation: steps + strategy_tip
- tags: (logic, arithmetic, geometry, pattern)

## Milestones
1. **Prototype**: 1 puzzle type end-to-end (tutorial + hints + explanation)
2. **MVP**: 6 puzzle types, 3 tiers each, 30–50 puzzles per type
3. **Polish**: achievements, daily puzzle, better hints, content expansion
4. **Launch**: store listings, privacy policy, classroom mode (optional)

## Definition of Done (MVP)
- App runs on iOS, Android, Web
- 6 puzzle types implemented with:
  - tutorial, hint ladder, explanation
  - 3 difficulty tiers each
- Profiles, progress tracking, achievements basics
- Daily puzzle works
- Content pipeline: add puzzles via JSON without code changes
- Basic QA + accessibility pass (touch targets, readable text, offline play)
