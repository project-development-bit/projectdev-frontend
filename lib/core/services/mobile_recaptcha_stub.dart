/// Stub file for mobile reCAPTCHA Enterprise functionality when running on web platforms
/// This prevents compilation errors when mobile-only packages are imported on web

class Recaptcha {
  static Future<RecaptchaClient> fetchClient(String siteKey) async {
    throw UnsupportedError('Mobile reCAPTCHA Enterprise not available on web platforms');
  }
}

class RecaptchaClient {
  Future<String> execute(RecaptchaAction action) async {
    throw UnsupportedError('Mobile reCAPTCHA Enterprise not available on web platforms');
  }
}

class RecaptchaAction {
  static RecaptchaAction custom(String action) {
    throw UnsupportedError('Mobile reCAPTCHA Enterprise not available on web platforms');
  }
}