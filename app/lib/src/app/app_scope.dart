import 'package:flutter/widgets.dart';

import 'app_services.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.services,
    required super.child,
  });

  final AppServices services;

  static AppServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    if (scope == null) {
      throw StateError('AppScope not found in widget tree.');
    }
    return scope.services;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) {
    return oldWidget.services != services;
  }
}
