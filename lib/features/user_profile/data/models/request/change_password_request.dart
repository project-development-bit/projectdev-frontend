/// Change Password Request Model
///
/// Represents the request body for `PATCH /users/password`
class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.repeatNewPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String repeatNewPassword;

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'repeat_new_password': repeatNewPassword,
    };
  }
}
