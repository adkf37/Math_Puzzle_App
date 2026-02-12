# 04 — Puzzle Engine Core

## Outcomes
- Shared infrastructure for state, undo/redo, validation hooks

## Tasks
- [ ] Implement engine base:
  - [ ] immutable state updates (or careful mutation + snapshots)
  - [ ] undo/redo stack
  - [ ] timer + attempts
- [ ] Implement generic “check solved” pipeline
- [ ] Implement hint ladder support:
  - [ ] track hints used
  - [ ] lock “show solution” behind thresholds
- [ ] Add unit tests for engine base

## Definition of Done
- One puzzle type can run end-to-end with undo/redo and solved checks
