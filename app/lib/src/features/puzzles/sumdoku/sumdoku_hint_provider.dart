import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class SumdokuHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }
    return const <String>[
      'Look for a cell with only one possible number in its row and column.',
      'Check a cage where all but one value is known.',
      'Use the cage total to force the next value in the highlighted cage.',
    ];
  }
}
