class ServiceLocator {
  final Map<Type, Object> _services = <Type, Object>{};

  void register<T extends Object>(T service) {
    _services[T] = service;
  }

  T get<T extends Object>() {
    final service = _services[T];
    if (service == null) {
      throw StateError('Service of type $T is not registered.');
    }
    return service as T;
  }
}
