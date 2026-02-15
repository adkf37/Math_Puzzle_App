import 'package:flutter/material.dart';

import '../../../core/engine/puzzle_renderer.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class NumberPathsRenderer implements PuzzleRenderer {
  const NumberPathsRenderer();

  @override
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  ) {
    return NumberPathsBoard(
      definition: definition,
      state: state,
      onStateChanged: onStateChanged,
    );
  }
}

class NumberPathsBoard extends StatefulWidget {
  const NumberPathsBoard({
    super.key,
    required this.definition,
    required this.state,
    required this.onStateChanged,
  });

  final PuzzleDefinition definition;
  final PuzzleState state;
  final OnStateChanged onStateChanged;

  @override
  State<NumberPathsBoard> createState() => _NumberPathsBoardState();
}

class _NumberPathsBoardState extends State<NumberPathsBoard> {
  int? _lastDragCell;

  @override
  Widget build(BuildContext context) {
    final rows = widget.definition.initialState['rows'] as int? ?? 4;
    final cols = widget.definition.initialState['cols'] as int? ?? 4;
    final start = widget.definition.initialState['start'] as int? ?? 0;
    final end = widget.definition.initialState['end'] as int? ?? (rows * cols - 1);
    final blocked =
        (widget.definition.initialState['blocked'] as List<dynamic>? ?? <dynamic>[])
            .cast<int>()
            .toSet();
    final orderClues =
        (widget.definition.initialState['order_clues'] as Map<String, dynamic>? ??
                <String, dynamic>{})
            .map((k, v) => MapEntry(int.parse(k), v as int));
    final path =
        (widget.state.values['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();

    final legalMoves = _legalMoves(path, rows, cols, blocked);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Draw a path from Start to End. Tap cells or drag across the board.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boardAspect = cols / rows;
              var boardWidth = constraints.maxWidth;
              var boardHeight = boardWidth / boardAspect;
              if (boardHeight > constraints.maxHeight) {
                boardHeight = constraints.maxHeight;
                boardWidth = boardHeight * boardAspect;
              }
              final widthPerCell = boardWidth / cols;
              final heightPerCell = boardHeight / rows;

              return Center(
                child: SizedBox(
                  width: boardWidth,
                  height: boardHeight,
                  child: GestureDetector(
                    onPanStart: (details) {
                      _tryHandleDrag(details.localPosition, widthPerCell, heightPerCell);
                    },
                    onPanUpdate: (details) {
                      _tryHandleDrag(details.localPosition, widthPerCell, heightPerCell);
                    },
                    onPanEnd: (_) {
                      _lastDragCell = null;
                    },
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rows * cols,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                      ),
                      itemBuilder: (context, index) {
                        final inPath = path.contains(index);
                        final isStart = index == start;
                        final isEnd = index == end;
                        final isBlocked = blocked.contains(index);
                        final clue = orderClues[index];
                        final isLegal = legalMoves.contains(index);
                        final bg = isBlocked
                            ? Colors.black12
                            : inPath
                                ? Colors.lightBlueAccent
                                : isLegal
                                    ? Colors.lightGreenAccent
                                    : Colors.white;

                        return GestureDetector(
                          onTap: () => _tapCell(index),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: bg,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                isStart
                                    ? 'S'
                                    : isEnd
                                        ? 'E'
                                        : clue?.toString() ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _tryHandleDrag(Offset local, double w, double h) {
    final rows = widget.definition.initialState['rows'] as int? ?? 4;
    final cols = widget.definition.initialState['cols'] as int? ?? 4;
    final col = (local.dx / w).floor();
    final row = (local.dy / h).floor();
    if (col < 0 || col >= cols || row < 0 || row >= rows) {
      return;
    }
    final index = row * cols + col;
    if (_lastDragCell == index) {
      return;
    }
    _lastDragCell = index;
    _tapCell(index);
  }

  void _tapCell(int index) {
    final cols = widget.definition.initialState['cols'] as int? ?? 4;
    final start = widget.definition.initialState['start'] as int? ?? 0;
    final blocked =
        (widget.definition.initialState['blocked'] as List<dynamic>? ?? <dynamic>[])
            .cast<int>()
            .toSet();
    if (blocked.contains(index)) {
      return;
    }

    final path =
        (widget.state.values['path'] as List<dynamic>? ?? <dynamic>[]).cast<int>();
    final nextPath = [...path];
    if (nextPath.isEmpty) {
      if (index != start) {
        return;
      }
      nextPath.add(index);
      _emit(nextPath);
      return;
    }

    final last = nextPath.last;
    if (nextPath.length >= 2 && index == nextPath[nextPath.length - 2]) {
      nextPath.removeLast();
      _emit(nextPath);
      return;
    }
    if (nextPath.contains(index)) {
      return;
    }
    if (!_adjacent(last, index, cols)) {
      return;
    }
    nextPath.add(index);
    _emit(nextPath);
  }

  void _emit(List<int> path) {
    widget.onStateChanged(
      widget.state.copyWith(values: <String, dynamic>{
        ...widget.state.values,
        'path': path,
      }),
    );
  }

  Set<int> _legalMoves(
    List<int> path,
    int rows,
    int cols,
    Set<int> blocked,
  ) {
    if (path.isEmpty) {
      return <int>{};
    }
    final last = path.last;
    final candidates = <int>{};
    final offsets = <int>[-cols, cols, -1, 1];
    for (final offset in offsets) {
      final next = last + offset;
      if (next < 0 || next >= rows * cols) {
        continue;
      }
      if (offset == -1 && last % cols == 0) {
        continue;
      }
      if (offset == 1 && last % cols == cols - 1) {
        continue;
      }
      if (blocked.contains(next) || path.contains(next)) {
        continue;
      }
      candidates.add(next);
    }
    return candidates;
  }

  bool _adjacent(int a, int b, int cols) {
    final ar = a ~/ cols;
    final ac = a % cols;
    final br = b ~/ cols;
    final bc = b % cols;
    return (ar - br).abs() + (ac - bc).abs() == 1;
  }
}
