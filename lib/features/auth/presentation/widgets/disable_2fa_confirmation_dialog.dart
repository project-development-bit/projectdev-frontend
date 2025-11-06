import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/common_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/disable_2fa_provider.dart';
import '../providers/check_2fa_status_provider.dart';

/// Confirmation dialog for disabling 2FA
///
/// Shows a warning message and requires user confirmation before disabling 2FA
class Disable2FAConfirmationDialog extends ConsumerWidget {
  const Disable2FAConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disable2FAState = ref.watch(disable2FAProvider);
    final localizations = AppLocalizations.of(context);

    // Listen to state changes and handle success/error
    ref.listen<Disable2FAState>(disable2FAProvider, (previous, next) {
      if (next is Disable2FASuccess) {
        // Close dialog on success
        Navigator.of(context).pop();
        
        // Refresh 2FA status
        ref.read(check2FAStatusProvider.notifier).check2FAStatus();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CommonText(
              next.response.message,
              color: Colors.white,
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next is Disable2FAError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CommonText(
              next.message,
              color: Colors.white,
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations?.translate('retry') ?? 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ref.read(disable2FAProvider.notifier).disable2FA();
              },
            ),
          ),
        );
      }
    });

    return AlertDialog(
      backgroundColor: AppColors.websiteCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText(
              localizations?.translate('disable_2fa_confirmation_title') ??
                  'Disable 2FA?',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            localizations?.translate('disable_2fa_warning_message') ??
                'Disabling two-factor authentication will make your account less secure. Are you sure you want to continue?',
            fontSize: 14,
            color: AppColors.websiteText,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CommonText(
                    localizations?.translate('disable_2fa_security_note') ??
                        'Your account will be protected only by your password.',
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          if (disable2FAState is Disable2FALoading) ...[
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    localizations?.translate('disabling_2fa') ??
                        'Disabling 2FA...',
                    fontSize: 12,
                    color: AppColors.websiteText,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: disable2FAState is Disable2FALoading
              ? null
              : () {
                  Navigator.of(context).pop();
                  ref.read(disable2FAProvider.notifier).reset();
                },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.websiteText,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: CommonText(
            localizations?.translate('cancel') ?? 'Cancel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.websiteText,
          ),
        ),
        // Disable button
        ElevatedButton(
          onPressed: disable2FAState is Disable2FALoading
              ? null
              : () {
                  ref.read(disable2FAProvider.notifier).disable2FA();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: CommonText(
            localizations?.translate('disable_2fa') ?? 'Disable 2FA',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Extension to show disable 2FA confirmation dialog
extension Disable2FADialogExtension on BuildContext {
  /// Show disable 2FA confirmation dialog
  void showDisable2FAConfirmationDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Disable2FAConfirmationDialog(),
    );
  }
}
