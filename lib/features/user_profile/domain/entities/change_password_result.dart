/// Change Password Result Entity
///
/// Represents the result of a change password operation
class ChangePasswordResult {
  const ChangePasswordResult({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}
