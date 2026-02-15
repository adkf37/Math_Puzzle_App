class PuzzleMove {
  const PuzzleMove({
    required this.kind,
    required this.payload,
  });

  final String kind;
  final Map<String, dynamic> payload;
}
