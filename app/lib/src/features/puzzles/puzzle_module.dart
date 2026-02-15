import '../../core/engine/hint_provider.dart';
import '../../core/engine/puzzle_renderer.dart';
import '../../core/engine/puzzle_validator.dart';
import '../../core/models/puzzle_definition.dart';

class PuzzleModule {
  const PuzzleModule({
    required this.type,
    required this.renderer,
    required this.validator,
    required this.hintProvider,
    required this.tutorialSteps,
  });

  final PuzzleType type;
  final PuzzleRenderer renderer;
  final PuzzleValidator validator;
  final HintProvider hintProvider;
  final List<String> tutorialSteps;
}
