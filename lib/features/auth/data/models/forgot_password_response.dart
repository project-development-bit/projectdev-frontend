/// Forgot password data model
///
/// Contains the data returned from forgot password API
class ForgotPasswordData {
  const ForgotPasswordData({
    required this.email,
    required this.securityCode,
  });

  /// The email address that received the security code
  final String email;

  /// The security code sent to the email
  final int securityCode;

  /// Create from JSON response
  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      email: json['email'] as String,
      securityCode: json['securityCode'] as int,
    );
  }

  /// Convert to JSON (for testing/debugging)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'securityCode': securityCode,
    };
  }

  @override
  String toString() =>
      'ForgotPasswordData(email: $email, securityCode: $securityCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordData &&
        other.email == email &&
        other.securityCode == securityCode;
  }

  @override
  int get hashCode => Object.hash(email, securityCode);
}

/// Forgot password response model
///
/// Contains the complete response from the forgot password API endpoint
class ForgotPasswordResponse {
  const ForgotPasswordResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Whether the request was successful
  final bool success;

  /// Response message from server
  final String message;

  /// The forgot password data containing email and security code
  final ForgotPasswordData data;

  /// Create from JSON response
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ForgotPasswordData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Convert to JSON (for testing/debugging)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }

  @override
  String toString() =>
      'ForgotPasswordResponse(success: $success, message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordResponse &&
        other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => Object.hash(success, message, data);
}
