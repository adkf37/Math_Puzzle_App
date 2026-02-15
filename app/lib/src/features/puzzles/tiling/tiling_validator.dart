import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class TilingValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final placements =
        (move.payload['placements'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return _placementsNonColliding(placements);
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    final placements = (state.values['placements'] as Map<String, dynamic>? ??
        <String, dynamic>{});
    final targetCells =
        (definition.solution['covered_cells'] as List<dynamic>? ?? <dynamic>[])
            .cast<int>()
            .toSet();
    if (targetCells.isEmpty) {
      return false;
    }
    final covered = placements.values
        .map((entry) => (entry as Map<String, dynamic>)['cell'] as int? ?? -1)
        .where((cell) => cell >= 0)
        .toSet();
    return covered.length == targetCells.length && covered.containsAll(targetCells);
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final issues = <String>[];
    final rows = definition.initialState['rows'] as int? ?? 0;
    final cols = definition.initialState['cols'] as int? ?? 0;
    if (rows <= 0 || cols <= 0) {
      issues.add('Tiling requires positive rows/cols.');
    }
    final pieces =
        (definition.initialState['pieces'] as List<dynamic>? ?? <dynamic>[]).cast();
    if (pieces.isEmpty) {
      issues.add('Tiling requires at least one piece.');
    }
    return issues;
  }

  bool _placementsNonColliding(Map<String, dynamic> placements) {
    final seen = <int>{};
    for (final entry in placements.values) {
      final cell = (entry as Map<String, dynamic>)['cell'] as int? ?? -1;
      if (cell < 0) {
        continue;
      }
      if (!seen.add(cell)) {
        return false;
      }
    }
    return true;
  }
}
