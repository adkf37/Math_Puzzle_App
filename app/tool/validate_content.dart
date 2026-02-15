import 'dart:convert';
import 'dart:io';

import 'package:math_puzzle_app/src/core/models/puzzle_definition.dart';
import 'package:math_puzzle_app/src/core/models/puzzle_state.dart';
import 'package:math_puzzle_app/src/features/puzzles/puzzle_registry.dart';

void main() {
  final manifestFile = File('assets/content/packs/sample_mvp/manifest.json');
  if (!manifestFile.existsSync()) {
    stderr.writeln('Manifest not found: ${manifestFile.path}');
    exitCode = 1;
    return;
  }

  final manifest = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  final files = manifest['files'] as Map<String, dynamic>? ?? <String, dynamic>{};
  final registry = PuzzleRegistry();
  final issues = <String>[];

  for (final entry in files.entries) {
    final type = _parseType(entry.key);
    final file = File(entry.value as String);
    if (!file.existsSync()) {
      issues.add('Missing file for ${entry.key}: ${file.path}');
      continue;
    }
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final puzzles = (json['puzzles'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    for (final puzzleJson in puzzles) {
      try {
        final definition = PuzzleDefinition.fromJson(puzzleJson);
        if (definition.type != type) {
          issues.add('${definition.id}: type mismatch in file ${entry.key}');
        }
        if (definition.hints.length < 3) {
          issues.add('${definition.id}: requires at least 3 hint steps');
        }

        final module = registry.moduleFor(definition.type);
        final validatorIssues = module.validator.validateDefinition(definition);
        for (final issue in validatorIssues) {
          issues.add('${definition.id}: $issue');
        }

        final solvedState = PuzzleState(values: _solutionState(definition));
        if (!module.validator.isSolved(definition, solvedState)) {
          issues.add('${definition.id}: solution does not pass validator');
        }
      } catch (e) {
        issues.add('Failed to parse puzzle JSON in ${file.path}: $e');
      }
    }
  }

  if (issues.isEmpty) {
    stdout.writeln('Content validation passed.');
    return;
  }

  stderr.writeln('Content validation failed with ${issues.length} issue(s):');
  for (final issue in issues) {
    stderr.writeln('- $issue');
  }
  exitCode = 1;
}

PuzzleType _parseType(String raw) {
  switch (raw) {
    case 'number_paths':
      return PuzzleType.numberPaths;
    case 'tiling':
      return PuzzleType.tiling;
    case 'sumdoku':
      return PuzzleType.sumdoku;
    case 'ineq_sudoku':
      return PuzzleType.inequalitySudoku;
    case 'crosswords':
      return PuzzleType.crosswords;
    case 'diff_pyramids':
      return PuzzleType.differencePyramids;
    default:
      throw ArgumentError('Unsupported type: $raw');
  }
}

Map<String, dynamic> _solutionState(PuzzleDefinition definition) {
  switch (definition.type) {
    case PuzzleType.numberPaths:
      return <String, dynamic>{'path': definition.solution['path']};
    case PuzzleType.tiling:
      final cells =
          (definition.solution['covered_cells'] as List<dynamic>? ?? <dynamic>[])
              .cast<int>();
      final placements = <String, dynamic>{};
      for (var i = 0; i < cells.length; i++) {
        placements['P$i'] = <String, dynamic>{'cell': cells[i], 'rotation': 0};
      }
      return <String, dynamic>{'placements': placements};
    case PuzzleType.sumdoku:
    case PuzzleType.inequalitySudoku:
      return <String, dynamic>{'entries': definition.solution['entries']};
    case PuzzleType.crosswords:
      return <String, dynamic>{'answers': definition.solution['answers']};
    case PuzzleType.differencePyramids:
      return <String, dynamic>{'cells': definition.solution['cells']};
  }
}
