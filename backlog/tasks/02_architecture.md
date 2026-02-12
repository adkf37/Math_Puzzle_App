# 02 — Architecture & Interfaces

## Outcomes
- Clean separation: engine vs UI vs content
- Interfaces ready for adding new puzzle types without refactor

## Tasks
- [ ] Define core abstractions:
  - [ ] PuzzleDefinition (content)
  - [ ] PuzzleState (runtime)
  - [ ] PuzzleRenderer (UI)
  - [ ] PuzzleValidator (rules)
  - [ ] HintProvider (hint ladder)
- [ ] Define event logging interface (optional)
- [ ] Decide serialization format for content (JSON)
- [ ] Implement app-level dependency injection / service locator

## Definition of Done
- New puzzle type can be added by implementing 3–4 interfaces + adding content files
