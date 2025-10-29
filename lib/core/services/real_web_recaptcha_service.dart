import 'package:flutter/foundation.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

/// Real implementation of reCAPTCHA for web using g_recaptcha_v3 package
class RealWebRecaptchaService {
  static bool _isInitialized = false;
  static String? _currentSiteKey;

  /// Initialize reCAPTCHA with the given site key
  static Future<bool> initialize(String siteKey) async {
    if (!kIsWeb) {
      debugPrint('RealWebRecaptchaService: Not supported on non-web platforms');
      return false;
    }

    try {
      debugPrint('RealWebRecaptchaService: Initializing with site key: ${siteKey.substring(0, 10)}...');
      
      // Initialize g_recaptcha_v3
      final success = await GRecaptchaV3.ready(siteKey);
      
      if (success) {
        _isInitialized = true;
        _currentSiteKey = siteKey;
        debugPrint('RealWebRecaptchaService: ✅ Successfully initialized with g_recaptcha_v3');
        return true;
      } else {
        debugPrint('RealWebRecaptchaService: ❌ Failed to initialize g_recaptcha_v3');
        return false;
      }
    } catch (e) {
      debugPrint('RealWebRecaptchaService: ❌ Initialization error: $e');
      _isInitialized = false;
      _currentSiteKey = null;
      return false;
    }
  }

  /// Execute reCAPTCHA verification and get real token
  static Future<String?> execute(String action) async {
    if (!kIsWeb) {
      debugPrint('RealWebRecaptchaService: Not supported on non-web platforms');
      return null;
    }

    if (!_isInitialized || _currentSiteKey == null) {
      debugPrint('RealWebRecaptchaService: Not initialized, attempting to initialize...');
      // This shouldn't happen in normal flow, but let's be safe
      return null;
    }

    try {
      debugPrint('RealWebRecaptchaService: 🔄 Executing real reCAPTCHA for action: $action');
      
      // Execute the actual reCAPTCHA verification
      final token = await GRecaptchaV3.execute(action);
      
      if (token != null && token.isNotEmpty) {
        debugPrint('RealWebRecaptchaService: ✅ Real reCAPTCHA token received: ${token.substring(0, 30)}...');
        return token;
      } else {
        debugPrint('RealWebRecaptchaService: ❌ Empty or null token received');
        return null;
      }
    } catch (e) {
      debugPrint('RealWebRecaptchaService: ❌ Execution error: $e');
      return null;
    }
  }

  /// Check if reCAPTCHA is initialized
  static bool get isInitialized => _isInitialized;

  /// Get current site key
  static String? get currentSiteKey => _currentSiteKey;

  /// Reset the service (useful for testing)
  static void reset() {
    _isInitialized = false;
    _currentSiteKey = null;
    debugPrint('RealWebRecaptchaService: Service reset');
  }
}