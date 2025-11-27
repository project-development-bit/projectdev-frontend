import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../../routing/routing.dart';
import '../providers/verification_provider.dart';
import '../providers/resend_timer_provider.dart';

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
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(resendTimerProvider.notifier).startTimer();

      if (widget.isSendCode) {
        ref.read(verificationNotifierProvider.notifier).resendCode(
              email: widget.email,
            );
      }
    });

    ref.listenManual<VerificationState>(
      verificationNotifierProvider,
      (previous, next) {
        if (next is VerificationSuccess) {
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
        }

        if (next is VerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          _pinController.clear();
        }

        if (next is ResendCodeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verifyCode(String code) {
    if (widget.isFromForgotPassword) {
      ref
          .read(verificationNotifierProvider.notifier)
          .verifyCodeForForgotPassword(email: widget.email, code: code);
    } else {
      ref
          .read(verificationNotifierProvider.notifier)
          .verifyCode(email: widget.email, code: code);
    }
  }

  void _resendCode() {
    final canResend = ref.read(canResendProvider);

    if (!canResend) return;

    if (widget.isFromForgotPassword) {
      ref
          .read(verificationNotifierProvider.notifier)
          .resendCodeForForgotPassword(email: widget.email);
    } else {
      ref
          .read(verificationNotifierProvider.notifier)
          .resendCode(email: widget.email);
    }

    ref.read(resendTimerProvider.notifier).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final verificationState = ref.watch(verificationNotifierProvider);
    final canResend = ref.watch(canResendProvider);
    final countdown = ref.watch(countdownProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final isLoading = verificationState is VerificationLoading;

    // === PIN THEME ============================================================
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.outline.withAlpha(200),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
      color: Theme.of(context).colorScheme.surface,
    );

    final disabledPinTheme = defaultPinTheme.copyDecorationWith(
      color: colorScheme.surface.withAlpha(128),
    );

    return OnboardingBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 23.5),

          // Icon
          Container(
            width: context.isMobile ? 70 : 80,
            height: context.isMobile ? 70 : 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.email_outlined,
              size: context.isMobile ? 35 : 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          CommonText.headlineMedium(
            localizations?.translate('verify_email') ?? 'Verify Your Email',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          CommonText.bodyLarge(
            localizations?.translate('verification_description') ??
                'We have sent a 4-digit verification code to',
            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Email text
          CommonText.bodyLarge(
            widget.email,
            fontWeight: FontWeight.w600,
            color: context.primary,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // === PIN INPUT ====================================================
          Pinput(
            controller: _pinController,
            enabled: !isLoading,
            length: 4,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            disabledPinTheme: disabledPinTheme,
            onCompleted: (value) => _verifyCode(value),
          ),
          // ==================================================================

          const SizedBox(height: 24),

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

          // const Spacer(),

          // Resend text
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
    );

    // ==========================================================================

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: AppColors.transparent,
    //     elevation: 0,
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back,
    //           color: Theme.of(context).colorScheme.onSurface),
    //       onPressed: () => GoRouterExtension(context).pop(),
    //     ),
    //     actions: const [
    //       LocaleSwitchWidget(),
    //       SizedBox(width: 16),
    //     ],
    //   ),
    //   body: SafeArea(
    //     child: ResponsiveContainer(
    //       maxWidth: context.isMobile ? null : 400,
    //       padding: EdgeInsets.symmetric(
    //         horizontal: context.isMobile ? 24 : 32,
    //         vertical: 24,
    //       ),
    //       child:
    //     ),
    //   ),
    // );
  }
}
