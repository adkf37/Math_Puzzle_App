# 03 — Content Pipeline (JSON Packs + Tooling)

## Outcomes
- Puzzles can be authored as JSON without code changes
- Validation tooling to catch bad content early

## Tasks
- [x] Define JSON schema for each puzzle type
- [x] Implement content loader:
  - [x] load pack manifest
  - [x] load per-type puzzle sets
- [x] Build a content validator tool:
  - [x] checks required fields
  - [x] checks solution validity via engine validator
  - [x] checks hint ladder length
- [x] Add sample pack:
  - [x] 10 puzzles for one type across 3 tiers
- [x] Add “content preview” developer screen

## Definition of Done
- Adding a JSON file adds puzzles to the app
- Validator fails CI if content is invalid
