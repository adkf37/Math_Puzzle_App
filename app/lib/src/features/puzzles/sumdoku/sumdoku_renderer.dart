import 'package:flutter/material.dart';

import '../../../core/engine/puzzle_renderer.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class SumdokuRenderer implements PuzzleRenderer {
  const SumdokuRenderer();

  @override
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  ) {
    final size = definition.initialState['size'] as int? ?? 4;
    final givens =
        (definition.initialState['givens'] as Map<String, dynamic>? ?? <String, dynamic>{})
            .map((k, v) => MapEntry(int.parse(k), v as int));
    final entries = (state.values['entries'] as Map<String, dynamic>? ??
            <String, dynamic>{})
        .map((k, v) => MapEntry(int.parse(k), v as int));
    final cages = (definition.initialState['cages'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Fill each row/column with unique digits. Cages must match sums.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: cages
              .take(4)
              .map((cage) => Chip(label: Text('Cage ${cage['id']}: ${cage['sum']}')))
              .toList(growable: false),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boardSize = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: boardSize,
                  height: boardSize,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: size * size,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size,
                    ),
                    itemBuilder: (context, index) {
                      final given = givens[index];
                      final value = given ?? entries[index];
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: given != null ? Colors.blueGrey.shade100 : Colors.white,
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: given != null
                              ? Text(
                                  '$given',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              : DropdownButton<int>(
                                  value: value == 0 ? null : value,
                                  hint: const Text('.'),
                                  underline: const SizedBox(),
                                  items: List<DropdownMenuItem<int>>.generate(
                                    size,
                                    (i) => DropdownMenuItem<int>(
                                      value: i + 1,
                                      child: Text('${i + 1}'),
                                    ),
                                  ),
                                  onChanged: (digit) {
                                    final next = Map<String, dynamic>.from(
                                      state.values['entries'] as Map<String, dynamic>? ??
                                          <String, dynamic>{},
                                    );
                                    if (digit == null) {
                                      next.remove(index.toString());
                                    } else {
                                      next[index.toString()] = digit;
                                    }
                                    onStateChanged(state.copyWith(values: <String, dynamic>{
                                      ...state.values,
                                      'entries': next,
                                    }));
                                  },
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
