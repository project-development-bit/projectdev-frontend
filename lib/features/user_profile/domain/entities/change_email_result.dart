/// Domain entity for change email result
class ChangeEmailResult {
  const ChangeEmailResult({
    required this.message,
    required this.currentEmail,
    required this.newEmail,
    required this.verificationCode,
  });

  final String message;
  final String currentEmail;
  final String newEmail;
  final int? verificationCode;
}
