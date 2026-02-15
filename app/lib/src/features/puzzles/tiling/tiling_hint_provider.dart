import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class TilingHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }
    return const <String>[
      'Look for a region that can only fit one piece orientation.',
      'Try placing the longest piece near a corner first.',
      'The next forced region is near the lower-left of the board.',
    ];
  }
}
