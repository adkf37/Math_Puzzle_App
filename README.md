# Math Puzzle App

Cross-platform Flutter MVP for a free math puzzle app (ages 7-12).

## Structure
- `app/` Flutter app code.
- `app/assets/content/packs/` JSON content packs.
- `app/tool/validate_content.dart` content validator.
- `app/test/` unit tests.
- `backlog/tasks/` backlog checklist files.
- `docs/` product, architecture, schema, release docs.

## Run locally
```bash
cd app
flutter pub get
flutter run -d chrome
```

## Quality checks
```bash
cd app
flutter format --set-exit-if-changed .
flutter analyze
dart run tool/validate_content.dart
flutter test
```
