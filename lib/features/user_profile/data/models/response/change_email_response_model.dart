/// Change Email Response Model
///
/// Represents the response from `PATCH /users/email`
class ChangeEmailResponseModel {
  const ChangeEmailResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ChangeEmailData? data;

  factory ChangeEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeEmailResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map
          ? ChangeEmailData.fromJson(Map<String, dynamic>.from(json['data'] as Map))
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

class ChangeEmailData {
  const ChangeEmailData({
    required this.currentEmail,
    required this.newEmail,
    required this.verificationCode,
  });

  final String currentEmail;
  final String newEmail;
  final int? verificationCode;

  factory ChangeEmailData.fromJson(Map<String, dynamic> json) {
    return ChangeEmailData(
      currentEmail: json['current_email'] as String? ?? '',
      newEmail: json['new_email'] as String? ?? '',
      verificationCode: json['verification_code'] is int
          ? json['verification_code'] as int
          : (json['verification_code'] != null
              ? int.tryParse(json['verification_code'].toString())
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_email': currentEmail,
      'new_email': newEmail,
      'verification_code': verificationCode,
    };
  }
}
