import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/common_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/secure_storage_service.dart';
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
              Navigator.of(context).pop(true);

              // Call success callback
              widget.onSuccess?.call();
            }
          }
          break;
        case VerifyLogin2FAError(:final message):
          // Show error message
          if (mounted) {
            context.showErrorSnackBar(message: message);
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
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      context.showErrorSnackBar(
        message: context.translate('2fa_code_required'),
      );
      return;
    }

    if (code.length != 6) {
      context.showErrorSnackBar(
        message: context.translate('2fa_code_must_be_6_digits'),
      );
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

    return PopScope(
      canPop: !isLoading,
      child: AlertDialog(
        backgroundColor: AppColors.websiteCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(32),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Security Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              CommonText(
                localizations?.translate('2fa_login_verification_title') ??
                    'Two-Factor Authentication',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              CommonText(
                localizations?.translate('2fa_login_verification_subtitle') ??
                    'Enter the 6-digit code from your authenticator app to complete your login.',
                fontSize: 14,
                color: AppColors.websiteText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Code Input Field
              TextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                  color: Colors.white,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '000000',
                  hintStyle: TextStyle(
                    color: AppColors.websiteText.withValues(alpha: 0.3),
                    letterSpacing: 12,
                  ),
                  filled: true,
                  fillColor: AppColors.websiteBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onSubmitted: isLoading ? null : (_) => _handleVerify(),
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CommonText(
                        localizations?.translate('2fa_login_info') ??
                            'Open your authenticator app to get the code.',
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.websiteGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : CommonText(
                          localizations?.translate('verify') ?? 'Verify',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop(false);
                        ref.read(verifyLogin2FAProvider.notifier).reset();
                      },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.websiteText,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: CommonText(
                  localizations?.translate('cancel') ?? 'Cancel',
                  fontSize: 14,
                  color: AppColors.websiteText,
                ),
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
