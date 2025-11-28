/// Verify Email Change Response Model
///
/// Represents the response from `GET /users/verify-email-change/{email}/{code}`
class VerifyEmailChangeResponseModel {
  const VerifyEmailChangeResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final VerifyEmailChangeData? data;

  factory VerifyEmailChangeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailChangeResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map
          ? VerifyEmailChangeData.fromJson(Map<String, dynamic>.from(json['data'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class VerifyEmailChangeData {
  const VerifyEmailChangeData({required this.oldEmail, required this.newEmail});

  final String oldEmail;
  final String newEmail;

  factory VerifyEmailChangeData.fromJson(Map<String, dynamic> json) {
    return VerifyEmailChangeData(
      oldEmail: json['old_email'] as String? ?? json['current_email'] as String? ?? '',
      newEmail: json['new_email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'old_email': oldEmail,
      'new_email': newEmail,
    };
  }
}
