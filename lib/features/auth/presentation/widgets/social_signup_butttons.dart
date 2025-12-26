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
import 'package:gigafaucet/features/auth/presentation/providers/ip_country_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/login_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/selected_country_provider.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class SocialSignupButtons extends ConsumerStatefulWidget {
  const SocialSignupButtons({
    super.key,
    this.referralCode,
    required this.agreeToTerms,
  });
  final String? referralCode;
  final bool agreeToTerms;

  @override
  ConsumerState<SocialSignupButtons> createState() =>
      _SocialSignupButtonsState();
}

class _SocialSignupButtonsState extends ConsumerState<SocialSignupButtons> {
  @override
  initState() {
    super.initState();
    ref.listenManual<LoginState>(loginNotifierProvider, (previous, next) {
      if (!mounted) return;
      switch (next) {
        case LoginSuccess():
          _afterLoginSuccess();
          context.showSnackBar(
              message: 'Registration successful!',
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButtonWrapper(
          isMobile: false,
          child: CommonButton(
            text: 'Google',
            onPressed: () {
              _handleGoogleSignUp();
            },
            backgroundColor: Color(0xFF333333),
            icon: CommonImage(
              imageUrl: AppLocalImages.googleLogo,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            isOutlined: false,
            height: 56,
          ),
        ),
        SizedBox(
          width: 8,
          height: 8,
        ),
        _buildButtonWrapper(
          isMobile: false,
          child: CommonButton(
            text: 'Facebook',
            backgroundColor: Color(0xFF333333),
            onPressed: () {
              _handleFacebookLoginWithToken(ref, context);
            },
            icon: CommonImage(
              imageUrl: AppLocalImages.facebookLogo,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            isOutlined: false,
            height: 56,
          ),
        )
      ],
    );
  }

  void _afterLoginSuccess() {
    GoRouter.of(context).go(AppRoutes.home);
  }

  Future<void> _handleGoogleSignUp({String? accessToken}) async {
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
      accessToken: accessToken,
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

  void _handleFacebookLoginWithToken(WidgetRef ref, BuildContext context,
      {String? accessToken}) async {
    if (!widget.agreeToTerms) {
      final localizations = AppLocalizations.of(context);
      context.showSnackBar(
        message: localizations?.translate('agree_to_terms_error') ??
            'Please agree to the terms and conditions',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }
    // Check Turnstile verification
    final turnstileCanAttempt =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.register))
            is TurnstileSuccess;

    if (!turnstileCanAttempt) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('turnstile_required') ??
            'Please complete the security verification',
      );
      return;
    }

    // Get the Turnstile token
    final turnstileToken = turnstileCanAttempt
        ? (ref.read(turnstileNotifierProvider(TurnstileActionEnum.register))
                as TurnstileSuccess)
            .token
        : null;

    if (turnstileToken == null) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('turnstile_token_missing') ??
            'Security verification token is missing. Please try again.',
      );
      return;
    }

    // Use consolidated auth actions for login
    final authActions = ref.read(authActionsProvider);

    // Reset previous states
    authActions.resetAllStates();
    final ipState = ref.read(getIpCountryNotifierProvider);

    await authActions.facebookSignUp(
        accessToken: accessToken,
        referralCode: widget.referralCode,
        countryCode: ipState.country?.code ?? "Unknown",
        onSuccess: () async {
          _afterLoginSuccess();
        },
        onError: (v) {
          context.showSnackBar(
              message: v, backgroundColor: Theme.of(context).colorScheme.error);
        });
  }
}

Widget _buildButtonWrapper({
  required bool isMobile,
  required Widget child,
}) {
  if (isMobile) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }

  return Expanded(child: child);
}
