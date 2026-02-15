import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../services/models.dart';
import '../content_preview/content_preview_screen.dart';
import '../daily/daily_puzzle_screen.dart';
import '../home/home_screen.dart';
import '../profiles/profile_screen.dart';
import '../progress/progress_screen.dart';
import '../puzzles/puzzle_select_screen.dart';
import '../settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  KidProfile? _activeProfile;
  bool _loadingProfile = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadingProfile) {
      _bootstrapProfile();
    }
  }

  Future<void> _bootstrapProfile() async {
    final services = AppScope.of(context);
    var profile = await services.profileService.loadActiveProfile();
    profile ??= await services.profileService.createProfile(name: 'Player 1', icon: 'A');
    if (!mounted) {
      return;
    }
    setState(() {
      _activeProfile = profile;
      _loadingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile || _activeProfile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final profile = _activeProfile!;
    final pages = <Widget>[
      Scaffold(
        appBar: AppBar(
          title: const Text('Math Puzzle App'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Content Preview',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ContentPreviewScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.inventory_2),
            ),
          ],
        ),
        body: HomeScreen(
          profile: profile,
          onOpenPuzzleSelect: _openPuzzleSelect,
          onOpenDaily: _openDaily,
          onOpenProgress: _openProgress,
        ),
      ),
      PuzzleSelectScreen(profile: profile),
      ProfileScreen(
        activeProfile: profile,
        onProfileChanged: (next) => setState(() => _activeProfile = next),
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Puzzle Select'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _openPuzzleSelect() {
    setState(() => _index = 1);
  }

  void _openDaily() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DailyPuzzleScreen(profile: _activeProfile!),
      ),
    );
  }

  void _openProgress() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProgressScreen(profile: _activeProfile!),
      ),
    );
  }
}
