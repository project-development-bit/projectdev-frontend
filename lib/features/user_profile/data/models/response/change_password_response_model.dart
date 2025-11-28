/// Change Password Response Model
///
/// Represents the response from `PATCH /users/password`
class ChangePasswordResponseModel {
  const ChangePasswordResponseModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
