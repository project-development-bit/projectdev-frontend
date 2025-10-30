import 'package:flutter/foundation.dart';
import '../config/flavor_manager.dart';

// Conditional import for Platform - avoid importing dart:io on web
// Conditional imports for web-only functionality
import 'real_web_recaptcha_service.dart' if (dart.library.io) 'platform_stub.dart';
import 'real_mobile_recaptcha_service_official.dart'
    if (dart.library.js_util) 'platform_stub.dart' as mobile_service;
import 'dart:io' as io if (dart.library.io) 'dart:io';

/// Platform-aware reCAPTCHA service using different implementations per platform
/// - Web: Uses g_recaptcha_v3 package
/// - Mobile (Android/iOS): Uses recaptcha_enterprise_flutter package
class PlatformRecaptchaService {
  /// Check if current platform is web
  static bool get isWebPlatform => kIsWeb;

  /// Check if current platform is mobile (Android or iOS)
  static bool get isMobilePlatform => !kIsWeb && _isAndroidOrIOS;

  /// Check if current platform is Android
  static bool get isAndroid => !kIsWeb && _isAndroidPlatform;

  /// Check if current platform is iOS
  static bool get isIOS => !kIsWeb && _isIOSPlatform;

  // Web-safe platform checks
  static bool get _isAndroidOrIOS {
    if (kIsWeb) return false;
    try {
      return io.Platform.isAndroid || io.Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  static bool get _isAndroidPlatform {
    if (kIsWeb) return false;
    try {
      return io.Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  static bool get _isIOSPlatform {
    if (kIsWeb) return false;
    try {
      return io.Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  /// Check if reCAPTCHA is supported on current platform
  static bool get isSupported => isWebPlatform || isMobilePlatform;

  /// Get platform name for debugging
  static String get platformName {
    if (isWebPlatform) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    return 'Unknown';
  }

  /// Get reCAPTCHA site key from configuration for current platform
  static String? get siteKey => FlavorManager.recaptchaSiteKey;

  /// Initialize reCAPTCHA for the current platform
  static Future<bool> initialize([String? customSiteKey]) async {
    final key = customSiteKey ?? siteKey;
    if (key == null) {
      debugPrint(
          'reCAPTCHA: No site key configured for ${FlavorManager.flavorDisplayName} on $platformName');
      return false;
    }

    try {
      if (isWebPlatform) {

        // Web platform - use g_recaptcha_v3
        debugPrint(
            'reCAPTCHA: Initializing $platformName with g_recaptcha_v3...');
        debugPrint(
            'reCAPTCHA: Using site key for ${FlavorManager.flavorDisplayName}: ${key.substring(0, 10)}...');

        // Import and call g_recaptcha_v3
        final webRecaptcha = await _importWebRecaptcha();
        if (webRecaptcha != null) {
          final success = await webRecaptcha.ready(key);
          if (success) {
            debugPrint(
                'reCAPTCHA: Successfully initialized $platformName client with g_recaptcha_v3');
            return true;
          } else {
            debugPrint(
                'reCAPTCHA: Failed to load g_recaptcha_v3 on $platformName');
            return false;
          }
        }
        return false;
      } else if (isMobilePlatform) {
        // Mobile platform - use OFFICIAL Google reCAPTCHA Enterprise Flutter
        debugPrint(
            'reCAPTCHA: Initializing $platformName with OFFICIAL Google reCAPTCHA Enterprise...');
        debugPrint(
            'reCAPTCHA: Using site key for ${FlavorManager.flavorDisplayName}: ${key.substring(0, 10)}...');

        // Initialize using the OFFICIAL Google reCAPTCHA Enterprise service
        final success =
            await mobile_service.RealMobileRecaptchaService.initialize(key);
        if (success) {
          debugPrint(
              'reCAPTCHA: ✅ Successfully initialized $platformName with OFFICIAL Google reCAPTCHA Enterprise');
          return true;
        } else {
          debugPrint(
              'reCAPTCHA: ❌ Failed to initialize OFFICIAL Google reCAPTCHA Enterprise on $platformName');
          return false;
        }
      } else {
        debugPrint('reCAPTCHA: Platform not supported - $platformName');
        return false;
      }
    } catch (e) {
      debugPrint('reCAPTCHA: Initialization failed on $platformName - $e');
      return false;
    }
  }

  /// Execute reCAPTCHA verification
  static Future<String?> execute(String action) async {
    try {
      if (isWebPlatform) {
        // Skip reCAPTCHA in debug mode for web platform
        // if (kDebugMode && FlavorManager.areDebugFeaturesEnabled) {
        //   debugPrint(
        //       'reCAPTCHA: Skipping verification in debug mode for web platform (action: $action)');
        //   // Return a mock token for debugging
        //   return 'debug_mock_token_${DateTime.now().millisecondsSinceEpoch}';
        // }

        // Web platform - use g_recaptcha_v3
        debugPrint(
            'reCAPTCHA: Executing $platformName reCAPTCHA for action: $action');

        final webRecaptcha = await _importWebRecaptcha();
        if (webRecaptcha != null) {
          final token = await webRecaptcha.execute(action);
          debugPrint(
              'reCAPTCHA: $platformName execution completed, token received: ${token != null}');
          return token;
        }
        throw Exception('Failed to load web reCAPTCHA library');
      } else if (isMobilePlatform) {
        // Mobile platform - use OFFICIAL Google reCAPTCHA Enterprise
        debugPrint(
            'reCAPTCHA: Executing $platformName OFFICIAL Google reCAPTCHA Enterprise for action: $action');

        // Use the OFFICIAL Google mobile reCAPTCHA Enterprise service
        final token =
            await mobile_service.RealMobileRecaptchaService.execute(action);

        if (token != null && token.isNotEmpty) {
          debugPrint(
              'reCAPTCHA: ✅ $platformName OFFICIAL Google Enterprise execution completed, token received: true');
          debugPrint(
              'reCAPTCHA: 📏 $platformName token length: ${token.length} characters');

          // Compare token characteristics with web tokens
          if (token.length > 500) {
            debugPrint(
                'reCAPTCHA: ✨ $platformName generated REAL Google-length token!');
          }
          
          // Check for real Google reCAPTCHA token characteristics
          if (token.startsWith('03A')) {
            debugPrint(
                'reCAPTCHA: 🏆 $platformName token has genuine Google reCAPTCHA prefix!');
          }
          
          return token;
        } else {
          debugPrint(
              'reCAPTCHA: ❌ $platformName OFFICIAL Google Enterprise returned null/empty token');
          throw Exception(
              'OFFICIAL Google mobile reCAPTCHA Enterprise failed to generate token');
        }
      } else {
        debugPrint(
            'reCAPTCHA: Platform not supported for execution - $platformName');
        throw Exception('Platform not supported: $platformName');
      }
    } catch (e) {
      debugPrint('reCAPTCHA: Execution failed on $platformName - $e');
      rethrow;
    }
  }

  /// Check if reCAPTCHA can be executed on current platform
  static bool canExecute() {
    return isSupported;
  }

  /// Get platform-specific error message
  static String getPlatformErrorMessage() {
    if (isWebPlatform) {
      return 'Using g_recaptcha_v3 for web platform';
    }
    if (isMobilePlatform) {
      return 'Using reCAPTCHA Enterprise for mobile platform';
    }
    return 'reCAPTCHA is not supported on $platformName platform';
  }

  /// Import web reCAPTCHA dynamically to prevent compilation errors on mobile
  static Future<_WebRecaptchaWrapper?> _importWebRecaptcha() async {
    try {
      if (kIsWeb) {
        // Import g_recaptcha_v3 only on web
        return _WebRecaptchaWrapper();
      }
      return null;
    } catch (e) {
      debugPrint('reCAPTCHA: Could not import web reCAPTCHA package: $e');
      return null;
    }
  }
}

/// Wrapper for web reCAPTCHA to handle dynamic imports
class _WebRecaptchaWrapper {
  Future<bool> ready(String siteKey) async {
    if (kIsWeb) {
      // Use the new WebRecaptchaService for dynamic loading
      debugPrint('reCAPTCHA Web: Using WebRecaptchaService for initialization');
      final webService = await _importWebRecaptchaService();
      if (webService != null) {
        return await webService.initialize(siteKey);
      }
      return false;
    }
    return false;
  }

  Future<String?> execute(String action) async {
    if (kIsWeb) {
      // Use the new WebRecaptchaService for execution
      debugPrint('reCAPTCHA Web: Using WebRecaptchaService for execution');
      final webService = await _importWebRecaptchaService();
      if (webService != null) {
        return await webService.execute(action);
      }
      return null;
    }
    return null;
  }

  /// Import WebRecaptchaService dynamically
  Future<dynamic> _importWebRecaptchaService() async {
    try {
      // This would be replaced with proper dynamic import in production
      // For now, we'll simulate the import
      return _WebRecaptchaServiceWrapper();
    } catch (e) {
      debugPrint('reCAPTCHA Web: Failed to import WebRecaptchaService: $e');
      return null;
    }
  }
}

/// Wrapper for WebRecaptchaService to handle dynamic imports
class _WebRecaptchaServiceWrapper {
  Future<bool> initialize(String siteKey) async {
    try {
      // Use the real WebRecaptchaService implementation
      debugPrint('reCAPTCHA Web: Using RealWebRecaptchaService.initialize()');
      if (kIsWeb) {
        // Import is handled conditionally above
        return await RealWebRecaptchaService.initialize(siteKey);
      }
      return false;
    } catch (e) {
      debugPrint('reCAPTCHA Web: Initialize error: $e');
      return false;
    }
  }

  Future<String?> execute(String action) async {
    try {
      // Use the real WebRecaptchaService implementation
      debugPrint('reCAPTCHA Web: Using RealWebRecaptchaService.execute()');
      if (kIsWeb) {
        // Import is handled conditionally above
        return await RealWebRecaptchaService.execute(action);
      }
      return null;
    } catch (e) {
      debugPrint('reCAPTCHA Web: Execute error: $e');
      return null;
    }
  }
}
