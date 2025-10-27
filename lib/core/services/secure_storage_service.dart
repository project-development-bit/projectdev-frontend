import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    webOptions: WebOptions(
      dbName: 'FlutterSecureStorage',
      publicKey: 'FlutterSecureStorage',
    ),
  );

  // Token management
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // Track if we've logged the storage type already
  static bool _hasLoggedStorageType = false;

  /// Get SharedPreferences instance for web platform
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Check if running on web platform
  bool get _isWeb => kIsWeb;

  /// Log storage type once for debugging
  void _logStorageTypeOnce() {
    if (!_hasLoggedStorageType) {
      debugPrint('🗄️ SecureStorageService initialized with: $storageType');
      _hasLoggedStorageType = true;
    }
  }

  // Auth token methods
  Future<String?> getAuthToken() async {
    _logStorageTypeOnce();
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        return prefs.getString(_authTokenKey);
      } else {
        return await _storage.read(key: _authTokenKey);
      }
    } catch (e) {
      debugPrint('Error getting auth token: $e');
      return null;
    }
  }

  Future<void> saveAuthToken(String token) async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.setString(_authTokenKey, token);
      } else {
        await _storage.write(key: _authTokenKey, value: token);
      }
    } catch (e) {
      debugPrint('Error saving auth token: $e');
    }
  }

  Future<void> deleteAuthToken() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.remove(_authTokenKey);
      } else {
        await _storage.delete(key: _authTokenKey);
      }
    } catch (e) {
      debugPrint('Error deleting auth token: $e');
    }
  }

  // Refresh token methods
  Future<String?> getRefreshToken() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        return prefs.getString(_refreshTokenKey);
      } else {
        return await _storage.read(key: _refreshTokenKey);
      }
    } catch (e) {
      debugPrint('Error getting refresh token: $e');
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.setString(_refreshTokenKey, token);
      } else {
        await _storage.write(key: _refreshTokenKey, value: token);
      }
    } catch (e) {
      debugPrint('Error saving refresh token: $e');
    }
  }

  Future<void> deleteRefreshToken() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.remove(_refreshTokenKey);
      } else {
        await _storage.delete(key: _refreshTokenKey);
      }
    } catch (e) {
      debugPrint('Error deleting refresh token: $e');
    }
  }

  // User ID methods
  Future<String?> getUserId() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        return prefs.getString(_userIdKey);
      } else {
        return await _storage.read(key: _userIdKey);
      }
    } catch (e) {
      debugPrint('Error getting user ID: $e');
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.setString(_userIdKey, userId);
      } else {
        await _storage.write(key: _userIdKey, value: userId);
      }
    } catch (e) {
      debugPrint('Error saving user ID: $e');
    }
  }

  Future<void> deleteUserId() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.remove(_userIdKey);
      } else {
        await _storage.delete(key: _userIdKey);
      }
    } catch (e) {
      debugPrint('Error deleting user ID: $e');
    }
  }

  // Clear all auth data
  Future<void> clearAllAuthData() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await Future.wait([
          prefs.remove(_authTokenKey),
          prefs.remove(_refreshTokenKey),
          prefs.remove(_userIdKey),
        ]);
      } else {
        await Future.wait([
          deleteAuthToken(),
          deleteRefreshToken(),
          deleteUserId(),
        ]);
      }
    } catch (e) {
      debugPrint('Error clearing auth data: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Get storage type for debugging
  String get storageType =>
      _isWeb ? 'SharedPreferences (Web)' : 'FlutterSecureStorage (Mobile)';
}

// Provider for secure storage service
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
