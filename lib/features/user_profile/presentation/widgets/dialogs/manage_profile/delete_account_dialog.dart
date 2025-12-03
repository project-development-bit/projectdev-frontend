import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/delete_account_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showDeleteAccountConfirmationDialog(BuildContext context) {
  context.showManagePopup(
    // height: context.isMobile ? 500 : 450,
    child: const DeleteAccountConfirmationDialog(),
    barrierDismissible: true,
    // title: context.translate("delete_account_confirmation_title"),
  );
}

class DeleteAccountConfirmationDialog extends ConsumerStatefulWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  ConsumerState<DeleteAccountConfirmationDialog> createState() =>
      _DeleteAccountConfirmationDialogState();
}

class _DeleteAccountConfirmationDialogState
    extends ConsumerState<DeleteAccountConfirmationDialog> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(deleteAccountNotifierProvider, (previous, next) {
      if (next.isDeleting) return;
      
      if (next.status == DeleteAccountStatus.success) {
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: next.successMessage ?? 
                context.translate('account_deleted_successfully'),
            backgroundColor: context.primary,
            textColor: Colors.white,
          );
          
          // Close dialog
          context.pop();
          
          // Clear all data and logout
          _handleLogoutAfterDeletion();
        }
      } else if (next.status == DeleteAccountStatus.failure) {
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: next.errorMessage ??
                context.translate('failed_to_delete_account'),
            backgroundColor: context.error,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  Future<void> _handleLogoutAfterDeletion() async {
    try {
      // Clear secure storage
      final secureStorage = ref.read(secureStorageServiceProvider);
      await secureStorage.clearRememberMeCredentials();
      await secureStorage.deleteAuthToken();
      await secureStorage.deleteRefreshToken();
      
      // Navigate to login page
      if (mounted && context.mounted) {
        context.go('/');
      }
    } catch (e) {
      debugPrint('Error during logout after account deletion: $e');
    }
  }

  void _handleDeleteAccount() {
    final userId = ref.read(profileCurrentUserProvider)?.id;
    
    if (userId == null) {
      context.showSnackBar(
        message: 'User ID not found',
        backgroundColor: context.error,
        textColor: Colors.white,
      );
      return;
    }

    ref.read(deleteAccountNotifierProvider.notifier).deleteAccount(
      userId:userId.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting = ref.watch(deleteAccountNotifierProvider).isDeleting;
    
    return DialogBgWidget(
      dialogHeight: context.isDesktop
          ? 400
          : context.isTablet
              ? 380
              : 420,
      title: context.translate("delete_account_confirmation_title"),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.isMobile || context.isTablet
              ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
              : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning message
              CommonText.bodyLarge(
                context.translate("delete_account_confirmation_message"),
                color: context.onSurface,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),

              // Additional warning
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: context.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CommonText.bodyMedium(
                        context.translate("delete_account_warning"),
                        color: context.error,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: context.translate("cancel_delete"),
                      onPressed: isDeleting ? null : () => context.pop(),
                      backgroundColor: context.surfaceContainer,
                      textColor: context.onSurface,
                      isOutlined: true,
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CommonButton(
                      text: context.translate("permanently_delete"),
                      onPressed: isDeleting ? null : _handleDeleteAccount,
                      backgroundColor: context.error,
                      textColor: Colors.white,
                      height: 48,
                      isLoading: isDeleting,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
