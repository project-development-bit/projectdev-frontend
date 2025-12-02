/// Entity representing the result of a delete account operation
class DeleteAccountResult {
  final bool success;
  final String message;

  DeleteAccountResult({
    required this.success,
    required this.message,
  });
}
