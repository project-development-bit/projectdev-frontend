/// Forgot password request model
///
/// Contains the email and Turnstile token needed to request password reset
class ForgotPasswordRequest {
  const ForgotPasswordRequest({
    required this.email,
    this.recaptchaToken,
  });

  /// The email address to send password reset to
  final String email;

  /// Turnstile verification token (using recaptchaToken field name for backend compatibility)
  final String? recaptchaToken;

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (recaptchaToken != null) 'recaptchaToken': recaptchaToken,
    };
  }

  /// Create from JSON (for testing purposes)
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(
      email: json['email'] as String,
      recaptchaToken: json['recaptchaToken'] as String?,
    );
  }

  @override
  String toString() => 'ForgotPasswordRequest(email: $email, hasToken: ${recaptchaToken != null})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordRequest && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
