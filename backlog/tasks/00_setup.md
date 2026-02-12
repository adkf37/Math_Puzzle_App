# 00 — Repo & Project Setup

## Outcomes
- Repo bootstrapped with chosen cross-platform framework
- CI builds for iOS/Android/Web
- Basic app shell running on all platforms

## Tasks
- [ ] Decide framework: Flutter (default), Unity, or RN+Web
- [ ] Initialize repo + standard structure (app/src/data/tests/backlog)
- [ ] Set up formatting + linting + pre-commit hooks
- [ ] Set up CI:
  - [ ] build web
  - [ ] build android
  - [ ] build ios (if available in CI environment)
- [ ] Add basic app navigation shell:
  - [ ] Home
  - [ ] Puzzle Select
  - [ ] Profile
  - [ ] Settings
- [ ] Add placeholder “Puzzle Player” screen with dummy content
- [ ] Add local storage layer (per-profile)

## Definition of Done
- App launches on web + at least one mobile platform
- CI runs on every PR/push
- Basic navigation works
