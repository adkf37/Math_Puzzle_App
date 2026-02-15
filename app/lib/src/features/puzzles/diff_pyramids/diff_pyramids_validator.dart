import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class DifferencePyramidsValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final cells =
        (move.payload['cells'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return cells.values.every((v) => (v as int? ?? 0).abs() < 1000);
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    final cells =
        (state.values['cells'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final solution =
        (definition.solution['cells'] as Map<String, dynamic>? ?? <String, dynamic>{});
    if (solution.isNotEmpty) {
      return solution.entries.every((entry) => cells[entry.key] == entry.value);
    }
    return _ruleHolds(definition, cells);
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final size = definition.initialState['size'] as int? ?? 0;
    if (size <= 1) {
      return <String>['Difference Pyramids requires size >= 2'];
    }
    return <String>[];
  }

  bool _ruleHolds(PuzzleDefinition definition, Map<String, dynamic> cells) {
    final size = definition.initialState['size'] as int? ?? 4;
    final rule = definition.initialState['rule'] as String? ?? 'diff';
    for (var row = 0; row < size - 1; row++) {
      for (var col = 0; col < size - row - 1; col++) {
        final left = cells['$row:$col'] as int? ?? 0;
        final right = cells['$row:${col + 1}'] as int? ?? 0;
        final above = cells['${row + 1}:$col'] as int? ?? 0;
        if (left == 0 || right == 0 || above == 0) {
          continue;
        }
        final expected = rule == 'sum' ? left + right : (left - right).abs();
        if (expected != above) {
          return false;
        }
      }
    }
    return true;
  }
}
