import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/cloudflare_turnstille_widgte.dart';
import '../../../../core/providers/turnstile_provider.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/forgot_password_provider.dart';
import '../../../../routing/app_router.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _handleSendResetEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if Turnstile verification is completed
    final turnstileState = ref.read(turnstileNotifierProvider);
    if (turnstileState is! TurnstileSuccess) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('security_verification_required') ??
            'Please complete the security verification',
      );
      return;
    }

    ref
        .read(forgotPasswordProvider.notifier)
        .forgotPassword(_emailController.text.trim(), turnstileState.token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final forgotPasswordState = ref.watch(forgotPasswordProvider);

    // Listen to state changes for showing messages and navigation
    ref.listen<ForgotPasswordState>(forgotPasswordProvider, (previous, next) {
      if (next is ForgotPasswordSuccess) {
        // Navigate to verification screen with email
        context.goToVerification(
          email: _emailController.text.trim(),
          isSendCode: false,
          isFromForgotPassword: true,
        );

        // Show success snackbar
        context.showSuccessSnackBar(
          message: next.response.message,
        );
      } else if (next is ForgotPasswordError) {
        _showErrorSnackBar(
            context, next.message, localizations, colorScheme.onError);
      }
    });

    final isLoading = forgotPasswordState is ForgotPasswordLoading;
    final emailSent = forgotPasswordState is ForgotPasswordSuccess;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.goToLogin(),
        ),
        actions: [
          const CompactLocaleSwitcher(),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: context.isMobile ? null : 400,
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 24 : 32,
              vertical: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Icon
                  Center(
                    child: Container(
                      width: context.isMobile ? 90 : 100,
                      height: context.isMobile ? 90 : 100,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(25),
                        borderRadius:
                            BorderRadius.circular(context.isMobile ? 45 : 50),
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: context.isMobile ? 45 : 50,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  CommonText.headlineMedium(
                    localizations?.translate('forgot_password') ??
                        'Forgot Password?',
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  CommonText.bodyLarge(
                    emailSent
                        ? (localizations
                                ?.translate('forgot_password_subtitle_sent') ??
                            'We have sent a password reset link to your email address. Please check your inbox and follow the instructions.')
                        : (localizations
                                ?.translate('forgot_password_subtitle') ??
                            'Enter your email address and we\'ll send you a link to reset your password.'),
                    color: colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  if (!emailSent) ...[
                    // Email Field
                    CommonTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      hintText: localizations?.translate('email_hint') ??
                          'Enter your email',
                      labelText: localizations?.translate('email') ?? 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) =>
                          TextFieldValidators.email(value, context),
                      onSubmitted: (_) => _handleSendResetEmail(),
                    ),

                    const SizedBox(height: 24),

                    // Cloudflare Turnstile Widget (replaces reCAPTCHA)
                    const CloudflareTurnstileWidget(),

                    const SizedBox(height: 32),

                    // Send Reset Email Button
                    CommonButton(
                      text: localizations?.translate('send_reset_email') ??
                          'Send Reset Email',
                      onPressed: isLoading ? null : _handleSendResetEmail,
                      isLoading: isLoading,
                      height: 56,
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                      borderRadius: 12,
                    ),
                  ] else ...[
                    // Email sent success state
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withAlpha(75),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 48,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: 16),
                          CommonText.titleLarge(
                            localizations?.translate('email_sent') ??
                                'Email Sent!',
                            color: AppColors.success.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          CommonText.bodyMedium(
                            localizations?.translate('check_email_for_reset') ??
                                'Check your email for the reset link',
                            color: AppColors.success.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Resend Button
                    CommonButton(
                      text: localizations?.translate('resend_email') ??
                          'Resend Email',
                      onPressed: () {
                        ref.read(forgotPasswordProvider.notifier).reset();
                      },
                      isOutlined: true,
                      height: 56,
                      backgroundColor: colorScheme.primary,
                      borderRadius: 12,
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Back to Login Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      CommonText.bodyMedium(
                        localizations?.translate('remember_password') ??
                            'Remember your password? ',
                        color: colorScheme.onSurfaceVariant,
                      ),
                      TextButton(
                        onPressed: () => context.goToLogin(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: CommonText.bodyMedium(
                          localizations?.translate('sign_in') ?? 'Sign In',
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(
      BuildContext context, String message, localizations, Color textColor) {
    context.showErrorSnackBar(
      message: message,
      action: SnackBarAction(
        label: localizations?.translate('dismiss') ?? 'Dismiss',
        textColor: textColor,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
