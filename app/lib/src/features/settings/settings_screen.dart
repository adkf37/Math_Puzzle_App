import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          ListTile(
            title: Text('Kid-safe mode'),
            subtitle: Text('Enabled by default. No external links in child flow.'),
            trailing: Icon(Icons.lock),
          ),
          Divider(),
          ListTile(
            title: Text('Text size standard'),
            subtitle: Text('Minimum body text 16px, touch targets at least 48px.'),
          ),
          Divider(),
          ListTile(
            title: Text('Telemetry'),
            subtitle: Text('Anonymous events only: puzzle_start, hint_used, solved.'),
          ),
        ],
      ),
    );
  }
}
