/// Response model for delete account API
class DeleteAccountResponseModel {
  final bool success;
  final String message;
  final String? email;
  final int? verificationCode;

  DeleteAccountResponseModel({
    required this.success,
    required this.message,
    this.email,
    this.verificationCode,
  });

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return DeleteAccountResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      email: data?['email'] as String?,
      verificationCode: data?['verification_code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (email != null || verificationCode != null)
        'data': {
          if (email != null) 'email': email,
          if (verificationCode != null) 'verification_code': verificationCode,
        },
    };
  }
}
