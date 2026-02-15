# 04 — Puzzle Engine Core

## Outcomes
- Shared infrastructure for state, undo/redo, validation hooks

## Tasks
- [x] Implement engine base:
  - [x] immutable state updates (or careful mutation + snapshots)
  - [x] undo/redo stack
  - [x] timer + attempts
- [x] Implement generic “check solved” pipeline
- [x] Implement hint ladder support:
  - [x] track hints used
  - [x] lock “show solution” behind thresholds
- [x] Add unit tests for engine base

## Definition of Done
- One puzzle type can run end-to-end with undo/redo and solved checks
