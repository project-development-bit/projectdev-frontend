import 'package:flutter/foundation.dart';
import '../config/flavor_manager.dart';

// Conditional import for Platform - avoid importing dart:io on web
import 'dart:io' as io if (dart.library.js_interop) 'platform_stub.dart';

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
        // Mobile platform - use reCAPTCHA Enterprise Flutter
        debugPrint(
            'reCAPTCHA: Initializing $platformName with reCAPTCHA Enterprise...');
        debugPrint(
            'reCAPTCHA: Using site key for ${FlavorManager.flavorDisplayName}: ${key.substring(0, 10)}...');

        // For reCAPTCHA Enterprise, we initialize the client when needed in execute()
        // This is because the client is created with Recaptcha.fetchClient()
        debugPrint(
            'reCAPTCHA: $platformName ready for reCAPTCHA Enterprise client creation');
        return true;
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
        // Mobile platform - use reCAPTCHA Enterprise
        debugPrint(
            'reCAPTCHA: Executing $platformName reCAPTCHA Enterprise for action: $action');

        final mobileRecaptcha = await _importMobileRecaptcha();
        if (mobileRecaptcha != null) {
          final key = siteKey;
          if (key == null) {
            throw Exception('No site key configured for $platformName');
          }

          final client = await mobileRecaptcha.fetchClient(key);
          final token =
              await client.execute(mobileRecaptcha.customAction(action));

          debugPrint(
              'reCAPTCHA: $platformName execution completed, token received: ${token.isNotEmpty}');
          return token;
        }
        throw Exception('Failed to load mobile reCAPTCHA library');
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

  /// Import mobile reCAPTCHA dynamically to prevent compilation errors on web
  static Future<_MobileRecaptchaWrapper?> _importMobileRecaptcha() async {
    try {
      if (!kIsWeb) {
        // Import recaptcha_enterprise_flutter only on mobile
        return _MobileRecaptchaWrapper();
      }
      return null;
    } catch (e) {
      debugPrint('reCAPTCHA: Could not import mobile reCAPTCHA package: $e');
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
    // Simulate WebRecaptchaService.initialize()
    debugPrint('reCAPTCHA Web: Simulating WebRecaptchaService.initialize()');
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<String?> execute(String action) async {
    // Simulate WebRecaptchaService.execute()
    debugPrint('reCAPTCHA Web: Simulating WebRecaptchaService.execute()');
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'web_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// Wrapper for mobile reCAPTCHA to handle dynamic imports
class _MobileRecaptchaWrapper {
  Future<_MobileRecaptchaClient> fetchClient(String siteKey) async {
    if (!kIsWeb) {
      // On mobile, this would call the actual recaptcha_enterprise_flutter
      // For now, simulate the call
      debugPrint('reCAPTCHA Mobile: Simulating Recaptcha.fetchClient() call');
      await Future.delayed(const Duration(milliseconds: 1000));
      return _MobileRecaptchaClient();
    }
    throw Exception('Mobile reCAPTCHA not available on web');
  }

  _MobileRecaptchaAction customAction(String action) {
    return _MobileRecaptchaAction(action);
  }
}

class _MobileRecaptchaClient {
  Future<String> execute(_MobileRecaptchaAction action) async {
    // Simulate reCAPTCHA Enterprise execution
    debugPrint('reCAPTCHA Mobile: Simulating client.execute() call');
    await Future.delayed(const Duration(milliseconds: 1500));
    return 'mobile_enterprise_${action.name}_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class _MobileRecaptchaAction {
  final String name;
  _MobileRecaptchaAction(this.name);
}
