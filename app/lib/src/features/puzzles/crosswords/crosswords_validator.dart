import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class CrosswordsValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final answers =
        (move.payload['answers'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return answers.values.every((value) => (value as String).length <= 32);
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    final answers =
        (state.values['answers'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final solution =
        (definition.solution['answers'] as Map<String, dynamic>? ?? <String, dynamic>{});
    if (solution.isEmpty) {
      return false;
    }
    for (final entry in solution.entries) {
      final got = (answers[entry.key] as String? ?? '').trim();
      final expected = (entry.value as String).trim();
      if (got.toLowerCase() != expected.toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final clues =
        (definition.initialState['clues'] as List<dynamic>? ?? <dynamic>[]).cast();
    if (clues.isEmpty) {
      return <String>['Crosswords requires clue definitions.'];
    }
    return <String>[];
  }
}
