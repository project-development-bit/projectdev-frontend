import 'package:cointiply_app/core/error/error_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_container.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/translation_provider.dart';
import '../../../../core/providers/auth_debug_provider.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/widgets/theme_switch_widget.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../routing/app_router.dart';
import '../../../terms_privacy/presentation/services/terms_privacy_navigation_service.dart';
import '../providers/login_provider.dart';
import '../widgets/login_form_widget.dart';

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
        case LoginSuccess():
          // Add a small delay to ensure all async operations complete
          Future.delayed(const Duration(milliseconds: 100), () async {
            if (mounted) {
              // Use GoRouter.of(context).go() to replace the current route
              GoRouter.of(context).go(AppRoutes.home);
            }
          });
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

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main login content
            SingleChildScrollView(
              child: Center(
                child: ResponsiveContainer(
                  maxWidth: context.isMobile ? null : 400,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.isMobile ? 24 : 32,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                  
                      // App Logo/Icon
                      Center(
                        child: CommonContainer(
                          width: context.isMobile ? 100 : 120,
                          height: context.isMobile ? 100 : 120,
                          backgroundColor: context.primary.withAlpha(25),
                          borderRadius: context.isMobile ? 50 : 60,
                          child: Icon(
                            Icons.fastfood_rounded,
                            size: context.isMobile ? 56 : 64,
                            color: context.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Welcome Text - Testing direct translation provider
                      CommonText.headlineMedium(
                        translate('welcome_back'),
                        fontWeight: FontWeight.bold,
                        color: context.onSurface,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      CommonText.bodyLarge(
                        translate('sign_in_subtitle'),
                        color: context.onSurfaceVariant,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Login Form Widget
                      LoginFormWidget(
                        onLoginSuccess: () {
                          // Navigation is handled in the login listener above
                        },
                        onForgotPassword: _handleForgotPassword,
                        onSignUp: _handleSignUp,
                        showSignUpLink: true,
                        showRememberMe: true,
                      ),

                      const SizedBox(height: 32),

                      // Legal Links Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.showPrivacy(ref),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                              onPressed: () => context.showTerms(ref),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                              onPressed: () => GoRouter.of(context)
                                  .push(AppRoutes.contactUs),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                ),
              ),
            ),

            // Locale and theme switch widgets positioned at top-right
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeSwitchWidget(),
                  const SizedBox(width: 8),
                  const LocaleSwitchWidget(),
                ],
              ),
            ),
          ],
        ),
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
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
              isOutlined: true,
              backgroundColor: Colors.transparent,
              textColor: context.onSurface,
            ),
            const SizedBox(width: 8),
            CommonButton(
              text: localizations?.translate('verify_now') ?? 'Verify Now',
              onPressed: () {
                Navigator.of(context).pop();
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
        );
      },
    );
  }
}
