/// Stub implementation for Platform class on web
/// This file is used when dart:io is not available (web platform)
class Platform {
  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isWindows => false;
  static bool get isFuchsia => false;
  static String get operatingSystem => 'web';
  static String get operatingSystemVersion => 'unknown';
}

/// Stub implementation for RealWebRecaptchaService on non-web platforms
class RealWebRecaptchaService {
  static Future<bool> initialize(String siteKey) async {
    throw UnsupportedError('RealWebRecaptchaService is only supported on web');
  }

  static Future<String?> execute(String action) async {
    throw UnsupportedError('RealWebRecaptchaService is only supported on web');
  }

  static bool get isInitialized => false;
  static String? get currentSiteKey => null;
  static void reset() {}
}
