import 'package:flutter/material.dart';

import '../../services/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profile,
    required this.onOpenPuzzleSelect,
    required this.onOpenDaily,
    required this.onOpenProgress,
  });

  final KidProfile? profile;
  final VoidCallback onOpenPuzzleSelect;
  final VoidCallback onOpenDaily;
  final VoidCallback onOpenProgress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          Text(
            'Hi ${profile?.name ?? 'Player'}!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: 'Start Puzzle',
            subtitle: 'Choose a puzzle type and difficulty.',
            icon: Icons.extension,
            onTap: onOpenPuzzleSelect,
          ),
          _ActionCard(
            title: 'Daily Puzzle',
            subtitle: 'Keep your streak alive with today\'s challenge.',
            icon: Icons.calendar_today,
            onTap: onOpenDaily,
          ),
          _ActionCard(
            title: 'Progress & Badges',
            subtitle: 'See completion and unlocked achievements.',
            icon: Icons.emoji_events,
            onTap: onOpenProgress,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 14,
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
