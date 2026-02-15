import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class CrosswordsHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }
    return const <String>[
      'Solve the shortest clue first to anchor crossings.',
      'Look for repeated skip-count patterns in clues.',
      'Reveal a crossing cell where two clues intersect.',
    ];
  }
}
