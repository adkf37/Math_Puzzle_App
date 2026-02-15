import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/models/puzzle_definition.dart';
import '../../services/models.dart';
import 'puzzle_player_screen.dart';

class PuzzleSelectScreen extends StatefulWidget {
  const PuzzleSelectScreen({
    super.key,
    required this.profile,
  });

  final KidProfile profile;

  @override
  State<PuzzleSelectScreen> createState() => _PuzzleSelectScreenState();
}

class _PuzzleSelectScreenState extends State<PuzzleSelectScreen> {
  Future<List<PuzzleDefinition>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= AppScope.of(context).contentRepository.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle Select')),
      body: FutureBuilder<List<PuzzleDefinition>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: PuzzleType.values.map((type) {
              final typePuzzles = all.where((p) => p.type == type).toList();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _typeTitle(type),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: Difficulty.values.map((difficulty) {
                          final inTier = typePuzzles
                              .where((p) => p.difficulty == difficulty)
                              .toList(growable: false);
                          return FilledButton.tonal(
                            onPressed: inTier.isEmpty
                                ? null
                                : () => _openPuzzle(inTier.first),
                            child: Text(
                              '${difficulty.name} (${inTier.length})',
                            ),
                          );
                        }).toList(growable: false),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(growable: false),
          );
        },
      ),
    );
  }

  void _openPuzzle(PuzzleDefinition definition) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PuzzlePlayerScreen(
          definition: definition,
          profile: widget.profile,
        ),
      ),
    );
  }

  String _typeTitle(PuzzleType type) {
    switch (type) {
      case PuzzleType.numberPaths:
        return 'Number Paths / Mazes';
      case PuzzleType.tiling:
        return 'Tiling / Polyomino Fit';
      case PuzzleType.sumdoku:
        return 'Sumdoku';
      case PuzzleType.inequalitySudoku:
        return 'Inequality Sudoku';
      case PuzzleType.crosswords:
        return 'Arithmetic Crosswords';
      case PuzzleType.differencePyramids:
        return 'Difference Pyramids';
    }
  }
}
