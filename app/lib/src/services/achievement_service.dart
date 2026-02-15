import '../core/models/puzzle_definition.dart';
import 'local_storage_service.dart';
import 'models.dart';
import 'progress_service.dart';

class AchievementService {
  AchievementService(this._storage, this._progressService);

  final LocalStorageService _storage;
  final ProgressService _progressService;

  String _key(String profileId) => 'achievements_${profileId}_v1';

  Future<AchievementState> loadState(String profileId) async {
    final raw = await _storage.getString(_key(profileId));
    if (raw == null || raw.isEmpty) {
      return const AchievementState(unlockedIds: <String>[]);
    }
    return AchievementState.fromJson(decodeJsonMap(raw));
  }

  Future<AchievementState> refreshForProfile(
    String profileId, {
    required List<PuzzleDefinition> definitions,
  }) async {
    final progress = await _progressService.loadProgress(profileId);
    final unlocked = <String>{...(await loadState(profileId)).unlockedIds};

    final solvedNoHint = progress.where((p) => p.solved && p.hintsUsed == 0).length;
    if (solvedNoHint >= 1) {
      unlocked.add('no_hint_solve');
    }

    for (final type in PuzzleType.values) {
      final typeDefinitions = definitions.where((d) => d.type == type).length;
      if (typeDefinitions == 0) {
        continue;
      }
      final solvedInType = progress.where((p) => p.type == type && p.solved).length;
      if (solvedInType >= 10) {
        unlocked.add('solve_10_${type.name}');
      }
    }

    final state = AchievementState(unlockedIds: unlocked.toList()..sort());
    await _storage.setString(_key(profileId), encodeJson(state.toJson()));
    return state;
  }

  Future<AchievementState> unlock(String profileId, String achievementId) async {
    final state = await loadState(profileId);
    final unlocked = <String>{...state.unlockedIds, achievementId}.toList()..sort();
    final next = AchievementState(unlockedIds: unlocked);
    await _storage.setString(_key(profileId), encodeJson(next.toJson()));
    return next;
  }
}
