import 'app_event.dart';

abstract class EventLogger {
  Future<void> log(AppEvent event);
}

class NoopEventLogger implements EventLogger {
  const NoopEventLogger();

  @override
  Future<void> log(AppEvent event) async {}
}
