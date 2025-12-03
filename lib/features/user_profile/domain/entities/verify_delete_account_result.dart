/// Entity representing the result of verifying account deletion
/// This is the final step that confirms account deletion
class VerifyDeleteAccountResult {
  final bool success;
  final String message;
  final int deletedUserId;
  final String deletedEmail;

  VerifyDeleteAccountResult({
    required this.success,
    required this.message,
    required this.deletedUserId,
    required this.deletedEmail,
  });
}
