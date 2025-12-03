/// Entity representing the result of a verify delete account operation
class VerifyDeleteAccountResult {
  final bool success;
  final String message;
  final int? deletedUserId;
  final String? deletedEmail;

  VerifyDeleteAccountResult({
    required this.success,
    required this.message,
    this.deletedUserId,
    this.deletedEmail,
  });
}
