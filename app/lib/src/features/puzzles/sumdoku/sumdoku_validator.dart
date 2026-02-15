import '../../../core/engine/puzzle_validator.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_move.dart';
import '../../../core/models/puzzle_state.dart';

class SumdokuValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    final values =
        (move.payload['entries'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final size = definition.initialState['size'] as int? ?? 4;
    for (final value in values.values) {
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
      if (entries.length != solution.length) {
        return false;
      }
      for (final entry in solution.entries) {
        if (entries[entry.key] != entry.value) {
          return false;
        }
      }
      return true;
    }

    if (!_rowsAndColsUnique(entries, size)) {
      return false;
    }
    return _cagesValid(definition, entries);
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    final size = definition.initialState['size'] as int? ?? 0;
    final cages =
        (definition.initialState['cages'] as List<dynamic>? ?? <dynamic>[]).cast();
    final issues = <String>[];
    if (size <= 0) {
      issues.add('Sumdoku requires size > 0.');
    }
    if (cages.isEmpty) {
      issues.add('Sumdoku requires cages.');
    }
    return issues;
  }

  bool _rowsAndColsUnique(Map<int, int> entries, int size) {
    for (var row = 0; row < size; row++) {
      final rowVals = <int>{};
      for (var col = 0; col < size; col++) {
        final value = entries[row * size + col] ?? 0;
        if (value == 0) {
          continue;
        }
        if (!rowVals.add(value)) {
          return false;
        }
      }
    }
    for (var col = 0; col < size; col++) {
      final colVals = <int>{};
      for (var row = 0; row < size; row++) {
        final value = entries[row * size + col] ?? 0;
        if (value == 0) {
          continue;
        }
        if (!colVals.add(value)) {
          return false;
        }
      }
    }
    return true;
  }

  bool _cagesValid(PuzzleDefinition definition, Map<int, int> entries) {
    final cages = (definition.initialState['cages'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    for (final cage in cages) {
      final cells = (cage['cells'] as List<dynamic>).cast<int>();
      final expected = cage['sum'] as int;
      var sum = 0;
      var complete = true;
      for (final cell in cells) {
        final digit = entries[cell] ?? 0;
        if (digit == 0) {
          complete = false;
        }
        sum += digit;
      }
      if (complete && sum != expected) {
        return false;
      }
      if (sum > expected) {
        return false;
      }
    }
    return true;
  }
}
