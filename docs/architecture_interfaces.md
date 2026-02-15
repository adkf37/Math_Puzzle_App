# Architecture and Interfaces

## Layering
- `Content`: JSON puzzle packs and schemas.
- `Engine`: state lifecycle, undo/redo, timer, solved pipeline, hint gating.
- `Puzzle Modules`: renderer + validator + hint provider per puzzle type.
- `App Shell`: navigation, profile, progress, daily.
- `Services`: persistence, achievements, daily selection, content repository.

## Core abstractions
- `PuzzleDefinition`: authored puzzle content.
- `PuzzleState`: runtime state values and metadata (attempts/hints/time).
- `PuzzleRenderer`: UI board implementation for one puzzle type.
- `PuzzleValidator`: move legality, solved check, definition validation.
- `HintProvider`: 3-step ladder for contextual support.
- `PuzzleSessionEngine`: generic state engine and solved pipeline.

## Extending with a new puzzle type
1. Add JSON schema and content file path in manifest.
2. Implement `PuzzleRenderer`, `PuzzleValidator`, `HintProvider`.
3. Register module in `PuzzleRegistry`.
4. Add tutorial steps and sample puzzles.
5. Validate with `tool/validate_content.dart`.

## Serialization format
- JSON content packs with a manifest and per-type puzzle files.
- `PuzzleDefinition.fromJson` supports shared fields.
- Puzzle-type-specific fields are carried in `initial_state` and `solution`.

## Dependency injection
- App bootstraps services in `app/lib/src/app/app.dart`.
- `ServiceLocator` stores service singletons.
- `AppScope` exposes services to feature widgets.

## Optional event logging
- `EventLogger` interface supports telemetry swapping.
- `NoopEventLogger` default keeps MVP privacy-first.
