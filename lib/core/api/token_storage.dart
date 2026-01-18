import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  TokenStorage({FlutterSecureStorage? storage})
      : _secureStorage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  Future<String?> getAccessToken() async {
    String? token;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString(_accessTokenKey);
    } else {
      token = await _secureStorage.read(key: _accessTokenKey);
    }
    debugPrint('[TokenStorage] getAccessToken: ${token != null ? "exists (${token.length} chars)" : "null"}');
    return token;
  }

  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    }
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    debugPrint('[TokenStorage] saveTokens: access=${accessToken.length} chars, refresh=${refreshToken.length} chars');
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_accessTokenKey, accessToken),
        prefs.setString(_refreshTokenKey, refreshToken),
      ]);
    } else {
      await Future.wait([
        _secureStorage.write(key: _accessTokenKey, value: accessToken),
        _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    }
    debugPrint('[TokenStorage] Tokens saved successfully');
  }

  Future<void> clearTokens() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_accessTokenKey),
        prefs.remove(_refreshTokenKey),
      ]);
    } else {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
      ]);
    }
  }

  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
