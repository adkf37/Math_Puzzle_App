import '../core/di/service_locator.dart';
import '../core/logging/event_logger.dart';
import '../features/puzzles/puzzle_registry.dart';
import '../services/achievement_service.dart';
import '../services/content_repository.dart';
import '../services/daily_puzzle_service.dart';
import '../services/local_storage_service.dart';
import '../services/profile_service.dart';
import '../services/progress_service.dart';

class AppServices {
  AppServices({
    required this.locator,
    required this.storage,
    required this.profileService,
    required this.progressService,
    required this.achievementService,
    required this.dailyPuzzleService,
    required this.contentRepository,
    required this.puzzleRegistry,
    required this.eventLogger,
  });

  final ServiceLocator locator;
  final LocalStorageService storage;
  final ProfileService profileService;
  final ProgressService progressService;
  final AchievementService achievementService;
  final DailyPuzzleService dailyPuzzleService;
  final ContentRepository contentRepository;
  final PuzzleRegistry puzzleRegistry;
  final EventLogger eventLogger;
}
