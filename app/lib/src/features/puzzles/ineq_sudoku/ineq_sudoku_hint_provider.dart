import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class InequalitySudokuHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }
    return const <String>[
      'Use > and < signs to limit each cell to min/max values.',
      'Find a cell where inequality plus row limits leaves one option.',
      'Use the strongest chain of inequalities to force a move.',
    ];
  }
}
