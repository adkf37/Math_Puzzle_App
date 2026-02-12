# 03 — Content Pipeline (JSON Packs + Tooling)

## Outcomes
- Puzzles can be authored as JSON without code changes
- Validation tooling to catch bad content early

## Tasks
- [ ] Define JSON schema for each puzzle type
- [ ] Implement content loader:
  - [ ] load pack manifest
  - [ ] load per-type puzzle sets
- [ ] Build a content validator tool:
  - [ ] checks required fields
  - [ ] checks solution validity via engine validator
  - [ ] checks hint ladder length
- [ ] Add sample pack:
  - [ ] 10 puzzles for one type across 3 tiers
- [ ] Add “content preview” developer screen

## Definition of Done
- Adding a JSON file adds puzzles to the app
- Validator fails CI if content is invalid
