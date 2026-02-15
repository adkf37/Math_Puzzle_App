import 'package:flutter/material.dart';

import '../../../core/engine/puzzle_renderer.dart';
import '../../../core/models/puzzle_definition.dart';
import '../../../core/models/puzzle_state.dart';

class CrosswordsRenderer implements PuzzleRenderer {
  const CrosswordsRenderer();

  @override
  Widget build(
    BuildContext context,
    PuzzleDefinition definition,
    PuzzleState state,
    OnStateChanged onStateChanged,
  ) {
    final clues = (definition.initialState['clues'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    final answers =
        (state.values['answers'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Solve arithmetic clues and fill each entry.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: clues.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final clue = clues[index];
              final clueId = clue['id'] as String;
              final clueText = clue['clue'] as String;
              final direction = clue['direction'] as String? ?? 'across';
              final length = clue['length'] as int? ?? 1;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$clueId ($direction, $length): $clueText',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: answers[clueId] as String? ?? '',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Enter number sequence',
                    ),
                    onChanged: (value) {
                      final next = Map<String, dynamic>.from(answers);
                      next[clueId] = value;
                      onStateChanged(state.copyWith(values: <String, dynamic>{
                        ...state.values,
                        'answers': next,
                      }));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
