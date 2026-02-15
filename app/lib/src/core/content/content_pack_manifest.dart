import '../models/puzzle_definition.dart';

class ContentPackManifest {
  const ContentPackManifest({
    required this.id,
    required this.version,
    required this.displayName,
    required this.packPathByType,
  });

  final String id;
  final String version;
  final String displayName;
  final Map<PuzzleType, String> packPathByType;
}
