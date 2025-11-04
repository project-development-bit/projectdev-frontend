import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/verify_2fa_provider.dart';

/// Two-Factor Authentication Dialog
/// A popup dialog for entering 6-digit 2FA code from authenticator app
class TwoFactorAuthDialog extends ConsumerStatefulWidget {
  const TwoFactorAuthDialog({
    super.key,
    required this.email,
    this.sessionToken,
    this.onSuccess,
  });

  final String email;
  final String? sessionToken;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<TwoFactorAuthDialog> createState() =>
      _TwoFactorAuthDialogState();
}

class _TwoFactorAuthDialogState extends ConsumerState<TwoFactorAuthDialog> {
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
          // Show success message
          if (mounted) {
            context.showSuccessSnackBar(
              message: next.message,
            );

            // Close dialog
            Navigator.of(context).pop(true);

            // Call success callback
            widget.onSuccess?.call();
          }
          break;
        case Verify2FAError():
          // Show error message
          if (mounted) {
            context.showErrorSnackBar(
              message: next.message,
            );
          }
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
        debugPrint('✅ 2FA verification successful in dialog');
      },
      onError: (errorMessage) {
        debugPrint('❌ 2FA verification error in dialog: $errorMessage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final isLoading = ref.watch(is2FALoadingProvider);
    final isMobile = context.isMobile;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 500,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Lock icon
                  Center(
                    child: Container(
                      width: isMobile ? 80 : 100,
                      height: isMobile ? 80 : 100,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.lock_outlined,
                        size: isMobile ? 40 : 50,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  CommonText.headlineSmall(
                    localizations?.translate('authentication_required') ??
                        'Authentication Required',
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  CommonText.bodyMedium(
                    localizations?.translate('2fa_unknown_device_subtitle') ??
                        'We noticed you are logging in from an unknown device.',
                    color: colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Instructions
                  CommonText.bodySmall(
                    localizations?.translate('2fa_instruction') ??
                        'Please enter the security code from your authenticator app.',
                    color: colorScheme.onSurface,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 24),

                  // 6-digit code input field
                  TextFormField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
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
                        color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                        fontSize: 24,
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
                        horizontal: 16,
                        vertical: 16,
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

                  const SizedBox(height: 32),

                  // Continue Button
                  CommonButton(
                    text: localizations?.translate('continue') ?? 'Continue',
                    onPressed: isLoading ? null : _handleVerify,
                    isLoading: isLoading,
                    height: 52,
                    backgroundColor:
                        const Color(0xFFE53945), // Red color as requested
                    textColor: Colors.white,
                    borderRadius: 12,
                  ),

                  const SizedBox(height: 20),

                  // Support text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText.bodySmall(
                        localizations?.translate('2fa_support_text') ??
                            'If you do not have your security code, please ',
                        color: colorScheme.onSurfaceVariant,
                        textAlign: TextAlign.center,
                      ),
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
                          color: const Color(0xFFE53945), // Red color
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show 2FA dialog
Future<bool?> show2FADialog(
  BuildContext context, {
  required String email,
  String? sessionToken,
  VoidCallback? onSuccess,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => TwoFactorAuthDialog(
      email: email,
      sessionToken: sessionToken,
      onSuccess: onSuccess,
    ),
  );
}
