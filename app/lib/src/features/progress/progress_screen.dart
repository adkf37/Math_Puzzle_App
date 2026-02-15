import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/models/puzzle_definition.dart';
import '../../services/models.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    required this.profile,
  });

  final KidProfile profile;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<_ProgressBundle>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_ProgressBundle> _load() async {
    final services = AppScope.of(context);
    final progress = await services.progressService.loadProgress(widget.profile.id);
    final definitions = await services.contentRepository.loadAll();
    final achievements = await services.achievementService.refreshForProfile(
      widget.profile.id,
      definitions: definitions,
    );
    return _ProgressBundle(progress, definitions, achievements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress & Badges')),
      body: FutureBuilder<_ProgressBundle>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bundle = snapshot.data!;
          final progress = bundle.progress;
          final definitions = bundle.definitions;
          final solved = progress.where((p) => p.solved).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text('Academy Rooms', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PuzzleType.values
                    .map((type) => Chip(label: Text('${type.name} room')))
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              Text('Solved: $solved / ${definitions.length}'),
              const SizedBox(height: 12),
              ...PuzzleType.values.map((type) {
                final inType = definitions.where((d) => d.type == type).length;
                final solvedType = progress.where((p) => p.type == type && p.solved).length;
                final pct = inType == 0 ? 0.0 : solvedType / inType;
                final tierLines = Difficulty.values.map((difficulty) {
                  final totalTier = definitions
                      .where((d) => d.type == type && d.difficulty == difficulty)
                      .length;
                  final solvedTier = progress
                      .where((p) =>
                          p.type == type &&
                          p.difficulty == difficulty &&
                          p.solved)
                      .length;
                  return '${difficulty.name}: $solvedTier/$totalTier';
                }).join('  |  ');
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(type.name),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: pct),
                        const SizedBox(height: 4),
                        Text('${(pct * 100).toStringAsFixed(0)}% complete'),
                        const SizedBox(height: 4),
                        Text(tierLines),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Text('Badges', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (bundle.achievements.unlockedIds.isEmpty)
                const Text('No badges yet.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bundle.achievements.unlockedIds
                      .map((id) => Chip(label: Text(id)))
                      .toList(growable: false),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressBundle {
  const _ProgressBundle(this.progress, this.definitions, this.achievements);

  final List<PuzzleProgress> progress;
  final List<PuzzleDefinition> definitions;
  final AchievementState achievements;
}
