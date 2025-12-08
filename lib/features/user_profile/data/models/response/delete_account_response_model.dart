/// Response model for delete account API
/// This is the first step that sends verification code to email
class DeleteAccountResponseModel {
  final bool success;
  final String message;
  final String email;
  final int verificationCode;

  DeleteAccountResponseModel({
    required this.success,
    required this.message,
    required this.email,
    required this.verificationCode,
  });

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    return DeleteAccountResponseModel(
      success: json['success'] as bool? ?? false,
      message:
          json['message'] as String? ?? 'Verification code sent to your email.',
      email: data['email'] as String? ?? '',
      verificationCode: data['verification_code'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'email': email,
        'verification_code': verificationCode,
      },
    };
  }
}
