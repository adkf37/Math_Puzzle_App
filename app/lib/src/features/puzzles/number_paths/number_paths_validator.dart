import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class NumberPathsValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final path = (move.payload['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    if (path.isEmpty) {
      return false;
    }
    return _isPathValid(definition, path);
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    final currentPath =
        (state.values['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    final solutionPath =
        (definition.solution['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    if (solutionPath.isNotEmpty) {
      if (currentPath.length != solutionPath.length) {
        return false;
      }
      for (var i = 0; i < currentPath.length; i++) {
        if (currentPath[i] != solutionPath[i]) {
          return false;
        }
      }
      return true;
    }
    final end = definition.initialState['end'] as int? ?? -1;
    if (currentPath.isEmpty || currentPath.last != end) {
      return false;
    }
    final mustVisit = (definition.initialState['must_visit'] as List<dynamic>? ??
            <dynamic>[])
        .cast<int>();
    return mustVisit.every(currentPath.contains);
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final issues = <String>[];
    final rows = definition.initialState['rows'] as int? ?? 0;
    final cols = definition.initialState['cols'] as int? ?? 0;
    if (rows <= 0 || cols <= 0) {
      issues.add('NumberPaths requires positive rows and cols.');
    }
    final start = definition.initialState['start'] as int?;
    final end = definition.initialState['end'] as int?;
    if (start == null || end == null) {
      issues.add('NumberPaths requires start and end cell indexes.');
    }
    final solutionPath =
        (definition.solution['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    if (solutionPath.isEmpty) {
      issues.add('NumberPaths requires non-empty solution.path.');
    } else if (!_isPathValid(definition, solutionPath)) {
      issues.add('NumberPaths solution.path is invalid for adjacency/rules.');
    }
    return issues;
  }

  bool _isPathValid(PuzzleDefinition definition, List<int> path) {
    final rows = definition.initialState['rows'] as int? ?? 0;
    final cols = definition.initialState['cols'] as int? ?? 0;
    final maxCell = rows * cols - 1;
    final blocked =
        (definition.initialState['blocked'] as List<dynamic>? ?? <dynamic>[])
            .cast<int>()
            .toSet();
    final orderClues =
        (definition.initialState['order_clues'] as Map<String, dynamic>? ??
                <String, dynamic>{})
            .map((k, v) => MapEntry(int.parse(k), v as int));
    final start = definition.initialState['start'] as int?;
    if (start != null && path.first != start) {
      return false;
    }

    final seen = <int>{};
    for (var i = 0; i < path.length; i++) {
      final cell = path[i];
      if (cell < 0 || cell > maxCell) {
        return false;
      }
      if (blocked.contains(cell)) {
        return false;
      }
      if (seen.contains(cell)) {
        return false;
      }
      final clueOrder = orderClues[cell];
      if (clueOrder != null && clueOrder != i + 1) {
        return false;
      }
      if (i > 0 && !_adjacent(path[i - 1], cell, cols)) {
        return false;
      }
      seen.add(cell);
    }
    return true;
  }

  bool _adjacent(int a, int b, int cols) {
    final ar = a ~/ cols;
    final ac = a % cols;
    final br = b ~/ cols;
    final bc = b % cols;
    return (ar - br).abs() + (ac - bc).abs() == 1;
  }
}
