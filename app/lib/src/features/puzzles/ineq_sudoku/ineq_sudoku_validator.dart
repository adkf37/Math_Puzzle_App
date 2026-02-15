import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class InequalitySudokuValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final size = definition.initialState['size'] as int? ?? 4;
    final entries =
        (move.payload['entries'] as Map<String, dynamic>? ?? <String, dynamic>{});
    for (final value in entries.values) {
      final digit = value as int? ?? 0;
      if (digit < 0 || digit > size) {
        return false;
      }
    }
    return true;
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    final size = definition.initialState['size'] as int? ?? 4;
    final entries = (state.values['entries'] as Map<String, dynamic>? ??
            <String, dynamic>{})
        .map((k, v) => MapEntry(int.parse(k), v as int));
    final solution =
        (definition.solution['entries'] as Map<String, dynamic>? ?? <String, dynamic>{})
            .map((k, v) => MapEntry(int.parse(k), v as int));
    if (solution.isNotEmpty) {
      return solution.entries.every((entry) => entries[entry.key] == entry.value);
    }
    if (!_rowsAndColsUnique(entries, size)) {
      return false;
    }
    return _inequalitiesHold(definition, entries);
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final edges = (definition.initialState['inequalities'] as List<dynamic>? ??
            <dynamic>[])
        .cast<Map<String, dynamic>>();
    if (edges.isEmpty) {
      return <String>['Inequality Sudoku should include at least one inequality.'];
    }
    return <String>[];
  }

  bool _rowsAndColsUnique(Map<int, int> entries, int size) {
    for (var row = 0; row < size; row++) {
      final rowVals = <int>{};
      for (var col = 0; col < size; col++) {
        final v = entries[row * size + col] ?? 0;
        if (v == 0) {
          continue;
        }
        if (!rowVals.add(v)) {
          return false;
        }
      }
    }
    for (var col = 0; col < size; col++) {
      final colVals = <int>{};
      for (var row = 0; row < size; row++) {
        final v = entries[row * size + col] ?? 0;
        if (v == 0) {
          continue;
        }
        if (!colVals.add(v)) {
          return false;
        }
      }
    }
    return true;
  }

  bool _inequalitiesHold(PuzzleDefinition definition, Map<int, int> entries) {
    final edges = (definition.initialState['inequalities'] as List<dynamic>? ??
            <dynamic>[])
        .cast<Map<String, dynamic>>();
    for (final edge in edges) {
      final a = edge['a'] as int;
      final b = edge['b'] as int;
      final op = edge['op'] as String;
      final va = entries[a] ?? 0;
      final vb = entries[b] ?? 0;
      if (va == 0 || vb == 0) {
        continue;
      }
      if (op == '>' && va <= vb) {
        return false;
      }
      if (op == '<' && va >= vb) {
        return false;
      }
    }
    return true;
  }
}
