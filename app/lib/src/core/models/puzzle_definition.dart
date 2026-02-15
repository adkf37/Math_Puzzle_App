enum PuzzleType {
  numberPaths,
  tiling,
  sumdoku,
  inequalitySudoku,
  crosswords,
  differencePyramids,
}

enum Difficulty { easy, medium, hard }

class PuzzleHintStep {
  const PuzzleHintStep({
    required this.level,
    required this.message,
  });

  final int level;
  final String message;
}

class PuzzleExplanation {
  const PuzzleExplanation({
    required this.summary,
    required this.steps,
    required this.strategyTip,
  });

  final String summary;
  final List<String> steps;
  final String strategyTip;
}

class PuzzleDefinition {
  const PuzzleDefinition({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.recommendedAgeBand,
    required this.prompt,
    required this.rules,
    required this.initialState,
    required this.solution,
    required this.hints,
    required this.explanation,
    required this.tags,
  });

  final String id;
  final PuzzleType type;
  final Difficulty difficulty;
  final String recommendedAgeBand;
  final String prompt;
  final List<String> rules;
  final Map<String, dynamic> initialState;
  final Map<String, dynamic> solution;
  final List<PuzzleHintStep> hints;
  final PuzzleExplanation explanation;
  final List<String> tags;

  factory PuzzleDefinition.fromJson(Map<String, dynamic> json) {
    final hintJson = (json['hints'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    final explanationJson =
        (json['explanation'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return PuzzleDefinition(
      id: json['id'] as String,
      type: _parsePuzzleType(json['type'] as String),
      difficulty: _parseDifficulty(json['difficulty'] as String),
      recommendedAgeBand: json['recommended_age_band'] as String? ?? '7-12',
      prompt: json['prompt'] as String? ?? '',
      rules: (json['rules'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
      initialState:
          (json['initial_state'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      solution: (json['solution'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      hints: hintJson
          .map(
            (hint) => PuzzleHintStep(
              level: hint['level'] as int? ?? 1,
              message: hint['message'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      explanation: PuzzleExplanation(
        summary: explanationJson['summary'] as String? ?? '',
        steps: (explanationJson['steps'] as List<dynamic>? ?? <dynamic>[])
            .cast<String>(),
        strategyTip: explanationJson['strategy_tip'] as String? ?? '',
      ),
      tags: (json['tags'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
    );
  }
}

PuzzleType _parsePuzzleType(String rawType) {
  switch (rawType) {
    case 'number_paths':
      return PuzzleType.numberPaths;
    case 'tiling':
      return PuzzleType.tiling;
    case 'sumdoku':
      return PuzzleType.sumdoku;
    case 'ineq_sudoku':
      return PuzzleType.inequalitySudoku;
    case 'crosswords':
      return PuzzleType.crosswords;
    case 'diff_pyramids':
      return PuzzleType.differencePyramids;
    default:
      throw ArgumentError('Unsupported puzzle type: $rawType');
  }
}

Difficulty _parseDifficulty(String rawDifficulty) {
  switch (rawDifficulty) {
    case 'easy':
      return Difficulty.easy;
    case 'medium':
      return Difficulty.medium;
    case 'hard':
      return Difficulty.hard;
    default:
      throw ArgumentError('Unsupported difficulty: $rawDifficulty');
  }
}
