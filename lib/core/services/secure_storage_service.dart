import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  // Instance-level storage
  final _storage = const FlutterSecureStorage(
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
  static const String _tutorialShownKey = 'tutorial_shown';
  
  // Remember me credentials
  static const String _rememberMeEmailKey = 'remember_me_email';
  static const String _rememberMePasswordKey = 'remember_me_password';
  static const String _rememberMeEnabledKey = 'remember_me_enabled';

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
        final userID = prefs.getString(_userIdKey) ?? 'unknown_user';
        await Future.wait([
          prefs.remove(_tutorialShownKey + userID),
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

  // ==========================================================================
  // REMEMBER ME FUNCTIONALITY
  // ==========================================================================

  /// Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        final enabled = prefs.getBool(_rememberMeEnabledKey) ?? false;
        debugPrint('🔍 Remember me enabled check (web): $enabled');
        return enabled;
      } else {
        final value = await _storage.read(key: _rememberMeEnabledKey);
        final enabled = value == 'true';
        debugPrint('🔍 Remember me enabled check (mobile): $enabled');
        return enabled;
      }
    } catch (e) {
      debugPrint('⚠️ Error checking remember me status: $e');
      debugPrint('⚠️ Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Save remember me credentials
  Future<void> saveRememberMeCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await prefs.setBool(_rememberMeEnabledKey, rememberMe);
        if (rememberMe) {
          await prefs.setString(_rememberMeEmailKey, email);
          await prefs.setString(_rememberMePasswordKey, password);
          debugPrint('✅ Remember me credentials saved (Web)');
        } else {
          await prefs.remove(_rememberMeEmailKey);
          await prefs.remove(_rememberMePasswordKey);
          debugPrint('✅ Remember me credentials cleared (Web)');
        }
      } else {
        await _storage.write(
            key: _rememberMeEnabledKey, value: rememberMe.toString());
        if (rememberMe) {
          await _storage.write(key: _rememberMeEmailKey, value: email);
          await _storage.write(key: _rememberMePasswordKey, value: password);
          debugPrint('✅ Remember me credentials saved (Mobile)');
        } else {
          await _storage.delete(key: _rememberMeEmailKey);
          await _storage.delete(key: _rememberMePasswordKey);
          debugPrint('✅ Remember me credentials cleared (Mobile)');
        }
      }
    } catch (e) {
      debugPrint('Error saving remember me credentials: $e');
    }
  }

  /// Get saved email for remember me
  Future<String?> getSavedEmail() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        final email = prefs.getString(_rememberMeEmailKey);
        debugPrint('🔍 Retrieved saved email from web storage: ${email != null ? "found" : "not found"}');
        return email;
      } else {
        final email = await _storage.read(key: _rememberMeEmailKey);
        debugPrint('🔍 Retrieved saved email from mobile storage: ${email != null ? "found" : "not found"}');
        return email;
      }
    } catch (e) {
      debugPrint('⚠️ Error getting saved email: $e');
      return null;
    }
  }

  /// Get saved password for remember me
  Future<String?> getSavedPassword() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        final password = prefs.getString(_rememberMePasswordKey);
        debugPrint('🔍 Retrieved saved password from web storage: ${password != null ? "found" : "not found"}');
        return password;
      } else {
        final password = await _storage.read(key: _rememberMePasswordKey);
        debugPrint('🔍 Retrieved saved password from mobile storage: ${password != null ? "found" : "not found"}');
        return password;
      }
    } catch (e) {
      debugPrint('⚠️ Error getting saved password: $e');
      return null;
    }
  }

  /// Clear remember me credentials
  Future<void> clearRememberMeCredentials() async {
    try {
      if (_isWeb) {
        final prefs = await _prefs;
        await Future.wait([
          prefs.remove(_rememberMeEnabledKey),
          prefs.remove(_rememberMeEmailKey),
          prefs.remove(_rememberMePasswordKey),
        ]);
      } else {
        await Future.wait([
          _storage.delete(key: _rememberMeEnabledKey),
          _storage.delete(key: _rememberMeEmailKey),
          _storage.delete(key: _rememberMePasswordKey),
        ]);
      }
      debugPrint('✅ Remember me credentials cleared');
    } catch (e) {
      debugPrint('Error clearing remember me credentials: $e');
    }
  }
}

// Provider for secure storage service
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
