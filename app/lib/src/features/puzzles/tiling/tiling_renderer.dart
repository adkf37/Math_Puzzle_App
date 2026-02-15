import 'package:flutter/material.dart';

import '../../../core/engine/puzzle_renderer.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class TilingRenderer implements PuzzleRenderer {
  const TilingRenderer();

  @override
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  ) {
    return _TilingBoard(
      definition: definition,
      state: state,
      onStateChanged: onStateChanged,
    );
  }
}

class _TilingBoard extends StatefulWidget {
  const _TilingBoard({
    required this.definition,
    required this.state,
    required this.onStateChanged,
  });

  final PuzzleDefinition definition;
  final PuzzleState state;
  final OnStateChanged onStateChanged;

  @override
  State<_TilingBoard> createState() => _TilingBoardState();
}

class _TilingBoardState extends State<_TilingBoard> {
  String? _selectedPieceId;
  int _rotation = 0;

  @override
  Widget build(BuildContext context) {
    final rows = widget.definition.initialState['rows'] as int? ?? 4;
    final cols = widget.definition.initialState['cols'] as int? ?? 4;
    final pieces =
        (widget.definition.initialState['pieces'] as List<dynamic>? ?? <dynamic>[])
            .cast<Map<String, dynamic>>();
    final placements = (widget.state.values['placements'] as Map<String, dynamic>? ??
            <String, dynamic>{})
        .map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
    final occupied = <int, String>{};
    for (final entry in placements.entries) {
      final cell = entry.value['cell'] as int? ?? -1;
      if (cell >= 0) {
        occupied[cell] = entry.key;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Pick a piece, rotate if needed, then tap a board cell to place.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pieces.map((piece) {
            final id = piece['id'] as String;
            final selected = id == _selectedPieceId;
            return ChoiceChip(
              label: Text(id),
              selected: selected,
              onSelected: (_) => setState(() => _selectedPieceId = id),
            );
          }).toList(growable: false),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const Text('Rotation:'),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: _rotation,
              items: const <int>[0, 90, 180, 270]
                  .map((r) => DropdownMenuItem<int>(value: r, child: Text('$r°')))
                  .toList(),
              onChanged: (value) => setState(() => _rotation = value ?? 0),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: _selectedPieceId == null
                  ? null
                  : () {
                      final next = Map<String, dynamic>.from(placements);
                      next.remove(_selectedPieceId);
                      widget.onStateChanged(widget.state.copyWith(values: <String, dynamic>{
                        ...widget.state.values,
                        'placements': next,
                      }));
                    },
              child: const Text('Remove Selected'),
            ),
          ],
        ),
        const SizedBox(height: 8),
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

              return Center(
                child: SizedBox(
                  width: boardWidth,
                  height: boardHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rows * cols,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                    ),
                    itemBuilder: (context, index) {
                      final pieceId = occupied[index];
                      final isFilled = pieceId != null;
                      return GestureDetector(
                        onTap: () {
                          if (_selectedPieceId == null) {
                            return;
                          }
                          if (isFilled && pieceId != _selectedPieceId) {
                            return;
                          }
                          final next = Map<String, dynamic>.from(placements);
                          next[_selectedPieceId!] = <String, dynamic>{
                            'cell': index,
                            'rotation': _rotation,
                          };
                          widget.onStateChanged(widget.state.copyWith(values: <String, dynamic>{
                            ...widget.state.values,
                            'placements': next,
                          }));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isFilled ? Colors.orangeAccent : Colors.white,
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              pieceId ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

