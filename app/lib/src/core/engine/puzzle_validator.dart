import '../models/puzzle_definition.dart';
import '../models/puzzle_move.dart';
import '../models/puzzle_state.dart';

abstract class PuzzleValidator {
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  );

  bool isSolved(PuzzleDefinition definition, PuzzleState state);

  List<String> validateDefinition(PuzzleDefinition definition);
}
