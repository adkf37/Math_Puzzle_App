import '../core/models/puzzle_definition.dart';
import 'local_storage_service.dart';
import 'models.dart';
import 'progress_service.dart';

class DailyPuzzleService {
  DailyPuzzleService(this._storage, this._progressService);

  final LocalStorageService _storage;
  final ProgressService _progressService;

  String _streakKey(String profileId) => 'daily_streak_${profileId}_v1';
  String _cacheKey(String profileId) => 'daily_cache_${profileId}_v1';

  PuzzleDefinition pickDailyPuzzle(
    DateTime date,
    List<PuzzleDefinition> allPuzzles, {
    List<PuzzleType>? rotation,
  }) {
    if (allPuzzles.isEmpty) {
      throw StateError('No puzzles available');
    }
    final types = rotation ?? PuzzleType.values;
    final type = types[date.difference(DateTime.utc(2024, 1, 1)).inDays % types.length];
    final sameType = allPuzzles.where((p) => p.type == type).toList();
    final pool = sameType.isEmpty ? allPuzzles : sameType;
    return pool[date.day % pool.length];
  }

  Future<void> cacheDaily(
    String profileId, {
    required DateTime date,
    required String puzzleId,
  }) async {
    final rows = await _storage.getStringList(_cacheKey(profileId));
    final dateKey = _dateOnly(date);
    final filtered =
        rows.where((entry) => !entry.startsWith('$dateKey|')).toList(growable: true);
    filtered.add('$dateKey|$puzzleId');
    filtered.sort();
    if (filtered.length > 7) {
      filtered.removeRange(0, filtered.length - 7);
    }
    await _storage.setStringList(_cacheKey(profileId), filtered);
  }

  Future<List<String>> loadCachedDaily(String profileId) async {
    return _storage.getStringList(_cacheKey(profileId));
  }

  Future<DailyStreak> loadStreak(String profileId) async {
    final raw = await _storage.getString(_streakKey(profileId));
    if (raw == null || raw.isEmpty) {
      return const DailyStreak(current: 0, best: 0, lastCompletedDate: null);
    }
    return DailyStreak.fromJson(decodeJsonMap(raw));
  }

  Future<DailyStreak> markCompleted(String profileId, DateTime date) async {
    final prev = await loadStreak(profileId);
    final today = _dateOnly(date);
    final yesterday = _dateOnly(date.subtract(const Duration(days: 1)));
    int current = prev.current;
    if (prev.lastCompletedDate == today) {
      return prev;
    }
    if (prev.lastCompletedDate == yesterday) {
      current += 1;
    } else {
      current = 1;
    }
    final next = DailyStreak(
      current: current,
      best: current > prev.best ? current : prev.best,
      lastCompletedDate: today,
    );
    await _storage.setString(_streakKey(profileId), encodeJson(next.toJson()));
    return next;
  }

  Future<Difficulty> recommendedTier(
    String profileId,
    PuzzleType type,
  ) async {
    final progress = await _progressService.loadProgress(profileId);
    final solvedInType = progress.where((p) => p.type == type && p.solved).length;
    if (solvedInType >= 20) {
      return Difficulty.hard;
    }
    if (solvedInType >= 8) {
      return Difficulty.medium;
    }
    return Difficulty.easy;
  }

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
