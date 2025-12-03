/// Response model for verify delete account API
/// This is the final step that confirms account deletion
class VerifyDeleteAccountResponseModel {
  final bool success;
  final String message;
  final int deletedUserId;
  final String deletedEmail;

  VerifyDeleteAccountResponseModel({
    required this.success,
    required this.message,
    required this.deletedUserId,
    required this.deletedEmail,
  });

  factory VerifyDeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    return VerifyDeleteAccountResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Account deleted successfully.',
      deletedUserId: data['deleted_user_id'] as int? ?? 0,
      deletedEmail: data['deleted_email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'deleted_user_id': deletedUserId,
        'deleted_email': deletedEmail,
      },
    };
  }
}
