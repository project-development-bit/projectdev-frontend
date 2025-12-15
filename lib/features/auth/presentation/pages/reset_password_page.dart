import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordPage extends ConsumerWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobile;
    final isLoading = ref.watch(isResetPasswordLoadingProvider);

    return OnboardingBackground(
        maxContentWidth: 550,
        childPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 31,
          vertical: isMobile ? 24 : 47.5,
        ),
        girlHeight: 400,
        girlRightOffset: -150,
        girlBottomOffset: -170,
        isLoading: isLoading,
        child: ResetPasswordForm(email: email));
  }
}
