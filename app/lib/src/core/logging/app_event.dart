class AppEvent {
  const AppEvent({
    required this.name,
    required this.timestamp,
    this.properties = const <String, Object?>{},
  });

  final String name;
  final DateTime timestamp;
  final Map<String, Object?> properties;
}
