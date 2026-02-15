import '../../core/models/puzzle_definition.dart';
import 'crosswords/crosswords_hint_provider.dart';
import 'crosswords/crosswords_renderer.dart';
import 'crosswords/crosswords_validator.dart';
import 'diff_pyramids/diff_pyramids_hint_provider.dart';
import 'diff_pyramids/diff_pyramids_renderer.dart';
import 'diff_pyramids/diff_pyramids_validator.dart';
import 'ineq_sudoku/ineq_sudoku_hint_provider.dart';
import 'ineq_sudoku/ineq_sudoku_renderer.dart';
import 'ineq_sudoku/ineq_sudoku_validator.dart';
import 'number_paths/number_paths_hint_provider.dart';
import 'number_paths/number_paths_renderer.dart';
import 'number_paths/number_paths_validator.dart';
import 'puzzle_module.dart';
import 'sumdoku/sumdoku_hint_provider.dart';
import 'sumdoku/sumdoku_renderer.dart';
import 'sumdoku/sumdoku_validator.dart';
import 'tiling/tiling_hint_provider.dart';
import 'tiling/tiling_renderer.dart';
import 'tiling/tiling_validator.dart';

class PuzzleRegistry {
  final Map<PuzzleType, PuzzleModule> _modules = <PuzzleType, PuzzleModule>{
    PuzzleType.numberPaths: PuzzleModule(
      type: PuzzleType.numberPaths,
      renderer: const NumberPathsRenderer(),
      validator: NumberPathsValidator(),
      hintProvider: NumberPathsHintProvider(),
      tutorialSteps: const <String>[
        'Tap the Start cell first.',
        'Extend the path to adjacent cells only.',
        'Visit required clue cells and finish on End.',
      ],
    ),
    PuzzleType.tiling: PuzzleModule(
      type: PuzzleType.tiling,
      renderer: const TilingRenderer(),
      validator: TilingValidator(),
      hintProvider: TilingHintProvider(),
      tutorialSteps: const <String>[
        'Pick a piece from the tray.',
        'Rotate it to fit.',
        'Snap pieces to cover all target cells.',
      ],
    ),
    PuzzleType.sumdoku: PuzzleModule(
      type: PuzzleType.sumdoku,
      renderer: const SumdokuRenderer(),
      validator: SumdokuValidator(),
      hintProvider: SumdokuHintProvider(),
      tutorialSteps: const <String>[
        'Each row and column uses each digit once.',
        'Cages show required sums.',
        'Use cage totals to force cells.',
      ],
    ),
    PuzzleType.inequalitySudoku: PuzzleModule(
      type: PuzzleType.inequalitySudoku,
      renderer: const InequalitySudokuRenderer(),
      validator: InequalitySudokuValidator(),
      hintProvider: InequalitySudokuHintProvider(),
      tutorialSteps: const <String>[
        'Follow > and < signs between neighboring cells.',
        'Keep row and column values unique.',
        'Use min/max reasoning to force moves.',
      ],
    ),
    PuzzleType.crosswords: PuzzleModule(
      type: PuzzleType.crosswords,
      renderer: const CrosswordsRenderer(),
      validator: CrosswordsValidator(),
      hintProvider: CrosswordsHintProvider(),
      tutorialSteps: const <String>[
        'Read across/down clue descriptions.',
        'Fill short entries first.',
        'Use crossings to verify answers.',
      ],
    ),
    PuzzleType.differencePyramids: PuzzleModule(
      type: PuzzleType.differencePyramids,
      renderer: const DifferencePyramidsRenderer(),
      validator: DifferencePyramidsValidator(),
      hintProvider: DifferencePyramidsHintProvider(),
      tutorialSteps: const <String>[
        'Start with given values on the bottom.',
        'Compute each upper cell from pair below.',
        'Repeat upward until complete.',
      ],
    ),
  };

  PuzzleModule moduleFor(PuzzleType type) {
    final module = _modules[type];
    if (module == null) {
      throw StateError('No module registered for $type');
    }
    return module;
  }
}
