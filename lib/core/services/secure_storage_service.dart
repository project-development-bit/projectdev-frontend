import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token management
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // Auth token methods
  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> deleteAuthToken() async {
    try {
      await _storage.delete(key: _authTokenKey);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // Refresh token methods
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // User ID methods
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> deleteUserId() async {
    try {
      await _storage.delete(key: _userIdKey);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // Clear all auth data
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([
        deleteAuthToken(),
        deleteRefreshToken(),
        deleteUserId(),
      ]);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}

// Provider for secure storage service
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});