import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/verify_delete_account_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:cointiply_app/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

void showVerifyDeleteAccountDialog(BuildContext context, String email) {
  context.showManagePopup(
    child: VerifyDeleteAccountDialog(email: email),
    barrierDismissible: false,
  );
}

class VerifyDeleteAccountDialog extends ConsumerStatefulWidget {
  final String email;

  const VerifyDeleteAccountDialog({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyDeleteAccountDialog> createState() =>
      _VerifyDeleteAccountDialogState();
}

class _VerifyDeleteAccountDialogState
    extends ConsumerState<VerifyDeleteAccountDialog> {
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();

    // Listen to verification state changes
    ref.listenManual(verifyDeleteAccountNotifierProvider, (previous, next) {
      if (next.isVerifying) return;

      if (next.status == VerifyDeleteAccountStatus.success) {
        if (mounted && context.mounted) {
          // Show success message using localized string
          context.showSnackBar(
            message: context.translate('account_deleted_successfully'),
            backgroundColor: context.primary,
            textColor: Colors.white,
          );

          // Close dialog
          context.pop();

          // Clear all data and logout
          _handleLogoutAfterDeletion();
        }
      } else if (next.status == VerifyDeleteAccountStatus.failure) {
        if (mounted && context.mounted) {
          // Show error message from server
          context.showSnackBar(
            message: next.errorMessage ??
                context.translate('failed_to_delete_account'),
            backgroundColor: context.error,
            textColor: Colors.white,
          );
          // Clear the PIN input
          _pinController.clear();
        }
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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

  void _verifyCode(String code) {
    ref
        .read(verifyDeleteAccountNotifierProvider.notifier)
        .verifyDeleteAccount(code: code);
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(verifyDeleteAccountNotifierProvider);
    final isLoading = verificationState.isVerifying;
    final colorScheme = Theme.of(context).colorScheme;

    // PIN Theme
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onPrimary.withValues(alpha: 0.5),
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

    return DialogBgWidget(
      title: context.translate('delete_confirmation'),
      dialogHeight: context.isDesktop
          ? 600
          : context.isTablet
              ? 550
              : context.screenHeight * 0.8,
      body: SingleChildScrollView(
        padding: context.isMobile || context.isTablet
            ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
            : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            CommonText.bodyLarge(
                context.translate("delete_confirmation_description")),

            const SizedBox(height: 16),

            // Title
            Container(
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Color(0xff333333), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CommonText.bodyLarge(
                widget.email,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // Description
            CommonText.bodyLarge(
              context.translate('verification_code'),
              color: Colors.white,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            CommonTextField(
              controller: _pinController,
              enabled: !isLoading,
              maxLength: 4,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: Colors.white,
                fontSize: 24
              ),
              hintText: context.translate('Enter Code'),
              textAlign: TextAlign.center,
              hintStyle: context.textTheme.bodyLarge?.copyWith(
                color: Color(0xff98989A),
                  fontWeight: FontWeight.w700, fontSize: 24),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),

            const SizedBox(height: 24),

            // Loading or Error State
            if (isLoading)
              const CircularProgressIndicator()
            else if (verificationState.hasError)
              Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  CommonText.bodyMedium(
                    context.translate('please_try_again'),
                    color: colorScheme.error,
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Warning text
            CommonText.bodyLarge(
              context.translate('code_expires_in_30_minutes'),
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 38),

            // Cancel Button
            context.isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16.0,
                    children: [
                      Flexible(
                        child: CustomUnderLineButtonWidget(
                          title: context.translate('cancel'),
                          onTap: () => context.pop(),
                          isDark: true,
                          fontSize: 14,
                          width: double.infinity,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Flexible(
                        child: CustomUnderLineButtonWidget(
                          title: context.translate('confirm'),
                          onTap: () => context.pop(),
                          width: double.infinity,
                          isRed: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center ,
                  spacing: 16.0,
                    children: [
                      CustomUnderLineButtonWidget(
                        title: context.translate('cancel'),
                        onTap: () => context.pop(),
                        isDark: true,
                        fontSize: 14,
                        width: double.infinity,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomUnderLineButtonWidget(
                        title: context.translate('confirm'),
                        onTap: () => context.pop(),
                        width: double.infinity,
                        isRed: true,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
