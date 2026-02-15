import 'dart:math';

import 'local_storage_service.dart';
import 'models.dart';

class ProfileService {
  ProfileService(this._storage);

  static const String _profilesKey = 'profiles_v1';
  static const String _activeProfileIdKey = 'active_profile_id_v1';
  final LocalStorageService _storage;

  Future<List<KidProfile>> loadProfiles() async {
    final raw = await _storage.getStringList(_profilesKey);
    return raw
        .map((entry) => KidProfile.fromJson(decodeJsonMap(entry)))
        .toList(growable: false);
  }

  Future<KidProfile?> loadActiveProfile() async {
    final profiles = await loadProfiles();
    final activeId = await _storage.getString(_activeProfileIdKey);
    if (activeId == null) {
      return profiles.isEmpty ? null : profiles.first;
    }
    return profiles.firstWhere(
      (profile) => profile.id == activeId,
      orElse: () => profiles.isEmpty ? _guestProfile() : profiles.first,
    );
  }

  Future<KidProfile> createProfile({
    required String name,
    required String icon,
  }) async {
    final profile = KidProfile(
      id: _randomId(),
      name: name.trim(),
      icon: icon,
    );
    final profiles = await loadProfiles();
    final next = <KidProfile>[...profiles, profile];
    await _storage.setStringList(
      _profilesKey,
      next.map((p) => encodeJson(p.toJson())).toList(growable: false),
    );
    await setActiveProfile(profile.id);
    return profile;
  }

  Future<void> setActiveProfile(String profileId) async {
    await _storage.setString(_activeProfileIdKey, profileId);
  }

  KidProfile _guestProfile() =>
      const KidProfile(id: 'guest', name: 'Guest', icon: 'star');

  String _randomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List<String>.generate(10, (_) => chars[random.nextInt(chars.length)])
        .join();
  }
}
