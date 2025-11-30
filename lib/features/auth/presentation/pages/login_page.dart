import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/common/widgets/custom_pointer_interceptor.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:cointiply_app/features/terms_privacy/presentation/services/terms_privacy_navigation_service.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_debug_provider.dart';
import '../../../../routing/app_router.dart';
import '../providers/login_provider.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/two_factor_login_verification_dialog.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();

    ref.listenManual<LoginState>(loginNotifierProvider, (previous, next) async {
      if (!mounted) return;

      // Debug logging
      final debugNotifier = ref.read(authDebugProvider.notifier);
      debugNotifier
          .logAuthState('LoginPage: state changed to ${next.runtimeType}');

      switch (next) {
        case LoginSuccess(:final loginResponse):
          // Check if user has 2FA enabled (userId is not null)
          if (loginResponse.userId != null) {
            debugPrint('🔐 2FA required for user: ${loginResponse.userId}');
            // Show 2FA verification dialog
            if (mounted) {
              final result = await context.show2FALoginVerificationDialog(
                userId: loginResponse.userId!,
                onSuccess: () {
                  // Navigate to home after successful 2FA verification
                  if (mounted) {
                    _afterLoginSuccess();
                  }
                },
              );

              // If user cancelled the dialog, reset login state
              if (result == false && mounted) {
                ref.read(loginNotifierProvider.notifier).reset();
              }
            }
          } else {
            // No 2FA required, proceed with normal login
            debugPrint('✅ No 2FA required, proceeding to home');
            // Add a small delay to ensure all async operations complete
            Future.delayed(const Duration(milliseconds: 100), () async {
              if (mounted) {
                // Use GoRouter.of(context).go() to replace the current route
                _afterLoginSuccess();
              }
            });
          }
          break;
        case LoginError():
          // Show error message
          _checkVerifyCode(next.errorModel, next.email);
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

  void _handleForgotPassword() {
    // Navigate to forgot password page
    context.goToForgotPassword();
  }

  void _handleSignUp() {
    // Navigate to sign up page
    context.goToSignUp();
  }

  @override
  Widget build(BuildContext context) {
    // Also watch the locale provider to force rebuilds when locale changes
    final currentLocale = ref.watch(localeProvider);
    final translate = ref.watch(translationProvider);

    debugPrint('LoginPage building with locale: ${currentLocale.languageCode}');
    debugPrint(
        'Testing direct translation for "welcome_back": ${translate('welcome_back')}');

    return OnboardingBackground(
      childPadding: EdgeInsets.symmetric(
          vertical: context.isMobile ? 30 : 34,
          horizontal: context.isMobile ? 16 : 43),
      girlHeight: 400,
      girlRightOffset: -150,
      girlBottomOffset: -110,
      child: Column(
        children: [
          LoginFormWidget(
            onLoginSuccess: () {},
            onForgotPassword: _handleForgotPassword,
            onSignUp: _handleSignUp,
            showSignUpLink: true,
            showRememberMe: true,
          ),
          SizedBox(height: 46),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => context.showPrivacy(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: CommonText.bodySmall(
                    translate('privacy_policy'),
                    color: context.primary,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              CommonText.bodySmall(
                '•',
                color: context.onSurfaceVariant,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => context.showTerms(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: CommonText.bodySmall(
                    translate('terms_of_service'),
                    color: context.primary,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              CommonText.bodySmall(
                '•',
                color: context.onSurfaceVariant,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () =>
                      GoRouter.of(context).push(AppRoutes.contactUs),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: CommonText.bodySmall(
                    translate('contact_us'),
                    color: context.primary,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _checkVerifyCode(ErrorModel? errorModel, String email) {
    /// If the error model indicates that email verification is required,
    /// show verification dialog
    if (errorModel?.isUnverifiedAccount == true) {
      _showVerificationDialog(email);
    }
  }

  void _showVerificationDialog(String email) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap verify or cancel
      builder: (BuildContext context) {
        return CustomPointerInterceptor(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: context.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CommonText.titleLarge(
                    localizations?.translate('verify_email') ??
                        'Verify Your Email',
                    fontWeight: FontWeight.bold,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyLarge(
                  localizations?.translate('verification_required_title') ??
                      'Account Verification Required',
                  fontWeight: FontWeight.w600,
                  color: context.onSurface,
                ),
                const SizedBox(height: 12),
                CommonText.bodyMedium(
                  localizations?.translate('verification_required_message') ??
                      'Your account needs to be verified before you can log in. We\'ll send a verification code to your email address.',
                  color: context.onSurface.withAlpha(179), // 0.7 opacity
                ),
                const SizedBox(height: 16),
                CommonContainer(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: context.primary.withAlpha(26), // 0.1 opacity
                  borderRadius: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonText.bodySmall(
                          email, // Use the actual email parameter instead of hardcoded text
                          fontWeight: FontWeight.w600,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              CommonButton(
                text: localizations?.translate('cancel') ?? 'Cancel',
                onPressed: () => GoRouter.of(context).pop(),
                isOutlined: true,
                backgroundColor: AppColors.transparent,
                textColor: context.onSurface,
              ),
              const SizedBox(width: 8),
              CommonButton(
                text: localizations?.translate('verify_now') ?? 'Verify Now',
                onPressed: () {
                  GoRouter.of(context).pop();
                  // Navigate to verification page
                  context.pushToVerification(
                    email: email,
                    isSendCode: true,
                    isFromForgotPassword: false,
                  );
                },
                backgroundColor: context.primary,
                textColor: context.onPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}
