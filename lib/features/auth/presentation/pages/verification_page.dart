import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../routing/routing.dart';
import '../providers/verification_provider.dart';
import '../providers/resend_timer_provider.dart';
import '../widgets/verification_code_input.dart';

class VerificationPage extends ConsumerStatefulWidget {
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
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start timer when page loads
      ref.read(resendTimerProvider.notifier).startTimer();

      if (widget.isSendCode) {
        ref
            .read(verificationNotifierProvider.notifier)
            .resendCode(email: widget.email);
      }
    });

    // Listen to state changes for navigation
    ref.listenManual<VerificationState>(verificationNotifierProvider,
        (previous, next) {
      if (next is VerificationSuccess) {
        // Show success message and navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.success,
          ),
        );
        if (widget.isFromForgotPassword) {
          context.goToResetPassword(email: widget.email);
          return;
        }
        GoRouterExtension(context).go('/auth/login');
      } else if (next is VerificationError) {
        // Show error message and clear code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        _clearCode();
      } else if (next is ResendCodeSuccess) {
        // Show success message for resend code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.success,
          ),
        );
        // Timer is restarted in _resendCode method
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final code = _controllers.map((controller) => controller.text).join();
      _verifyCode(code);
    }
  }

  void _verifyCode(String code) {
    if (widget.isFromForgotPassword) {
      ref
          .read(verificationNotifierProvider.notifier)
          .verifyCodeForForgotPassword(
            email: widget.email,
            code: code,
          );
    } else {
      ref.read(verificationNotifierProvider.notifier).verifyCode(
            email: widget.email,
            code: code,
          );
    }
  }

  void _resendCode() {
    final canResend = ref.read(canResendProvider);
    if (canResend && mounted) {
      if (widget.isFromForgotPassword) {
        ref
            .read(verificationNotifierProvider.notifier)
            .resendCodeForForgotPassword(email: widget.email);
      } else {
        ref.read(verificationNotifierProvider.notifier).resendCode(
              email: widget.email,
            );
      }
      // Restart timer after resending
      ref.read(resendTimerProvider.notifier).startTimer();
    }
  }

  void _clearCode() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final verificationState = ref.watch(verificationNotifierProvider);
    final canResend = ref.watch(canResendProvider);
    final countdown = ref.watch(countdownProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => GoRouterExtension(context).pop(),
        ),
        actions: const [
          LocaleSwitchWidget(),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: context.isMobile ? null : 400,
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? 24 : 32,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Header Icon
              Container(
                width: context.isMobile ? 70 : 80,
                height: context.isMobile ? 70 : 80,
                decoration: BoxDecoration(
                  color: context.primary.withAlpha(26), // 0.1 * 255 = 26
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: context.isMobile ? 35 : 40,
                  color: context.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              CommonText.headlineMedium(
                localizations?.translate('verify_email') ?? 'Verify Your Email',
                fontWeight: FontWeight.bold,
                color: context.onSurface,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              CommonText.bodyLarge(
                localizations?.translate('verification_description') ??
                    'We have sent a 4-digit verification code to',
                color: context.onSurface.withAlpha(179), // 0.7 * 255 = 179
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Email display
              CommonText.bodyLarge(
                widget.email,
                fontWeight: FontWeight.w600,
                color: context.primary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Verification Code Input
              VerificationCodeInput(
                controllers: _controllers,
                focusNodes: _focusNodes,
                onChanged: _onCodeChanged,
                enabled: verificationState is! VerificationLoading,
              ),

              const SizedBox(height: 24),

              // Loading indicator or error state
              if (verificationState is VerificationLoading)
                const CircularProgressIndicator()
              else if (verificationState is VerificationError)
                Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    CommonText.bodyMedium(
                      'Please try again',
                      color: colorScheme.error,
                    ),
                  ],
                ),

              const Spacer(),

              // Resend code section
              Column(
                children: [
                  CommonText.bodyMedium(
                    localizations?.translate('didnt_receive_code') ??
                        "Didn't receive the code?",
                    color: context.onSurface.withAlpha(179), // 0.7 * 255 = 179
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed:
                        (verificationState is VerificationLoading || !canResend)
                            ? null
                            : _resendCode,
                    child: CommonText.bodyMedium(
                      canResend
                          ? (localizations?.translate('resend_code') ??
                              'Resend Code')
                          : '${localizations?.translate('resend_in') ?? 'Resend in'} ${countdown}s',
                      color: canResend
                          ? context.primary
                          : context.onSurface.withAlpha(128), // 0.5 * 255 = 128
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
