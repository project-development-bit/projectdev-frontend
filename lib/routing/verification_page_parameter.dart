/// Parameter class for VerificationPage navigation
class VerificationPageParameter {
  final String email;
  final bool isSendCode;
  final bool isFromForgotPassword;

  const VerificationPageParameter({
    required this.email,
    this.isSendCode = false,
    this.isFromForgotPassword = false,
  });

  /// Create a copy with updated parameters
  VerificationPageParameter copyWith({
    String? email,
    bool? isSendCode,
    bool? isFromForgotPassword,
  }) {
    return VerificationPageParameter(
      email: email ?? this.email,
      isSendCode: isSendCode ?? this.isSendCode,
      isFromForgotPassword: isFromForgotPassword ?? this.isFromForgotPassword,
    );
  }

  @override
  String toString() {
    return 'VerificationPageParameter(email: $email, isSendCode: $isSendCode, isFromForgotPassword: $isFromForgotPassword)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationPageParameter &&
        other.email == email &&
        other.isSendCode == isSendCode &&
        other.isFromForgotPassword == isFromForgotPassword;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        isSendCode.hashCode ^
        isFromForgotPassword.hashCode;
  }
}