import 'dart:convert';

import '../core/models/puzzle_definition.dart';

class KidProfile {
  const KidProfile({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'icon': icon,
      };

  factory KidProfile.fromJson(Map<String, dynamic> json) {
    return KidProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'star',
    );
  }
}

class PuzzleProgress {
  const PuzzleProgress({
    required this.puzzleId,
    required this.type,
    required this.difficulty,
    required this.solved,
    required this.elapsedSeconds,
    required this.hintsUsed,
    required this.lastSolvedAtIso,
  });

  final String puzzleId;
  final PuzzleType type;
  final Difficulty difficulty;
  final bool solved;
  final int elapsedSeconds;
  final int hintsUsed;
  final String? lastSolvedAtIso;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'puzzle_id': puzzleId,
        'type': type.name,
        'difficulty': difficulty.name,
        'solved': solved,
        'elapsed_seconds': elapsedSeconds,
        'hints_used': hintsUsed,
        'last_solved_at': lastSolvedAtIso,
      };

  factory PuzzleProgress.fromJson(Map<String, dynamic> json) {
    return PuzzleProgress(
      puzzleId: json['puzzle_id'] as String,
      type: PuzzleType.values.byName(json['type'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      solved: json['solved'] as bool? ?? false,
      elapsedSeconds: json['elapsed_seconds'] as int? ?? 0,
      hintsUsed: json['hints_used'] as int? ?? 0,
      lastSolvedAtIso: json['last_solved_at'] as String?,
    );
  }
}

class AchievementState {
  const AchievementState({
    required this.unlockedIds,
  });

  final List<String> unlockedIds;

  Map<String, dynamic> toJson() => <String, dynamic>{'unlocked_ids': unlockedIds};

  factory AchievementState.fromJson(Map<String, dynamic> json) {
    return AchievementState(
      unlockedIds:
          (json['unlocked_ids'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
    );
  }
}

class DailyStreak {
  const DailyStreak({
    required this.current,
    required this.best,
    required this.lastCompletedDate,
  });

  final int current;
  final int best;
  final String? lastCompletedDate;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'current': current,
        'best': best,
        'last_completed_date': lastCompletedDate,
      };

  factory DailyStreak.fromJson(Map<String, dynamic> json) {
    return DailyStreak(
      current: json['current'] as int? ?? 0,
      best: json['best'] as int? ?? 0,
      lastCompletedDate: json['last_completed_date'] as String?,
    );
  }
}

String encodeJson(Object value) => jsonEncode(value);

Map<String, dynamic> decodeJsonMap(String raw) =>
    jsonDecode(raw) as Map<String, dynamic>;

List<dynamic> decodeJsonList(String raw) => jsonDecode(raw) as List<dynamic>;
