/// Entity representing the result of a delete account operation
class DeleteAccountResult {
  final bool success;
  final String message;
  final String? email;
  final int? verificationCode;

  DeleteAccountResult({
    required this.success,
    required this.message,
    this.email,
    this.verificationCode,
  });
}
