import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/auth/presentation/providers/verification_provider.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/verification_form_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class VerificationPage extends ConsumerWidget {
  final String email;
  final bool isSendCode;
  final bool isFromForgotPassword;
  final bool isFromChangeEmail;

  const VerificationPage({
    super.key,
    required this.email,
    this.isSendCode = false,
    this.isFromForgotPassword = false,
    this.isFromChangeEmail = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(verificationNotifierProvider) is VerificationLoading;
    return OnboardingBackground(
      childPadding: EdgeInsets.symmetric(
          vertical: context.isMobile ? 30.5 : 55.5,
          horizontal: context.isMobile ? 16 : 37),
      girlHeight: 500,
      girlRightOffset: -200,
      girlBottomOffset: -250,
      isLoading: isLoading,
      child: VerificationFormWidget(
        email: email,
        isFromForgotPassword: isFromForgotPassword,
        isSendCode: isSendCode,
      ),
    );
  }
}
