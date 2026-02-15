import 'package:flutter/material.dart';

import '../../../core/engine/puzzle_renderer.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class DifferencePyramidsRenderer implements PuzzleRenderer {
  const DifferencePyramidsRenderer();

  @override
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  ) {
    final size = definition.initialState['size'] as int? ?? 4;
    final rule = definition.initialState['rule'] as String? ?? 'diff';
    final givens =
        (definition.initialState['givens'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final cells =
        (state.values['cells'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Rule: each upper cell is ${rule == 'sum' ? 'sum' : 'absolute difference'} of two below.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: size,
            itemBuilder: (context, row) {
              final length = size - row;
              return Padding(
                padding: EdgeInsets.only(left: row * 20.0, bottom: 8),
                child: Row(
                  children: List<Widget>.generate(length, (col) {
                    final key = '$row:$col';
                    final given = givens[key] as int?;
                    final value = given ?? cells[key] as int?;
                    return Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 8),
                      child: given != null
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black38),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    '$given',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : TextFormField(
                              initialValue: value?.toString() ?? '',
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (raw) {
                                final parsed = int.tryParse(raw);
                                final next = Map<String, dynamic>.from(cells);
                                if (parsed == null) {
                                  next.remove(key);
                                } else {
                                  next[key] = parsed;
                                }
                                onStateChanged(state.copyWith(values: <String, dynamic>{
                                  ...state.values,
                                  'cells': next,
                                }));
                              },
                            ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
