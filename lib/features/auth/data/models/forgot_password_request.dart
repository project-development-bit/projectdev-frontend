/// Forgot password request model
/// 
/// Contains the email needed to request password reset
class ForgotPasswordRequest {
  const ForgotPasswordRequest({
    required this.email,
  });

  /// The email address to send password reset to
  final String email;

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  /// Create from JSON (for testing purposes)
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'ForgotPasswordRequest(email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordRequest && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}