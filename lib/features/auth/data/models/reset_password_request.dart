/// Reset password request model
/// 
/// Contains the email, new password, and confirmation needed to reset password
class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  /// The email address of the user
  final String email;

  /// The new password
  final String password;

  /// Password confirmation (must match password)
  final String confirmPassword;

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }

  /// Create from JSON (for testing purposes)
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );
  }

  @override
  String toString() => 'ResetPasswordRequest(email: $email, password: [HIDDEN], confirmPassword: [HIDDEN])';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetPasswordRequest &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword;
  }

  @override
  int get hashCode => Object.hash(email, password, confirmPassword);

  /// Copy with method for easy modification
  ResetPasswordRequest copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return ResetPasswordRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  /// Validate that passwords match
  bool get isPasswordMatched => password == confirmPassword;

  /// Validate basic password requirements
  bool get isPasswordValid => password.length >= 8;

  /// Check if all fields are provided
  bool get isComplete => 
      email.isNotEmpty && 
      password.isNotEmpty && 
      confirmPassword.isNotEmpty;
}