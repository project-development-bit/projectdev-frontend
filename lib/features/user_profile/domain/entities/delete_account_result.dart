/// Entity representing the result of a delete account operation
/// This is the first step that sends verification code
class DeleteAccountResult {
  final bool success;
  final String message;
  final String email;
  final int verificationCode;

  DeleteAccountResult({
    required this.success,
    required this.message,
    required this.email,
    required this.verificationCode,
  });
}
