import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/verification_form_widget.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  final String email;
  final bool isSendCode;
  final bool isFromForgotPassword;

  const VerificationPage({
    super.key,
    required this.email,
    this.isSendCode = false,
    this.isFromForgotPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingBackground(
      childPadding: EdgeInsets.symmetric(
          vertical: context.isMobile ? 30.5 : 55.5,
          horizontal: context.isMobile ? 16 : 37),
      child: VerificationFormWidget(
        email: email,
        isFromForgotPassword: isFromForgotPassword,
        isSendCode: isSendCode,
      ),
    );
  }
}
