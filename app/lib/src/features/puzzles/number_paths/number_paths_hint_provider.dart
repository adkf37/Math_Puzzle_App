import '../../../core/engine/hint_provider.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class NumberPathsHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    if (definition.hints.isNotEmpty) {
      final sorted = [...definition.hints]..sort((a, b) => a.level - b.level);
      return sorted.map((h) => h.message).toList(growable: false);
    }

    final path = (state.values['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    final mustVisit = (definition.initialState['must_visit'] as List<dynamic>? ??
            <dynamic>[])
        .cast<int>();
    final solutionPath =
        (definition.solution['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    final missingMustVisit =
        mustVisit.firstWhere((cell) => !path.contains(cell), orElse: () => -1);
    final nextStep = path.length < solutionPath.length ? solutionPath[path.length] : -1;

    return <String>[
      'Start at the marked start cell and look for a forced neighbor.',
      missingMustVisit >= 0
          ? 'This cell must be visited before you finish: $missingMustVisit.'
          : 'You have already visited all must-visit cells.',
      nextStep >= 0
          ? 'Try extending the path to cell $nextStep next.'
          : 'You are close. Check the final step toward the end cell.',
    ];
  }
}
