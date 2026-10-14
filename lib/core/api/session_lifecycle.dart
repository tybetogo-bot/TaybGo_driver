/// Shared by every API client so requests and credential writes belong to one
/// login, including clients owned by separate feature providers.
class SessionLifecycle {
  static final shared = SessionLifecycle();

  int generation = 0;
  bool signingOut = false;
  Future<void>? cleanup;
  Future<bool>? refresh;
  int? refreshGeneration;
  Future<void> Function()? onRejected;
  Future<void> _writes = Future<void>.value();

  Future<void> waitForWrites() => _writes;

  bool isCurrent(int value) => value == generation && !signingOut;

  int beginLogout() {
    signingOut = true;
    return ++generation;
  }

  Future<int> beginLogin() async {
    while (cleanup != null) {
      await cleanup;
    }
    signingOut = false;
    return ++generation;
  }

  /// Serialize credential writes/deletions and recheck after waiting for any
  /// earlier storage operation. Refresh and login cannot overwrite each other.
  Future<bool> writeIfCurrent(int value, Future<void> Function() write) {
    final result = _writes.then((_) async {
      if (value != generation) return false;
      await write();
      return value == generation;
    });
    _writes = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }
}
