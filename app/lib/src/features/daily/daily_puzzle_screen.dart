import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/models/puzzle_definition.dart';
import '../../services/models.dart';
import '../puzzles/puzzle_player_screen.dart';

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({
    super.key,
    required this.profile,
  });

  final KidProfile profile;

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> {
  Future<_DailyBundle>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_DailyBundle> _load() async {
    final services = AppScope.of(context);
    final all = await services.contentRepository.loadAll();
    final today = DateTime.now();
    final puzzle = services.dailyPuzzleService.pickDailyPuzzle(today, all);
    final streak = await services.dailyPuzzleService.loadStreak(widget.profile.id);
    await services.dailyPuzzleService.cacheDaily(
      widget.profile.id,
      date: today,
      puzzleId: puzzle.id,
    );
    final cached = await services.dailyPuzzleService.loadCachedDaily(widget.profile.id);
    final recommended =
        await services.dailyPuzzleService.recommendedTier(widget.profile.id, puzzle.type);
    return _DailyBundle(
      puzzle: puzzle,
      streak: streak,
      cachedLast7: cached,
      recommended: recommended,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Puzzle')),
      body: FutureBuilder<_DailyBundle>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                child: ListTile(
                  title: const Text('Current Streak'),
                  subtitle: Text(
                    'Current: ${data.streak.current}, Best: ${data.streak.best}',
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Today: ${data.puzzle.type.name}'),
                  subtitle: Text(
                    'Recommended tier: ${data.recommended.name}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PuzzlePlayerScreen(
                        definition: data.puzzle,
                        profile: widget.profile,
                        isDaily: true,
                      ),
                    ),
                  );
                },
                child: const Text('Play Daily Puzzle'),
              ),
              const SizedBox(height: 16),
              Text(
                'Cached Last 7 Dailies (offline support)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...data.cachedLast7.map((entry) => Text('• $entry')),
            ],
          );
        },
      ),
    );
  }
}

class _DailyBundle {
  const _DailyBundle({
    required this.puzzle,
    required this.streak,
    required this.cachedLast7,
    required this.recommended,
  });

  final PuzzleDefinition puzzle;
  final DailyStreak streak;
  final List<String> cachedLast7;
  final Difficulty recommended;
}
