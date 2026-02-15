import '../models/puzzle_definition.dart';
import '../models/puzzle_state.dart';

abstract class HintProvider {
  List<String> hintLadder(
    PuzzleDefinition definition,
    PuzzleState state,
  );
}
