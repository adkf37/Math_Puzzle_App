# 02 — Architecture & Interfaces

## Outcomes
- Clean separation: engine vs UI vs content
- Interfaces ready for adding new puzzle types without refactor

## Tasks
- [x] Define core abstractions:
  - [x] PuzzleDefinition (content)
  - [x] PuzzleState (runtime)
  - [x] PuzzleRenderer (UI)
  - [x] PuzzleValidator (rules)
  - [x] HintProvider (hint ladder)
- [x] Define event logging interface (optional)
- [x] Decide serialization format for content (JSON)
- [x] Implement app-level dependency injection / service locator

## Definition of Done
- New puzzle type can be added by implementing 3–4 interfaces + adding content files
