import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/delete_account_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/manage_profile/verify_delete_account_dialog.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showDeleteAccountConfirmationDialog(BuildContext context) {
  context.showManagePopup(
    height: context.isMobile ? context.screenHeight * 0.8 : 400,
    child: const DeleteAccountConfirmationDialog(),
    barrierDismissible: true,
    title: context.translate("delete_account_confirmation_title"),
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
          // Get email and verification code from response
          final currentUser = ref.read(profileCurrentUserProvider);
          final email = currentUser?.email ?? '';

          // Show success message that code was sent
          context.showSnackBar(
            message: next.successMessage ??
                context.translate('verification_code_sent'),
            backgroundColor: context.primary,
            textColor: Colors.white,
          );

          // Close current dialog
          context.pop();

          // Show verification dialog
          showVerifyDeleteAccountDialog(
            context,
            email,
          );
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


  void _handleDeleteAccount() async {
    

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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
                border: Border.all(
                  color: Color(0xffD0302F),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/warning_icon.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CommonText.bodyMedium(
                      context.translate("delete_account_warning"),
                      color: Color(0xff98989A),
                      highlightColor: Color(0xffD0302F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            context.isMobile
                ? Column(
                    spacing: 12,
                    children: [
                      CustomUnderLineButtonWidget(
                        width: double.infinity,
                        title: context.translate("permanently_delete"),
                        onTap: isDeleting ? () {} : _handleDeleteAccount,
                        isLoading: isDeleting,
                        fontColor: Colors.white,
                        isRed: true,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomUnderLineButtonWidget(
                        width: double.infinity,
                        title: context.translate("cancel_delete"),
                        onTap: isDeleting ? () {} : () => context.pop(),
                        fontColor: Colors.white,
                        isDark: true,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomUnderLineButtonWidget(
                            title: context.translate("cancel_delete"),
                            onTap: isDeleting ? () {} : () => context.pop(),
                            fontColor: Colors.white,
                            isDark: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomUnderLineButtonWidget(
                            title: context.translate("permanently_delete"),
                            onTap: isDeleting ? () {} : _handleDeleteAccount,
                            isLoading: isDeleting,
                            fontColor: Colors.white,
                            isRed: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
