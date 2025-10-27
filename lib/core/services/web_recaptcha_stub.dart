/// Stub file for web reCAPTCHA functionality when running on mobile platforms
/// This prevents compilation errors when mobile-only packages are imported on web

class GRecaptchaV3 {
  static Future<bool> load(String siteKey) async {
    throw UnsupportedError('Web reCAPTCHA not available on mobile platforms');
  }
  
  static Future<String?> execute(String action) async {
    throw UnsupportedError('Web reCAPTCHA not available on mobile platforms');
  }
  
  static Future<bool> isReady() async {
    throw UnsupportedError('Web reCAPTCHA not available on mobile platforms');
  }
  
  static Future<void> reset() async {
    throw UnsupportedError('Web reCAPTCHA not available on mobile platforms');
  }
}