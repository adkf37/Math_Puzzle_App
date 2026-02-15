import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class DifferencePyramidsHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }
    return const <String>[
      'Look for a row where two values are known; that forces the cell above.',
      'Complete the base first, then build upward level by level.',
      'Compute one exact step and propagate it up the pyramid.',
    ];
  }
}
