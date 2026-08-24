import 'package:flutter/foundation.dart';

import '../config/public_app_config.dart';
import '../config/release_info.dart';
import '../services/public_config_service.dart';

class PublicConfigProvider extends ChangeNotifier {
  PublicConfigProvider({PublicConfigService? service})
    : _service = service ?? PublicConfigService();

  final PublicConfigService _service;

  PublicAppConfig? _config;
  bool _isLoading = false;
  String? _error;

  PublicAppConfig? get config => _config;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> initialize() => refresh();

  Future<void> refresh() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentVersion = ReleaseInfo.version.split('+').first;
      _config = await _service.fetch(currentVersion: currentVersion);
    } catch (error) {
      debugPrint('[PublicConfigProvider] Failed to load config: $error');
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
