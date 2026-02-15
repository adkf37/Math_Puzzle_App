import '../core/content/content_loader.dart';
import '../core/models/puzzle_definition.dart';

class ContentRepository {
  ContentRepository(this._loader);

  static const String manifestPath = 'assets/content/packs/sample_mvp/manifest.json';

  final ContentLoader _loader;
  List<PuzzleDefinition>? _cache;

  Future<List<PuzzleDefinition>> loadAll() async {
    if (_cache != null) {
      return _cache!;
    }
    final manifest = await _loader.loadManifest(manifestPath);
    final all = <PuzzleDefinition>[];
    for (final path in manifest.packPathByType.values) {
      final list = await _loader.loadPuzzlesForType(path);
      all.addAll(list);
    }
    _cache = all;
    return all;
  }

  Future<List<PuzzleDefinition>> byType(PuzzleType type) async {
    final all = await loadAll();
    return all.where((p) => p.type == type).toList(growable: false);
  }

  Future<List<PuzzleDefinition>> byTypeAndDifficulty(
    PuzzleType type,
    Difficulty difficulty,
  ) async {
    final all = await byType(type);
    return all.where((p) => p.difficulty == difficulty).toList(growable: false);
  }
}
