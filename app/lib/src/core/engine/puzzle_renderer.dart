import 'package:flutter/widgets.dart';

import '../models/puzzle_definition.dart';
import '../models/puzzle_state.dart';

typedef OnStateChanged = void Function(PuzzleState nextState);

abstract class PuzzleRenderer {
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  );
}
