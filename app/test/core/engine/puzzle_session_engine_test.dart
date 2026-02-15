import 'package:flutter_test/flutter_test.dart';
import 'package:math_puzzle_app/src/core/engine/hint_provider.dart';
import 'package:math_puzzle_app/src/core/engine/puzzle_session_engine.dart';
import 'package:math_puzzle_app/src/core/engine/puzzle_validator.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_definition.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_move.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_state.dart';

void main() {
  group('PuzzleSessionEngine', () {
    late PuzzleDefinition definition;
    late PuzzleSessionEngine engine;

    setUp(() {
      definition = PuzzleDefinition(
        id: 'unit',
        type: PuzzleType.numberPaths,
        difficulty: Difficulty.easy,
        recommendedAgeBand: '7-12',
        prompt: 'unit',
        rules: const <String>['rule'],
        initialState: const <String, dynamic>{'value': 0},
        solution: const <String, dynamic>{'value': 2},
        hints: const <PuzzleHintStep>[
          PuzzleHintStep(level: 1, message: 'h1'),
          PuzzleHintStep(level: 2, message: 'h2'),
          PuzzleHintStep(level: 3, message: 'h3'),
        ],
        explanation: const PuzzleExplanation(
          summary: 'summary',
          steps: <String>['a', 'b', 'c'],
          strategyTip: 'tip',
        ),
        tags: const <String>['logic'],
      );
      engine = PuzzleSessionEngine(
        definition: definition,
        validator: _TestValidator(),
        hintProvider: _TestHintProvider(),
      );
    });

    test('undo and redo restore snapshots', () {
      expect(engine.state.values['value'], 0);
      engine.applyMove(
        const PuzzleMove(kind: 'set', payload: <String, dynamic>{'value': 1}),
      );
      expect(engine.state.values['value'], 1);
      engine.undo();
      expect(engine.state.values['value'], 0);
      engine.redo();
      expect(engine.state.values['value'], 1);
    });

    test('hint gating unlocks show solution after threshold', () {
      expect(engine.canShowSolution, false);
      expect(engine.consumeHint(), 'h1');
      expect(engine.canShowSolution, false);
      expect(engine.consumeHint(), 'h2');
      expect(engine.canShowSolution, true);
    });

    test('check solved pipeline updates state', () {
      expect(engine.state.isSolved, false);
      engine.applyMove(
        const PuzzleMove(kind: 'set', payload: <String, dynamic>{'value': 2}),
      );
      expect(engine.state.isSolved, true);
    });
  });
}

class _TestValidator implements PuzzleValidator {
  @override
  bool isMoveLegal(
    PuzzleDefinition definition,
    PuzzleState state,
    PuzzleMove move,
  ) {
    return move.kind == 'set';
  }

  @override
  bool isSolved(PuzzleDefinition definition, PuzzleState state) {
    return state.values['value'] == definition.solution['value'];
  }

  @override
  List<String> validateDefinition(PuzzleDefinition definition) {
    return <String>[];
  }
}

class _TestHintProvider implements HintProvider {
  @override
  List<String> hintLadder(PuzzleDefinition definition, PuzzleState state) {
    return const <String>['h1', 'h2', 'h3'];
  }
}
