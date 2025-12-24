import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_button.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/core/providers/consolidated_auth_provider.dart';
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/ip_country_provider.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({
    super.key,
    this.onLoginSuccess,
  });
  final VoidCallback? onLoginSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButtonWrapper(
          isMobile: false,
          child: CommonButton(
            text: 'Google',
            backgroundColor: Color(0xFF333333),
            onPressed: () {
              _handleGoogleLoginWithToken(ref, context);
            },
            icon: CommonImage(
              imageUrl: AppLocalImages.googleLogo,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            isOutlined: false, fontSize: 14,
            // textColor: ,
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

            // textColor: Color(0xFF333333),
            height: 56,
          ),
        )
      ],
    );
  }

  void _handleGoogleLoginWithToken(WidgetRef ref, BuildContext context,
      {String? idToken}) async {
    // Check Turnstile verification
    final turnstileCanAttempt =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
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
        ? (ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
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

    await authActions.googleLogin(
        idToken: idToken,
        countryCode: ipState.country?.code ?? "Unknown",
        onSuccess: () async {
          onLoginSuccess?.call();
        },
        onError: (v) {
          context.showSnackBar(
              message: v, backgroundColor: Theme.of(context).colorScheme.error);
        });
  }

  void _handleFacebookLoginWithToken(WidgetRef ref, BuildContext context,
      {String? accessToken}) async {
    // Check Turnstile verification
    final turnstileCanAttempt =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
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
        ? (ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
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

    await authActions.facebookSignIn(
        accessToken: accessToken,
        countryCode: ipState.country?.code ?? "Unknown",
        onSuccess: () async {
          onLoginSuccess?.call();
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
