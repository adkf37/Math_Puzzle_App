import 'package:flutter_test/flutter_test.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_definition.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_move.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_state.dart';
import 'package:math_puzzle_app/src/features/puzzles/number_paths/number_paths_validator.dart';

void main() {
  group('NumberPathsValidator', () {
    final validator = NumberPathsValidator();
    final definition = PuzzleDefinition(
      id: 'np_test',
      type: PuzzleType.numberPaths,
      difficulty: Difficulty.easy,
      recommendedAgeBand: '7-12',
      prompt: 'np',
      rules: const <String>['r'],
      initialState: const <String, dynamic>{
        'rows': 4,
        'cols': 4,
        'start': 0,
        'end': 15,
        'blocked': <int>[],
        'must_visit': <int>[6, 10],
        'order_clues': <String, int>{'0': 1, '6': 4},
      },
      solution: const <String, dynamic>{
        'path': <int>[0, 1, 2, 6, 10, 14, 15],
      },
      hints: const <PuzzleHintStep>[
        PuzzleHintStep(level: 1, message: 'h1'),
        PuzzleHintStep(level: 2, message: 'h2'),
        PuzzleHintStep(level: 3, message: 'h3'),
      ],
      explanation: const PuzzleExplanation(
        summary: 's',
        steps: <String>['a', 'b', 'c'],
        strategyTip: 't',
      ),
      tags: const <String>['logic'],
    );

    test('accepts legal path move', () {
      final ok = validator.isMoveLegal(
        definition,
        const PuzzleState(values: <String, dynamic>{}),
        const PuzzleMove(
          kind: 'set_path',
          payload: <String, dynamic>{
            'path': <int>[0, 1, 2, 6],
          },
        ),
      );
      expect(ok, isTrue);
    });

    test('rejects diagonal/non-adjacent path', () {
      final ok = validator.isMoveLegal(
        definition,
        const PuzzleState(values: <String, dynamic>{}),
        const PuzzleMove(
          kind: 'set_path',
          payload: <String, dynamic>{
            'path': <int>[0, 5],
          },
        ),
      );
      expect(ok, isFalse);
    });

    test('solution path counts as solved', () {
      final solved = validator.isSolved(
        definition,
        const PuzzleState(
          values: <String, dynamic>{
            'path': <int>[0, 1, 2, 6, 10, 14, 15],
          },
        ),
      );
      expect(solved, isTrue);
    });
  });
}
