import 'package:flutter/material.dart';

import '../../core/models/puzzle_definition.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({
    super.key,
    required this.definition,
  });

  final PuzzleDefinition definition;

  @override
  Widget build(BuildContext context) {
    final explanation = definition.explanation;
    final steps = explanation.steps.take(6).toList(growable: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Why It Works')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            explanation.summary,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('• '),
                  Expanded(child: Text(step)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Strategy Tip: ${explanation.strategyTip}'),
            ),
          ),
        ],
      ),
    );
  }
}
