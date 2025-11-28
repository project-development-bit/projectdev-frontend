/// Domain entity for verify email change result
class VerifyEmailChangeResult {
  const VerifyEmailChangeResult({required this.message, required this.oldEmail, required this.newEmail});

  final String message;
  final String oldEmail;
  final String newEmail;
}
