/// Enum representing different app flavors/environments
enum AppFlavor {
  dev,
  staging,
  prod,
}

/// Extension to provide convenient methods for AppFlavor
extension AppFlavorExtension on AppFlavor {
  /// Get the display name of the flavor
  String get displayName {
    switch (this) {
      case AppFlavor.dev:
        return 'Development';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.prod:
        return 'Production';
    }
  }

  /// Get the short name of the flavor
  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'dev';
      case AppFlavor.staging:
        return 'staging';
      case AppFlavor.prod:
        return 'prod';
    }
  }

  /// Get the app suffix for the flavor
  String get appSuffix {
    switch (this) {
      case AppFlavor.dev:
        return '.dev';
      case AppFlavor.staging:
        return '.staging';
      case AppFlavor.prod:
        return '';
    }
  }

  /// Get the app name with flavor suffix
  String getAppName(String baseName) {
    switch (this) {
      case AppFlavor.dev:
        return '$baseName (Dev)';
      case AppFlavor.staging:
        return '$baseName (Staging)';
      case AppFlavor.prod:
        return baseName;
    }
  }

  /// Check if this is a development flavor
  bool get isDevelopment => this == AppFlavor.dev;

  /// Check if this is a staging flavor
  bool get isStaging => this == AppFlavor.staging;

  /// Check if this is a production flavor
  bool get isProduction => this == AppFlavor.prod;

  /// Check if debug features should be enabled
  bool get enableDebugFeatures => this != AppFlavor.prod;

  /// Check if logging should be enabled
  bool get enableLogging => this != AppFlavor.prod;

  /// Check if crash reporting should be enabled
  bool get enableCrashReporting => this == AppFlavor.prod;

  /// Check if analytics should be enabled
  bool get enableAnalytics => this == AppFlavor.prod;
}