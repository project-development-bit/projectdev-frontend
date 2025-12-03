/// Response model for verify delete account API
class VerifyDeleteAccountResponseModel {
  final bool success;
  final String message;
  final int? deletedUserId;
  final String? deletedEmail;

  VerifyDeleteAccountResponseModel({
    required this.success,
    required this.message,
    this.deletedUserId,
    this.deletedEmail,
  });

  factory VerifyDeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return VerifyDeleteAccountResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      deletedUserId: data?['deleted_user_id'] as int?,
      deletedEmail: data?['deleted_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (deletedUserId != null || deletedEmail != null)
        'data': {
          if (deletedUserId != null) 'deleted_user_id': deletedUserId,
          if (deletedEmail != null) 'deleted_email': deletedEmail,
        },
    };
  }
}
