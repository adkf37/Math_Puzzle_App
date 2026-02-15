import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/logging/app_event.dart';
import '../../core/engine/puzzle_session_engine.dart';
import '../../core/models/puzzle_definition.dart';
import '../../services/models.dart';
import '../tutorials/explanation_screen.dart';
import '../tutorials/tutorial_framework.dart';

class PuzzlePlayerScreen extends StatefulWidget {
  const PuzzlePlayerScreen({
    super.key,
    required this.definition,
    required this.profile,
    this.isDaily = false,
  });

  final PuzzleDefinition definition;
  final KidProfile profile;
  final bool isDaily;

  @override
  State<PuzzlePlayerScreen> createState() => _PuzzlePlayerScreenState();
}

class _PuzzlePlayerScreenState extends State<PuzzlePlayerScreen> {
  late PuzzleSessionEngine _engine;
  String? _hintMessage;
  bool _recordedSolve = false;
  bool _engineReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_engineReady) {
      return;
    }
    final services = AppScope.of(context);
    final module = services.puzzleRegistry.moduleFor(widget.definition.type);
    _engine = PuzzleSessionEngine(
      definition: widget.definition,
      validator: module.validator,
      hintProvider: module.hintProvider,
    );
    _engine.start();
    services.eventLogger.log(
      AppEvent(
        name: 'puzzle_start',
        timestamp: DateTime.now(),
        properties: <String, Object?>{
          'puzzle_id': widget.definition.id,
          'type': widget.definition.type.name,
        },
      ),
    );
    _engineReady = true;
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = AppScope.of(context);
    final module = services.puzzleRegistry.moduleFor(widget.definition.type);
    final state = _engine.state;
    if (state.isSolved && !_recordedSolve) {
      _recordedSolve = true;
      services.progressService.recordSolve(
        profileId: widget.profile.id,
        definition: widget.definition,
        elapsedSeconds: state.elapsedSeconds,
        hintsUsed: state.hintsUsed,
      );
      services.eventLogger.log(
        AppEvent(
          name: 'puzzle_solved',
          timestamp: DateTime.now(),
          properties: <String, Object?>{
            'puzzle_id': widget.definition.id,
            'elapsed_seconds': state.elapsedSeconds,
            'hints_used': state.hintsUsed,
          },
        ),
      );
      services.achievementService.refreshForProfile(
        widget.profile.id,
        definitions: [widget.definition],
      );
      if (widget.isDaily) {
        services.dailyPuzzleService
            .markCompleted(widget.profile.id, DateTime.now())
            .then((streak) {
          services.achievementService.unlock(widget.profile.id, 'daily_complete');
          if (streak.current >= 7) {
            services.achievementService.unlock(widget.profile.id, 'daily_streak_7');
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.definition.prompt),
        actions: <Widget>[
          IconButton(
            tooltip: 'Tutorial',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TutorialFramework(
                    title: widget.definition.type.name,
                    steps: module.tutorialSteps,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.school),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Attempts: ${state.attempts}'),
                const SizedBox(width: 12),
                Text('Hints: ${state.hintsUsed}'),
                const SizedBox(width: 12),
                Text('Time: ${state.elapsedSeconds}s'),
              ],
            ),
            if (_hintMessage != null) ...<Widget>[
              const SizedBox(height: 8),
              Card(
                color: Colors.lightBlue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.lightbulb, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_hintMessage!)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: module.renderer.build(
                context,
                widget.definition,
                state,
                (nextState) {
                  _engine.updateState(nextState.values);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton.tonal(
                  onPressed: _engine.canUndo
                      ? () {
                          _engine.undo();
                          setState(() {});
                        }
                      : null,
                  child: const Text('Undo'),
                ),
                FilledButton.tonal(
                  onPressed: _engine.canRedo
                      ? () {
                          _engine.redo();
                          setState(() {});
                        }
                      : null,
                  child: const Text('Redo'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _hintMessage = _engine.consumeHint();
                    });
                    services.eventLogger.log(
                      AppEvent(
                        name: 'hint_used',
                        timestamp: DateTime.now(),
                        properties: <String, Object?>{
                          'puzzle_id': widget.definition.id,
                          'hint_count': _engine.state.hintsUsed,
                        },
                      ),
                    );
                  },
                  child: const Text('Hint'),
                ),
                OutlinedButton(
                  onPressed: _engine.canShowSolution
                      ? () {
                          _engine.revealSolution();
                          setState(() {});
                        }
                      : null,
                  child: const Text('Show Solution'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ExplanationScreen(definition: widget.definition),
                      ),
                    );
                  },
                  child: const Text('Explanation'),
                ),
              ],
            ),
            if (state.isSolved) ...<Widget>[
              const SizedBox(height: 8),
              Card(
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Solved! Great work.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
