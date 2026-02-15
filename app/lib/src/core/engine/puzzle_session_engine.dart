import 'dart:async';

import '../models/puzzle_definition.dart';
import '../models/puzzle_move.dart';
import '../models/puzzle_state.dart';
import 'hint_provider.dart';
import 'puzzle_validator.dart';

class PuzzleSessionEngine {
  PuzzleSessionEngine({
    required this.definition,
    required this.validator,
    required this.hintProvider,
    this.solutionRevealHintThreshold = 2,
  }) : _state = PuzzleState(values: Map<String, dynamic>.from(definition.initialState));

  final PuzzleDefinition definition;
  final PuzzleValidator validator;
  final HintProvider hintProvider;
  final int solutionRevealHintThreshold;

  final List<PuzzleState> _undoStack = <PuzzleState>[];
  final List<PuzzleState> _redoStack = <PuzzleState>[];
  late PuzzleState _state;
  Timer? _timer;

  PuzzleState get state => _state;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get canShowSolution => _state.hintsUsed >= solutionRevealHintThreshold;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _state = _state.copyWith(elapsedSeconds: _state.elapsedSeconds + 1);
    });
  }

  void dispose() {
    _timer?.cancel();
  }

  bool applyMove(PuzzleMove move) {
    if (!validator.isMoveLegal(definition, _state, move)) {
      _state = _state.copyWith(attempts: _state.attempts + 1);
      return false;
    }

    final nextValues = Map<String, dynamic>.from(_state.values);
    nextValues.addAll(move.payload);
    _pushUndo(_state);
    _redoStack.clear();
    _state = _state.copyWith(
      values: nextValues,
      attempts: _state.attempts + 1,
      isSolved: false,
    );
    _checkSolved();
    return true;
  }

  void updateState(Map<String, dynamic> nextValues) {
    _pushUndo(_state);
    _redoStack.clear();
    _state = _state.copyWith(
      values: Map<String, dynamic>.from(nextValues),
      attempts: _state.attempts + 1,
    );
    _checkSolved();
  }

  void undo() {
    if (!canUndo) {
      return;
    }
    _redoStack.add(_state);
    _state = _undoStack.removeLast();
  }

  void redo() {
    if (!canRedo) {
      return;
    }
    _undoStack.add(_state);
    _state = _redoStack.removeLast();
  }

  String? consumeHint() {
    final hints = hintProvider.hintLadder(definition, _state);
    if (hints.isEmpty) {
      return null;
    }
    final current = _state.hintsUsed.clamp(0, hints.length - 1);
    _state = _state.copyWith(hintsUsed: _state.hintsUsed + 1);
    return hints[current];
  }

  void revealSolution() {
    if (!canShowSolution) {
      return;
    }
    _pushUndo(_state);
    _redoStack.clear();
    _state = _state.copyWith(values: Map<String, dynamic>.from(definition.solution));
    _checkSolved();
  }

  void _checkSolved() {
    _state = _state.copyWith(isSolved: validator.isSolved(definition, _state));
  }

  void _pushUndo(PuzzleState snapshot) {
    _undoStack.add(
      snapshot.copyWith(values: Map<String, dynamic>.from(snapshot.values)),
    );
    if (_undoStack.length > 100) {
      _undoStack.removeAt(0);
    }
  }
}
