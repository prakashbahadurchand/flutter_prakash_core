import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_token_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthLocalDataSource {
  static const String _keyToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserName = 'auth_user_name';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  Future<void> saveSession({
    required AuthTokenModel token,
    required AuthUserModel user,
  }) async {
    await _prefs.setString(_keyToken, token.accessToken);
    await _prefs.setString(_keyRefreshToken, token.refreshToken);
    await _prefs.setString(_keyUserId, user.id);
    await _prefs.setString(_keyUserEmail, user.email);
    await _prefs.setString(_keyUserName, user.name);
  }

  bool hasValidSession() {
    final token = _prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  String? getAccessToken() => _prefs.getString(_keyToken);

  AuthUserModel? getCachedUser() {
    final id = _prefs.getString(_keyUserId);
    final email = _prefs.getString(_keyUserEmail);
    final name = _prefs.getString(_keyUserName);

    if (id == null || email == null || name == null) return null;

    return AuthUserModel(
      id: id,
      email: email,
      name: name,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
  }
}
