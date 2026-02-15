import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../services/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.activeProfile,
    required this.onProfileChanged,
  });

  final KidProfile? activeProfile;
  final ValueChanged<KidProfile> onProfileChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<KidProfile>>? _profilesFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profilesFuture ??= AppScope.of(context).profileService.loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final services = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profiles')),
      body: FutureBuilder<List<KidProfile>>(
        future: _profilesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final profiles = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              ...profiles.map((profile) {
                final selected = widget.activeProfile?.id == profile.id;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(profile.icon)),
                    title: Text(profile.name),
                    trailing:
                        selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                    onTap: () async {
                      await services.profileService.setActiveProfile(profile.id);
                      widget.onProfileChanged(profile);
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _profilesFuture = services.profileService.loadProfiles();
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _createProfile,
                icon: const Icon(Icons.person_add),
                label: const Text('Create Profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createProfile() async {
    final services = AppScope.of(context);
    final nameController = TextEditingController();
    String icon = 'A';
    final created = await showDialog<KidProfile>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: icon,
                    items: const <String>['A', 'B', 'C', 'D', 'E', 'F']
                        .map(
                          (value) =>
                              DropdownMenuItem<String>(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => icon = value ?? 'A'),
                    decoration: const InputDecoration(labelText: 'Icon'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      return;
                    }
                    final profile = await services.profileService.createProfile(
                      name: name,
                      icon: icon,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop(profile);
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == null || !mounted) {
      return;
    }
    widget.onProfileChanged(created);
    setState(() {
      _profilesFuture = services.profileService.loadProfiles();
    });
  }
}
