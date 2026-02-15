import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_definition.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_state.dart';
import 'package:math_puzzle_app/src/features/puzzles/puzzle_registry.dart';

void main() {
  testWidgets('all puzzle renderers build with sample state', (tester) async {
    final registry = PuzzleRegistry();
    for (final type in PuzzleType.values) {
      final definition = _definitionFor(type);
      final module = registry.moduleFor(type);
      final state = PuzzleState(values: Map<String, dynamic>.from(definition.initialState));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: module.renderer.build(
                context,
                definition,
                state,
                (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    }
  });
}

PuzzleDefinition _definitionFor(PuzzleType type) {
  return PuzzleDefinition(
    id: 'sample_${type.name}',
    type: type,
    difficulty: Difficulty.easy,
    recommendedAgeBand: '7-12',
    prompt: 'Sample',
    rules: const <String>['rule'],
    initialState: _initial(type),
    solution: _solution(type),
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
}

Map<String, dynamic> _initial(PuzzleType type) {
  switch (type) {
    case PuzzleType.numberPaths:
      return <String, dynamic>{
        'rows': 4,
        'cols': 4,
        'start': 0,
        'end': 15,
        'path': <int>[0],
      };
    case PuzzleType.tiling:
      return <String, dynamic>{
        'rows': 4,
        'cols': 4,
        'pieces': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'A'},
          <String, dynamic>{'id': 'B'},
        ],
        'placements': <String, dynamic>{},
      };
    case PuzzleType.sumdoku:
      return <String, dynamic>{
        'size': 4,
        'givens': <String, int>{'0': 1},
        'cages': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'A', 'cells': <int>[0, 1], 'sum': 3},
        ],
      };
    case PuzzleType.inequalitySudoku:
      return <String, dynamic>{
        'size': 4,
        'givens': <String, int>{'0': 1},
        'inequalities': <Map<String, dynamic>>[
          <String, dynamic>{'a': 0, 'b': 1, 'op': '<'},
        ],
      };
    case PuzzleType.crosswords:
      return <String, dynamic>{
        'grid': <String>['...'],
        'clues': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'A1',
            'direction': 'across',
            'length': 1,
            'clue': '2+3'
          }
        ],
      };
    case PuzzleType.differencePyramids:
      return <String, dynamic>{
        'size': 4,
        'rule': 'diff',
        'givens': <String, int>{'0:0': 1},
      };
  }
}

Map<String, dynamic> _solution(PuzzleType type) {
  switch (type) {
    case PuzzleType.numberPaths:
      return <String, dynamic>{'path': <int>[0, 1, 2]};
    case PuzzleType.tiling:
      return <String, dynamic>{'covered_cells': <int>[0, 1]};
    case PuzzleType.sumdoku:
    case PuzzleType.inequalitySudoku:
      return <String, dynamic>{'entries': <String, int>{'0': 1}};
    case PuzzleType.crosswords:
      return <String, dynamic>{'answers': <String, String>{'A1': '5'}};
    case PuzzleType.differencePyramids:
      return <String, dynamic>{'cells': <String, int>{'0:0': 1}};
  }
}
