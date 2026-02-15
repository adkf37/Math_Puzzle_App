import 'package:flutter/material.dart';

import '../core/content/content_loader.dart';
import '../core/di/service_locator.dart';
import '../core/logging/event_logger.dart';
import '../features/navigation/app_shell.dart';
import '../features/puzzles/puzzle_registry.dart';
import '../services/achievement_service.dart';
import '../services/content_repository.dart';
import '../services/daily_puzzle_service.dart';
import '../services/local_storage_service.dart';
import '../services/profile_service.dart';
import '../services/progress_service.dart';
import 'app_scope.dart';
import 'app_services.dart';

class MathPuzzleApp extends StatefulWidget {
  const MathPuzzleApp({super.key});

  @override
  State<MathPuzzleApp> createState() => _MathPuzzleAppState();
}

class _MathPuzzleAppState extends State<MathPuzzleApp> {
  late final AppServices _services = _buildServices();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: _services,
      child: MaterialApp(
        title: 'Math Puzzle App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6A88)),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 16),
          ),
        ),
        home: const AppShell(),
      ),
    );
  }

  AppServices _buildServices() {
    final locator = ServiceLocator();
    final storage = LocalStorageService();
    final profileService = ProfileService(storage);
    final progressService = ProgressService(storage);
    final achievementService = AchievementService(storage, progressService);
    final dailyPuzzleService = DailyPuzzleService(storage, progressService);
    final contentRepository = ContentRepository(ContentLoader());
    final puzzleRegistry = PuzzleRegistry();
    const eventLogger = NoopEventLogger();

    locator.register<LocalStorageService>(storage);
    locator.register<ProfileService>(profileService);
    locator.register<ProgressService>(progressService);
    locator.register<AchievementService>(achievementService);
    locator.register<DailyPuzzleService>(dailyPuzzleService);
    locator.register<ContentRepository>(contentRepository);
    locator.register<PuzzleRegistry>(puzzleRegistry);
    locator.register<EventLogger>(eventLogger);

    return AppServices(
      locator: locator,
      storage: storage,
      profileService: profileService,
      progressService: progressService,
      achievementService: achievementService,
      dailyPuzzleService: dailyPuzzleService,
      contentRepository: contentRepository,
      puzzleRegistry: puzzleRegistry,
      eventLogger: eventLogger,
    );
  }
}
