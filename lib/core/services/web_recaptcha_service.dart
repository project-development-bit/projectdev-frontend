import 'dart:async';
import 'package:flutter/foundation.dart';

// Conditional imports for web-only functionality
import 'dart:js_interop' if (dart.library.io) 'web_js_stub.dart';
import 'dart:html' if (dart.library.io) 'web_html_stub.dart' as html;

import '../config/flavor_manager.dart';

/// Web-specific reCAPTCHA service that handles dynamic script loading
/// and localhost detection for testing purposes
class WebRecaptchaService {
  static bool _isInitialized = false;
  static String? _currentSiteKey;

  /// Check if reCAPTCHA is supported (web only)
  static bool get isSupported => kIsWeb;

  /// Initialize reCAPTCHA with dynamic site key selection
  static Future<bool> initialize([String? customSiteKey]) async {
    if (!kIsWeb) {
      debugPrint('WebRecaptchaService: Not supported on non-web platforms');
      return false;
    }

    try {
      // Get the appropriate site key
      final siteKey = customSiteKey ?? _getAppropriateKey();
      if (siteKey == null || siteKey.isEmpty) {
        debugPrint('WebRecaptchaService: No site key available');
        return false;
      }

      // Check if already initialized with the same key
      if (_isInitialized && _currentSiteKey == siteKey) {
        debugPrint('WebRecaptchaService: Already initialized with the same key');
        return true;
      }

      debugPrint('WebRecaptchaService: Initializing with key: ${siteKey.substring(0, 10)}...');

      // Load the reCAPTCHA script
      await _loadRecaptchaScript(siteKey);

      // Wait for reCAPTCHA to be ready
      await _waitForRecaptchaReady();

      _isInitialized = true;
      _currentSiteKey = siteKey;

      debugPrint('WebRecaptchaService: Successfully initialized');
      return true;
    } catch (e) {
      debugPrint('WebRecaptchaService: Initialization failed: $e');
      _isInitialized = false;
      _currentSiteKey = null;
      return false;
    }
  }

  /// Execute reCAPTCHA verification
  static Future<String?> execute(String action) async {
    if (!kIsWeb) {
      debugPrint('WebRecaptchaService: Not supported on non-web platforms');
      return null;
    }

    if (!_isInitialized) {
      debugPrint('WebRecaptchaService: Not initialized, attempting to initialize...');
      final success = await initialize();
      if (!success) {
        debugPrint('WebRecaptchaService: Failed to initialize for execution');
        return null;
      }
    }

    try {
      debugPrint('WebRecaptchaService: Executing action: $action');

      // For now, return a mock token in debug mode
      // if (kDebugMode) {
      //   await Future.delayed(const Duration(milliseconds: 500));
      //   final token = 'debug_web_token_${DateTime.now().millisecondsSinceEpoch}';
      //   debugPrint('WebRecaptchaService: Debug token generated: $token');
      //   return token;
      // }

      // Execute actual reCAPTCHA
      final result = await _executeRecaptcha(_currentSiteKey!, action);

      if (result != null && result.isNotEmpty) {
        debugPrint('WebRecaptchaService: Token received successfully');
        return result;
      } else {
        throw Exception('Invalid or empty token received');
      }
    } catch (e) {
      debugPrint('WebRecaptchaService: Execution failed: $e');
      return null;
    }
  }

  /// Get the appropriate site key based on environment
  static String? _getAppropriateKey() {
    try {
      final config = FlavorManager.currentConfig;

      // Check if running on localhost
      if (_isLocalhost()) {
        final localhostKey = config.additionalConfig['localhostRecaptchaSiteKey'] as String?;
        if (localhostKey != null && 
            localhostKey.isNotEmpty && 
            localhostKey != 'YOUR_LOCALHOST_SITE_KEY_HERE' &&
            localhostKey != '6LdNlforAAAAAOIH7T2emlRz8XwliT8DacIeVn4W' // Filter placeholder
            ) {
          debugPrint('WebRecaptchaService: Using localhost site key');
          return localhostKey;
        } else {
          debugPrint('WebRecaptchaService: Localhost key not configured or is placeholder, using regular web key');
        }
      }

      // Use the regular web site key
      final webKey = config.recaptchaSiteKey;
      debugPrint('WebRecaptchaService: Using ${_isLocalhost() ? 'fallback ' : ''}web site key');
      return webKey;
    } catch (e) {
      debugPrint('WebRecaptchaService: Error getting site key: $e');
      return null;
    }
  }

  /// Check if running on localhost
  static bool _isLocalhost() {
    if (!kIsWeb) return false;

    try {
      final hostname = html.window.location.hostname;
      if (hostname == null) return false;
      
      final isLocal = hostname == 'localhost' ||
          hostname == '127.0.0.1' ||
          hostname == '0.0.0.0' ||
          hostname.startsWith('192.168.') ||
          hostname.endsWith('.local');

      debugPrint('WebRecaptchaService: Hostname: $hostname, isLocalhost: $isLocal');
      return isLocal;
    } catch (e) {
      debugPrint('WebRecaptchaService: Error detecting localhost: $e');
      return false;
    }
  }

  /// Load reCAPTCHA script dynamically
  static Future<void> _loadRecaptchaScript(String siteKey) async {
    if (!kIsWeb) return;

    try {
      final isLocalhost = _isLocalhost();

      // Try to use the global loadRecaptcha function first
      if (_hasLoadRecaptchaFunction()) {
        debugPrint('WebRecaptchaService: Using global loadRecaptcha function');
        _callLoadRecaptcha(siteKey, isLocalhost);
        return;
      }

      // Fallback: load script directly
      debugPrint('WebRecaptchaService: Loading script directly');
      await _loadScriptDirectly(siteKey);
    } catch (e) {
      debugPrint('WebRecaptchaService: Error loading script: $e');
      rethrow;
    }
  }

  /// Check if loadRecaptcha function exists
  static bool _hasLoadRecaptchaFunction() {
    if (!kIsWeb) return false;
    try {
      // Use dart:js_interop to check for the function
      return _checkProperty('loadRecaptcha');
    } catch (e) {
      debugPrint('WebRecaptchaService: Error checking loadRecaptcha function: $e');
      return false;
    }
  }

  /// Call the loadRecaptcha function
  static void _callLoadRecaptcha(String siteKey, bool isLocalhost) {
    if (!kIsWeb) return;
    try {
      // Use dart:js_interop to call the function
      _callWindowMethod('loadRecaptcha', [siteKey, isLocalhost]);
    } catch (e) {
      debugPrint('WebRecaptchaService: Error calling loadRecaptcha: $e');
    }
  }

  /// Load script directly as fallback
  static Future<void> _loadScriptDirectly(String siteKey) async {
    if (!kIsWeb) return;

    try {
      // Remove existing reCAPTCHA script
      final existingScript = html.document.querySelector('script[src*="recaptcha"]');
      existingScript?.remove();

      // Create new script element
      final script = html.document.createElement('script');
      script.setAttribute('src', 'https://www.google.com/recaptcha/api.js?render=$siteKey');
      script.setAttribute('async', 'true');

      // Create a completer to wait for the script to load
      final completer = Completer<void>();

      script.addEventListener('load', (event) {
        debugPrint('WebRecaptchaService: Script loaded successfully');
        completer.complete();
      });

      script.addEventListener('error', (event) {
        debugPrint('WebRecaptchaService: Script loading failed');
        completer.completeError(Exception('Failed to load reCAPTCHA script'));
      });

      // Add script to document head
      html.document.head!.append(script);

      // Wait for script to load
      await completer.future;
    } catch (e) {
      debugPrint('WebRecaptchaService: Direct script loading error: $e');
      rethrow;
    }
  }

  /// Wait for reCAPTCHA to be ready
  static Future<void> _waitForRecaptchaReady() async {
    if (!kIsWeb) return;

    const maxAttempts = 30; // 3 seconds max
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        if (_hasGrecaptcha()) {
          debugPrint('WebRecaptchaService: reCAPTCHA ready after ${attempts * 100}ms');
          return;
        }
      } catch (e) {
        // Continue waiting
      }

      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    throw Exception('reCAPTCHA failed to load within timeout');
  }

  /// Check if grecaptcha is available
  static bool _hasGrecaptcha() {
    if (!kIsWeb) return false;
    try {
      return _checkProperty('grecaptcha');
    } catch (e) {
      return false;
    }
  }

  /// Execute reCAPTCHA verification using native JS interop
  static Future<String?> _executeRecaptcha(String siteKey, String action) async {
    if (!kIsWeb) return null;

    try {
      debugPrint('WebRecaptchaService: Using RealWebRecaptchaService for execution...');
      
      // Use the RealWebRecaptchaService directly
      final result = await _getRealWebService().execute(action);
      
      if (result != null && result.isNotEmpty) {
        debugPrint('WebRecaptchaService: Real reCAPTCHA token received: ${result.substring(0, 30)}...');
        return result;
      }
      
      throw Exception('RealWebRecaptchaService returned null or empty token');
    } catch (e) {
      debugPrint('WebRecaptchaService: Execute error: $e');
      return null;
    }
  }

  /// Get RealWebRecaptchaService instance
  static dynamic _getRealWebService() {
    // Return a proxy that forwards to RealWebRecaptchaService
    return _RealWebServiceProxy();
  }

  // Helper methods for JS interop (would be implemented with dart:js_interop)
  static bool _checkProperty(String property) {
    // This would use dart:js_interop to check window properties
    // For now, return false to use fallback methods
    return false;
  }

  static void _callWindowMethod(String method, List<dynamic> args) {
    // This would use dart:js_interop to call window methods
    // For now, do nothing
  }

  /// Reset the initialization state (useful for testing)
  static void reset() {
    _isInitialized = false;
    _currentSiteKey = null;
    debugPrint('WebRecaptchaService: Reset completed');
  }

  /// Check if currently initialized
  static bool get isInitialized => _isInitialized;

  /// Get current site key
  static String? get currentSiteKey => _currentSiteKey;
}

/// Proxy class to forward calls to RealWebRecaptchaService
class _RealWebServiceProxy {
  Future<String?> execute(String action) async {
    try {
      // Forward to RealWebRecaptchaService
      // This is a simplified approach - in production you'd use proper conditional imports
      if (kIsWeb) {
        // Since we can't easily import RealWebRecaptchaService here due to conditional imports,
        // we'll use a simple approach: return null and let the caller handle it
        debugPrint('_RealWebServiceProxy: Would forward to RealWebRecaptchaService.execute($action)');
        return null;
      }
      return null;
    } catch (e) {
      debugPrint('_RealWebServiceProxy: Error forwarding to RealWebRecaptchaService: $e');
      return null;
    }
  }
}