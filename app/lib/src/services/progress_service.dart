import '../core/models/puzzle_definition.dart';
import 'local_storage_service.dart';
import 'models.dart';

class ProgressService {
  ProgressService(this._storage);

  final LocalStorageService _storage;

  String _key(String profileId) => 'progress_${profileId}_v1';

  Future<List<PuzzleProgress>> loadProgress(String profileId) async {
    final entries = await _storage.getStringList(_key(profileId));
    return entries
        .map((entry) => PuzzleProgress.fromJson(decodeJsonMap(entry)))
        .toList(growable: false);
  }

  Future<void> recordSolve({
    required String profileId,
    required PuzzleDefinition definition,
    required int elapsedSeconds,
    required int hintsUsed,
  }) async {
    final progress = await loadProgress(profileId);
    final next = progress.where((p) => p.puzzleId != definition.id).toList();
    next.add(
      PuzzleProgress(
        puzzleId: definition.id,
        type: definition.type,
        difficulty: definition.difficulty,
        solved: true,
        elapsedSeconds: elapsedSeconds,
        hintsUsed: hintsUsed,
        lastSolvedAtIso: DateTime.now().toIso8601String(),
      ),
    );
    await _storage.setStringList(
      _key(profileId),
      next.map((p) => encodeJson(p.toJson())).toList(growable: false),
    );
  }

  Future<double> completionPercentForType(
    String profileId,
    PuzzleType type,
    int totalInType,
  ) async {
    if (totalInType <= 0) {
      return 0;
    }
    final progress = await loadProgress(profileId);
    final solved = progress.where((p) => p.type == type && p.solved).length;
    return (solved / totalInType) * 100;
  }
}
