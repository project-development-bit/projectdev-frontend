import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/config/flavor_manager.dart';
import '../providers/verify_login_2fa_provider.dart';

/// 2FA Login Verification Dialog
///
/// Beautiful dialog that prompts users with 2FA enabled to enter
/// their authenticator code during login
class TwoFactorLoginVerificationDialog extends ConsumerStatefulWidget {
  final int userId;
  final VoidCallback? onSuccess;

  const TwoFactorLoginVerificationDialog({
    super.key,
    required this.userId,
    this.onSuccess,
  });

  @override
  ConsumerState<TwoFactorLoginVerificationDialog> createState() =>
      _TwoFactorLoginVerificationDialogState();
}

class _TwoFactorLoginVerificationDialogState
    extends ConsumerState<TwoFactorLoginVerificationDialog> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Auto-focus the input field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });

    // Listen to verification state changes
    ref.listenManual<VerifyLogin2FAState>(verifyLogin2FAProvider,
        (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case VerifyLogin2FASuccess(:final response):
          // Store tokens
          if (response.data != null) {
            final secureStorage = ref.read(secureStorageServiceProvider);
            await secureStorage
                .saveAuthToken(response.data!.tokens.accessToken);
            await secureStorage
                .saveRefreshToken(response.data!.tokens.refreshToken);
            await secureStorage.saveUserId(response.data!.user.id.toString());

            // Show success message
            if (mounted) {
              context.showSuccessSnackBar(
                message: response.message,
              );

              // Close dialog
              context.pop(true);

              // Call success callback
              widget.onSuccess?.call();
            }
          }
          break;
        case VerifyLogin2FAError(:final message):
          // Show error message under text field
          if (mounted) {
            setState(() {
              _errorText = message;
            });
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

  void _handleVerify() {
    // Clear previous error
    setState(() {
      _errorText = null;
    });

    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorText = context.translate('2fa_code_required');
      });
      return;
    }

    if (code.length != 6) {
      setState(() {
        _errorText = context.translate('2fa_code_must_be_6_digits');
      });
      return;
    }

    ref
        .read(verifyLogin2FAProvider.notifier)
        .verifyLogin2FA(token: code, userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final verifyLogin2FAState = ref.watch(verifyLogin2FAProvider);
    final localizations = AppLocalizations.of(context);
    final isLoading = verifyLogin2FAState is VerifyLogin2FALoading;
    final appName = FlavorManager.appName;

    final colorScheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        backgroundColor: context.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(32),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo/Name
              CommonText(
                appName.toUpperCase(),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Title
              CommonText(
                localizations?.translate('2fa_login_verification_title') ??
                    'Authentication Required',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: context.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              CommonText(
                localizations?.translate('2fa_unknown_device_subtitle') ??
                    'We noticed you are logging in from an unknown device.',
                fontSize: 14,
                color: context.onSurface.withValues(alpha: 0.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Instruction
              CommonText(
                localizations?.translate('2fa_login_verification_subtitle') ??
                    'Please enter the security code from your authenticator app.',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Code Input Field
              CommonTextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: context.onSurface,
                ),
                hintText: 'XXXXXX',
                hintStyle: TextStyle(
                  color: context.onSurface.withValues(alpha: 0.3),
                  letterSpacing: 8,
                ),
                fillColor: context.surfaceContainerHighest,
                filled: true,
                borderRadius: 8,
                borderColor:
                    _errorText != null ? AppColors.error : context.outline,
                borderWidth: 1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        _errorText != null ? AppColors.error : context.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        _errorText != null ? AppColors.error : context.primary,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onSubmitted: isLoading ? null : (_) => _handleVerify(),
                onChanged: (_) {
                  // Clear error when user starts typing
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
              ),

              // Error Text
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                CommonText(
                  _errorText!,
                  fontSize: 14,
                  color: AppColors.error,
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                        colorScheme.error.withValues(alpha: 0.5),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onError),
                          ),
                        )
                      : CommonText(
                          localizations?.translate('continue') ?? 'Continue',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onError,
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Support Link
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: context.onSurface.withValues(alpha: 0.6),
                  ),
                  children: [
                    TextSpan(
                      text: localizations?.translate('2fa_support_text') ??
                          'If you do not have your security code, please ',
                    ),
                    TextSpan(
                      text: localizations?.translate('contact_support') ??
                          'contact support',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Security Icon
              Icon(
                Icons.lock_outline,
                size: 80,
                color: context.onSurface.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to show 2FA login verification dialog
extension TwoFactorLoginDialogExtension on BuildContext {
  /// Show 2FA login verification dialog
  Future<bool?> show2FALoginVerificationDialog({
    required int userId,
    VoidCallback? onSuccess,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: false,
      builder: (context) => CustomPointerInterceptor(
        child: TwoFactorLoginVerificationDialog(
          userId: userId,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}
