/// Model for email verification request
class VerificationRequest {
  final String email;
  final String code;

  const VerificationRequest({
    required this.email,
    required this.code,
  });

  /// Create instance from JSON
  factory VerificationRequest.fromJson(Map<String, dynamic> json) {
    return VerificationRequest(
      email: json['email'] as String,
      code: json['code'] as String,
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'VerificationRequest(email: $email, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationRequest &&
        other.email == email &&
        other.code == code;
  }

  @override
  int get hashCode => email.hashCode ^ code.hashCode;
}