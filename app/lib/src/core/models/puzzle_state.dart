class PuzzleState {
  const PuzzleState({
    required this.values,
    this.attempts = 0,
    this.hintsUsed = 0,
    this.elapsedSeconds = 0,
    this.isSolved = false,
  });

  final Map<String, dynamic> values;
  final int attempts;
  final int hintsUsed;
  final int elapsedSeconds;
  final bool isSolved;

  PuzzleState copyWith({
    Map<String, dynamic>? values,
    int? attempts,
    int? hintsUsed,
    int? elapsedSeconds,
    bool? isSolved,
  }) {
    return PuzzleState(
      values: values ?? this.values,
      attempts: attempts ?? this.attempts,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isSolved: isSolved ?? this.isSolved,
    );
  }
}
