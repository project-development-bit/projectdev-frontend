import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/delete_account_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/verify_delete_account_dialog.dart';
import 'package:cointiply_app/routing/routing.dart';
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
          // Show success message for verification code sent
          context.showSuccessSnackBar(
            message: next.successMessage ??
                context.translate('verification_code_sent'),
          );

          // Close current dialog
          context.pop();

          // Show verification dialog with email
          if (next.email != null) {
            showVerifyDeleteAccountDialog(context, next.email!);
          }
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

  void _handleDeleteAccount() {
    final userId = ref.read(profileCurrentUserProvider)?.id;

    if (userId == null) {
      context.showSnackBar(
        message: context.translate('user_id_not_found'),
        backgroundColor: context.error,
        textColor: Colors.white,
      );
      return;
    }

    ref.read(deleteAccountNotifierProvider.notifier).deleteAccount(
          userId: userId.toString(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting = ref.watch(deleteAccountNotifierProvider).isDeleting;

    return DialogBgWidget(
      isOverlayLoading: isDeleting,
      dialogHeight: context.isDesktop
          ? 400
          : context.isTablet
              ? 450
              : context.screenHeight * 0.7,
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
                  color: Color(0xff0C0B38),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffD0302F)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppLocalImages.warning,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CommonText.bodyMedium(
                        context.translate("delete_account_warning"),
                        highlightColor: Color(0xffD0302F),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              context.isDesktop
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomUnderLineButtonWidget(
                            title: context.translate("cancel_delete"),
                            onTap: () => context.pop(),
                            fontSize: 14,
                            isDark: true,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomUnderLineButtonWidget(
                            title: context.translate("permanently_delete"),
                            onTap: _handleDeleteAccount,
                            fontSize: 14,
                            isRed: true,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CustomUnderLineButtonWidget(
                          title: context.translate("cancel_delete"),
                          onTap: () => context.pop(),
                          fontSize: 14,
                          isDark: true,
                          width: double.infinity,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 16),
                        CustomUnderLineButtonWidget(
                          title: context.translate("permanently_delete"),
                          onTap: _handleDeleteAccount,
                          fontSize: 14,
                          isRed: true,
                          width: double.infinity,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
