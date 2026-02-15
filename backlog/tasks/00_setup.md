# 00 — Repo & Project Setup

## Outcomes
- Repo bootstrapped with chosen cross-platform framework
- CI builds for iOS/Android/Web
- Basic app shell running on all platforms

## Tasks
- [x] Decide framework: Flutter (default), Unity, or RN+Web
- [x] Initialize repo + standard structure (app/src/data/tests/backlog)
- [x] Set up formatting + linting + pre-commit hooks
- [x] Set up CI:
  - [x] build web
  - [x] build android
  - [x] build ios (if available in CI environment)
- [x] Add basic app navigation shell:
  - [x] Home
  - [x] Puzzle Select
  - [x] Profile
  - [x] Settings
- [x] Add placeholder “Puzzle Player” screen with dummy content
- [x] Add local storage layer (per-profile)

## Definition of Done
- App launches on web + at least one mobile platform
- CI runs on every PR/push
- Basic navigation works