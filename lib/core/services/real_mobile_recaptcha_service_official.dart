import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

// Import the official reCAPTCHA Enterprise Flutter package
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';

// Import our debug utility
import '../utils/package_info_debug.dart';

/// Real mobile reCAPTCHA service using the official Google reCAPTCHA Enterprise Flutter package
/// This implementation follows the official Google documentation and example code
/// Reference: https://github.com/GoogleCloudPlatform/recaptcha-enterprise-flutter/blob/main/example/lib/main.dart
class RealMobileRecaptchaService {
  static RecaptchaClient? _client;
  static String? _currentSiteKey;
  static bool _isInitialized = false;
  static bool _enterpriseAvailable = false;

  /// Initialize reCAPTCHA Enterprise client using official fetchClient method
  /// Based on official Google example: fetchClient() method
  static Future<bool> initialize(String siteKey) async {
    try {
      debugPrint('🚀 reCAPTCHA Mobile: Initializing with OFFICIAL Google Enterprise...');
      debugPrint('🔧 reCAPTCHA Mobile: Site key: ${siteKey.substring(0, 10)}...');
      
      // Store the site key
      _currentSiteKey = siteKey;
      
      // Use the OFFICIAL fetchClient method from Google's example
      debugPrint('📱 reCAPTCHA Mobile: Calling Recaptcha.fetchClient() - OFFICIAL METHOD');
      _client = await Recaptcha.fetchClient(siteKey);
      
      if (_client != null) {
        _isInitialized = true;
        _enterpriseAvailable = true;
        debugPrint('✅ reCAPTCHA Mobile: SUCCESS! REAL Google Enterprise client created');
        debugPrint('🎯 reCAPTCHA Mobile: Ready to generate REAL Google reCAPTCHA tokens');
        return true;
      } else {
        debugPrint('❌ reCAPTCHA Mobile: fetchClient returned null');
        _isInitialized = false;
        _enterpriseAvailable = false;
        return false;
      }
    } on PlatformException catch (err) {
      debugPrint('❌ reCAPTCHA Mobile: Platform exception during initialization: $err');
      debugPrint('❌ reCAPTCHA Mobile: Code: ${err.code}, Message: ${err.message}');
      
      // Check for package name error specifically
      if (err.code == 'FL_EXECUTE_FAILED' && err.message?.contains('Package name not allowed') == true) {
        debugPrint('');
        debugPrint('🚨 PACKAGE NAME ERROR DETECTED!');
        PackageInfoDebug.showPackageNameSolution();
      }
      
      _client = null;
      _currentSiteKey = null;
      _isInitialized = false;
      _enterpriseAvailable = false;
      return false;
    } catch (err) {
      debugPrint('❌ reCAPTCHA Mobile: General exception during initialization: $err');
      _client = null;
      _currentSiteKey = null;
      _isInitialized = false;
      _enterpriseAvailable = false;
      return false;
    }
  }

  /// Execute reCAPTCHA verification using official Google implementation
  /// Based on official Google example: executeWithFetchClient() method
  static Future<String?> execute(String action) async {
    try {
      if (!_isInitialized || _client == null) {
        debugPrint('❌ reCAPTCHA Mobile: Client not initialized - call initialize() first');
        return "Client not initialized yet, click button InitClient";
      }

      debugPrint('🚀 reCAPTCHA Mobile: Executing REAL Google Enterprise verification');
      debugPrint('📝 reCAPTCHA Mobile: Action: $action');

      // Convert action string to RecaptchaAction based on official Google example
      RecaptchaAction recaptchaAction;
      switch (action.toLowerCase()) {
        case 'login':
          recaptchaAction = RecaptchaAction.LOGIN();
          break;
        case 'signup':
          recaptchaAction = RecaptchaAction.SIGNUP();
          break;
        default:
          recaptchaAction = RecaptchaAction.custom(action);
          break;
      }

      debugPrint('🔧 reCAPTCHA Mobile: Using RecaptchaAction: ${recaptchaAction.action}');

      // Execute using the OFFICIAL method from Google's example
      debugPrint('⚡ reCAPTCHA Mobile: Calling _client.execute() - OFFICIAL METHOD');
      final token = await _client!.execute(recaptchaAction,timeout: 180000);
      
      if (token.isNotEmpty) {
        debugPrint('✅ reCAPTCHA Mobile: SUCCESS! REAL Google Enterprise token received');
        debugPrint('🎯 reCAPTCHA Mobile: Generated GENUINE Google reCAPTCHA token');
        debugPrint('📏 reCAPTCHA Mobile: Token length: ${token.length} characters');
        debugPrint('🔍 reCAPTCHA Mobile: Token preview: ${token.substring(0, token.length > 50 ? 50 : token.length)}...');
        
        // Validate token characteristics
        if (token.length > 500) {
          debugPrint('✨ reCAPTCHA Mobile: Token length confirms this is a REAL Google token!');
        } else {
          debugPrint('⚠️ reCAPTCHA Mobile: Token shorter than expected for real Google tokens');
        }
        
        if (token.startsWith('03A')) {
          debugPrint('🏆 reCAPTCHA Mobile: Token prefix matches Google reCAPTCHA format!');
        }
        
        return token;
      } else {
        debugPrint('⚠️ reCAPTCHA Mobile: Enterprise verification returned empty token');
        return null;
      }
    } on PlatformException catch (err) {
      debugPrint('❌ reCAPTCHA Mobile: Platform exception during execution: $err');
      debugPrint('❌ reCAPTCHA Mobile: Code: ${err.code}, Message: ${err.message}');
      
      // Check for package name error specifically
      if (err.code == 'FL_EXECUTE_FAILED' && err.message?.contains('Package name not allowed') == true) {
        debugPrint('');
        debugPrint('🚨 PACKAGE NAME ERROR DETECTED DURING TOKEN GENERATION!');
        PackageInfoDebug.showPackageNameSolution();
      }
      
      return 'Code: ${err.code} Message ${err.message}';
    } catch (err) {
      debugPrint('❌ reCAPTCHA Mobile: General exception during execution: $err');
      return err.toString();
    }
  }

  /// Check if client is initialized
  static bool get isInitialized => _isInitialized && _client != null;

  /// Check if using real Enterprise (always true when initialized successfully)
  static bool get isEnterpriseMode => _enterpriseAvailable;

  /// Get current site key
  static String? get currentSiteKey => _currentSiteKey;

  /// Get platform-specific site key helper (following Google's example pattern)
  static String getSiteKey(String androidSiteKey, String iosSiteKey) {
    return Platform.isAndroid ? androidSiteKey : iosSiteKey;
  }

  /// Dispose client and reset state
  static void dispose() {
    debugPrint('🧹 reCAPTCHA Mobile: Disposing REAL Google Enterprise client');
    _client = null;
    _currentSiteKey = null;
    _isInitialized = false;
    _enterpriseAvailable = false;
  }

  /// Reset the service for testing purposes
  static void reset() {
    dispose();
    debugPrint('🔄 reCAPTCHA Mobile: REAL Enterprise service reset completed');
  }
}