import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_button.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/enum/user_role.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/core/providers/consolidated_auth_provider.dart';
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/core/theme/app_colors.dart';
import 'package:gigafaucet/features/auth/presentation/providers/login_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/selected_country_provider.dart';
// import 'package:gigafaucet/features/auth/presentation/widgets/web_google_signin_button.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class GoogleSignupButton extends ConsumerStatefulWidget {
  const GoogleSignupButton(
      {super.key, this.referralCode, required this.agreeToTerms});
  final String? referralCode;
  final bool agreeToTerms; // This should be managed via state in real use
  @override
  ConsumerState<GoogleSignupButton> createState() => _GoogleSignupButtonState();
}

class _GoogleSignupButtonState extends ConsumerState<GoogleSignupButton> {
  @override
  initState() {
    super.initState();

    ref.listenManual<LoginState>(loginNotifierProvider, (previous, next) {
      if (!mounted) return;

      switch (next) {
        case LoginSuccess():
          // Navigate to verification page on successful registration
          _afterLoginSuccess();
          context.showSnackBar(
              message: 'Google Registration successful!',
              backgroundColor: AppColors.success);
          break;
        case LoginError():

          // Show error message
          context.showSnackBar(
              message: next.message,
              backgroundColor: Theme.of(context).colorScheme.error);
          break;
        default:
          break;
      }
    });
  }

  void _afterLoginSuccess() {
    GoRouter.of(context).go(AppRoutes.home);
    ref.read(getProfileNotifierProvider.notifier).fetchProfile();
    ref.read(currentUserProvider.notifier).getCurrentUser();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return CommonButton(
      text: 'Google',
      onPressed: () {
        _handleGoogleSignUp();
      },
      icon: CommonImage(
        imageUrl: AppLocalImages.googleLogo,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
      isOutlined: true,
      textColor: Color(0xFF333333),
      height: 48,
    );
  }

  Future<void> _handleGoogleSignUp({String? idToken}) async {
    if (!widget.agreeToTerms) {
      final localizations = AppLocalizations.of(context);
      context.showSnackBar(
        message: localizations?.translate('agree_to_terms_error') ??
            'Please agree to the terms and conditions',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    // Check if Turnstile verification is completed
    final turnstileState =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.register));
    if (turnstileState is! TurnstileSuccess) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('security_verification_required') ??
            'Please complete the security verification',
      );
      return;
    }

    // Use the new register state notifier
    final authActions = ref.read(authActionsProvider);
    authActions.resetAllStates();

    await authActions.googleSignUp(
      idToken: idToken,
      countryCode: ref.read(selectedCountryProvider)?.code ?? '',
      role: UserRole.normalUser,
      referralCode: widget.referralCode,
      onSuccess: () {
        debugPrint('✅ SignUpPage: Registration successful callback triggered');
      },
      onError: (errorMessage) {
        debugPrint('❌ SignUpPage: Registration error callback: $errorMessage');
        authActions.resetAllStates();
      },
    );
  }
}
