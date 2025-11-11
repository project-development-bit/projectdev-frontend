import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/verify_2fa_provider.dart';

class TwoFactorAuthPage extends ConsumerStatefulWidget {
  const TwoFactorAuthPage({
    super.key,
    required this.email,
    this.sessionToken,
  });

  final String email;
  final String? sessionToken;

  @override
  ConsumerState<TwoFactorAuthPage> createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends ConsumerState<TwoFactorAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen to 2FA verification state changes
    ref.listenManual<Verify2FAState>(verify2FANotifierProvider,
        (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case Verify2FASuccess():
          // Navigate to home on successful 2FA verification
          context.showSuccessSnackBar(
            message: next.message,
          );

          // Small delay for smooth transition
          await Future.delayed(const Duration(milliseconds: 300));

          if (mounted) {
            context.goToHome();
          }
          break;
        case Verify2FAError():
          // Show error message
          context.showErrorSnackBar(
            message: next.message,
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the 6-digit code';
    }
    if (value.length != 6) {
      return 'Code must be exactly 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code must contain only numbers';
    }
    return null;
  }

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final verify2FANotifier = ref.read(verify2FANotifierProvider.notifier);

    await verify2FANotifier.verify2FA(
      email: widget.email,
      twoFactorCode: _codeController.text.trim(),
      sessionToken: widget.sessionToken,
      onSuccess: () {
        debugPrint('✅ 2FA verification successful');
      },
      onError: (errorMessage) {
        debugPrint('❌ 2FA verification error: $errorMessage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final isLoading = ref.watch(is2FALoadingProvider);

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
            maxWidth: context.isMobile ? null : 450,
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 24 : 40,
              vertical: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  CommonText.headlineMedium(
                    localizations?.translate('authentication_required') ??
                        'Authentication Required',
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  CommonText.bodyLarge(
                    localizations?.translate('2fa_unknown_device_subtitle') ??
                        'We noticed you are logging in from an unknown device.',
                    color: colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Instructions
                  CommonText.bodyMedium(
                    localizations?.translate('2fa_instruction') ??
                        'Please enter the security code from your authenticator app.',
                    color: colorScheme.onSurface,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 32),

                  // 6-digit code input field
                  TextFormField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      hintText: '● ● ● ● ● ●',
                      hintStyle: TextStyle(
                        letterSpacing: 24,
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        fontSize: 28,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.error,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                    ),
                    validator: _validateCode,
                    onFieldSubmitted: (_) => _handleVerify(),
                    onChanged: (value) {
                      // Auto-submit when 6 digits are entered
                      if (value.length == 6 && !isLoading) {
                        _handleVerify();
                      }
                    },
                  ),

                  const SizedBox(height: 40),

                  // Continue Button
                  CommonButton(
                    text: localizations?.translate('continue') ?? 'Continue',
                    onPressed: isLoading ? null : _handleVerify,
                    isLoading: isLoading,
                    height: 56,
                    backgroundColor: colorScheme.error,
                    textColor: colorScheme.onError,
                    borderRadius: 12,
                  ),

                  const SizedBox(height: 32),

                  // Lock illustration/icon
                  Center(
                    child: Container(
                      width: context.isMobile ? 120 : 140,
                      height: context.isMobile ? 120 : 140,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Icon(
                        Icons.lock_outlined,
                        size: context.isMobile ? 60 : 70,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Support text
                  CommonText.bodySmall(
                    localizations?.translate('2fa_support_text') ??
                        'If you do not have your security code, please ',
                    color: colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  // Contact support link
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to support or open support URL
                      context.showSuccessSnackBar(
                        message:
                            'Please contact support at support@example.com',
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: CommonText.bodySmall(
                      localizations?.translate('contact_support') ??
                          'contact support',
                      color: colorScheme.error, // Red color
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
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
}
