import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/puzzle_definition.dart';
import 'content_pack_manifest.dart';

class ContentLoader {
  Future<ContentPackManifest> loadManifest(String path) async {
    final raw = await rootBundle.loadString(path);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final byType = <PuzzleType, String>{};
    final files = json['files'] as Map<String, dynamic>? ?? <String, dynamic>{};
    for (final entry in files.entries) {
      byType[_parseType(entry.key)] = entry.value as String;
    }
    return ContentPackManifest(
      id: json['id'] as String,
      version: json['version'] as String,
      displayName: json['display_name'] as String? ?? 'Pack',
      packPathByType: byType,
    );
  }

  Future<List<PuzzleDefinition>> loadPuzzlesForType(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final puzzles =
        (json['puzzles'] as List<dynamic>? ?? <dynamic>[]).cast<Map<String, dynamic>>();
    return puzzles.map(PuzzleDefinition.fromJson).toList(growable: false);
  }

  PuzzleType _parseType(String rawType) {
    switch (rawType) {
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
        throw ArgumentError('Unknown puzzle type in manifest: $rawType');
    }
  }
}
