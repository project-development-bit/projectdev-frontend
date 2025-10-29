import 'package:flutter/foundation.dart';
import 'app_flavor.dart';

// Conditional import for Platform - avoid importing dart:io on web
import 'dart:io' as io
    if (dart.library.js_interop) '../services/platform_stub.dart';

/// Configuration class that holds environment-specific settings
class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableCrashReporting;
  final bool enableAnalytics;
  final bool enableDebugFeatures;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic> additionalConfig;

  // reCAPTCHA Enterprise site keys for different platforms
  final String? androidRecaptchaSiteKey;
  final String? iosRecaptchaSiteKey;

  // Legacy web support (for backward compatibility)
  final String? webRecaptchaSiteKey;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableCrashReporting,
    required this.enableAnalytics,
    required this.enableDebugFeatures,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.additionalConfig = const {},
    this.androidRecaptchaSiteKey,
    this.iosRecaptchaSiteKey,
    this.webRecaptchaSiteKey,
  });

  /// Get the appropriate reCAPTCHA site key for the current platform
  String? get recaptchaSiteKey {
    // For web platform, check if we're on localhost
    if (kIsWeb) {
      // Check if we're running on localhost
      if (_isLocalhost()) {
        final localhostKey = additionalConfig['localhostRecaptchaSiteKey'] as String?;
        if (localhostKey != null && localhostKey.isNotEmpty) {
          return localhostKey;
        }
      }
      return webRecaptchaSiteKey;
    }

    try {
      if (io.Platform.isAndroid) return androidRecaptchaSiteKey;
      if (io.Platform.isIOS) return iosRecaptchaSiteKey;
    } catch (e) {
      // Platform not available (e.g., on web)
    }
    
    return webRecaptchaSiteKey; // Fallback for web or other platforms
  }

  /// Check if running on localhost (web only)
  bool _isLocalhost() {
    if (!kIsWeb) return false;
    
    // This is a web-safe way to check localhost
    // We'll use a basic check since we can't access window.location directly in this context
    // The actual localhost detection will be handled by the web service layer
    return flavor == AppFlavor.dev; // Use localhost key for dev flavor on web
  }

  /// Development configuration
  static const AppConfig dev = AppConfig(
    flavor: AppFlavor.dev,
    appName: 'Gigafaucet (Dev)',
    apiBaseUrl: 'https://api.gigafaucet.com/api/v1/',
    enableLogging: true,
    enableCrashReporting: false,
    enableAnalytics: false,
    enableDebugFeatures: true,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
    androidRecaptchaSiteKey:
        '6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5', // Dev Android key
    iosRecaptchaSiteKey:
        '6Lc8qvkrAAAAABmU7uNaaAWgMs8YTt_xyAi19IEG', // Dev iOS key
    webRecaptchaSiteKey:
        '6LceIvUrAAAAAHhQuc2U0uXTfscW181dIdPT208i', // Dev Web key for backward compatibility
    additionalConfig: {
      'localhostRecaptchaSiteKey':
          '6LdNlforAAAAAOIH7T2emlRz8XwliT8DacIeVn4W', // Add your localhost site key here
      'debugShowCheckedModeBanner': true,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'debug',
      'enableMockData': true,
      'enableFeatureFlags': true,
    },
  );

  /// Staging configuration
  static const AppConfig staging = AppConfig(
    flavor: AppFlavor.staging,
    appName: 'Gigafaucet (Staging)',
    apiBaseUrl: 'https://api.gigafaucet.com/api/v1/',
    enableLogging: true,
    enableCrashReporting: true,
    enableAnalytics: false,
    enableDebugFeatures: true,
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
    sendTimeout: Duration(seconds: 20),
    androidRecaptchaSiteKey:
        '6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5', // Staging Android key
    iosRecaptchaSiteKey:
        '6Lc8qvkrAAAAABmU7uNaaAWgMs8YTt_xyAi19IEG', // Staging iOS key
    webRecaptchaSiteKey:
        '6LceIvUrAAAAAHhQuc2U0uXTfscW181dIdPT208i', // Staging Web key
    additionalConfig: {
      'localhostRecaptchaSiteKey': '6LdNlforAAAAAOIH7T2emlRz8XwliT8DacIeVn4W', 
      'debugShowCheckedModeBanner': false,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'info',
      'enableMockData': false,
      'enableFeatureFlags': true,
    },
  );

  /// Production configuration
  static const AppConfig prod = AppConfig(
    flavor: AppFlavor.prod,
    appName: 'Gigafaucet',
    apiBaseUrl: 'https://api.gigafaucet.com/api/v1/',
    enableLogging: false,
    enableCrashReporting: true,
    enableAnalytics: true,
    enableDebugFeatures: false,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
    androidRecaptchaSiteKey:
        '6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5', // Production Android key
    iosRecaptchaSiteKey:
        '6Lc8qvkrAAAAABmU7uNaaAWgMs8YTt_xyAi19IEG', // Production iOS key
    webRecaptchaSiteKey:
        '6LceIvUrAAAAAHhQuc2U0uXTfscW181dIdPT208i', // Production Web key
    additionalConfig: {
      'localhostRecaptchaSiteKey': '6LdNlforAAAAAOIH7T2emlRz8XwliT8DacIeVn4W', 
      'debugShowCheckedModeBanner': false,
      'debugShowMaterialGrid': false,
      'showPerformanceOverlay': false,
      'showSemanticsDebugger': false,
      'maxLogLevel': 'error',
      'enableMockData': false,
      'enableFeatureFlags': false,
    },
  );

  /// Get configuration based on flavor
  static AppConfig getConfig(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return dev;
      case AppFlavor.staging:
        return staging;
      case AppFlavor.prod:
        return prod;
    }
  }

  /// Check if a feature is enabled
  bool isFeatureEnabled(String featureName) {
    return additionalConfig['enableFeatureFlags'] == true &&
        additionalConfig[featureName] == true;
  }

  /// Get a configuration value
  T? getConfigValue<T>(String key) {
    return additionalConfig[key] as T?;
  }

  /// Get the full API URL with version
  String get fullApiUrl => apiBaseUrl;

  /// Get the app display name
  String get displayName => appName;

  /// Get bundle ID suffix
  String get bundleIdSuffix => flavor.appSuffix;

  /// Check if this is a debug build
  bool get isDebugBuild => enableDebugFeatures;

  /// Check if this is a release build
  bool get isReleaseBuild => !enableDebugFeatures;

  @override
  String toString() {
    return 'AppConfig(flavor: ${flavor.name}, appName: $appName, apiBaseUrl: $apiBaseUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppConfig &&
        other.flavor == flavor &&
        other.appName == appName &&
        other.apiBaseUrl == apiBaseUrl;
  }

  @override
  int get hashCode {
    return flavor.hashCode ^ appName.hashCode ^ apiBaseUrl.hashCode;
  }

  static String get appUrl => "http://13.250.102.238/api/v1/";
}
