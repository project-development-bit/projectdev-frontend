import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/auth/presentation/providers/logout_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/verify_delete_account_notifier.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showVerifyDeleteAccountDialog(BuildContext context, String email) {
  context.showManagePopup(
      height: context.isDesktop ? 500 : context.mediaQuery.size.height * 0.9,
      child: VerificationChangeEmailDialog(email: email),
      title: context.translate("verify_delete_email"));
}

class VerificationChangeEmailDialog extends ConsumerStatefulWidget {
  final String email;
  const VerificationChangeEmailDialog({super.key, required this.email});

  @override
  ConsumerState<VerificationChangeEmailDialog> createState() =>
      _VerificationChangeEmailDialogState();
}

class _VerificationChangeEmailDialogState
    extends ConsumerState<VerificationChangeEmailDialog> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual<VerifyDeleteAccountState>(
      verifyDeleteAccountNotifierProvider,
      (previous, next) async {
        if (next.isSuccess) {
          // Show success message
          await _handleLogout();
          
        }

        if (next.hasError) {
          if (mounted) {
            context.showSnackBar(
              message: next.errorMessage ??
                  context.translate("failed_to_delete_account"),
              backgroundColor: context.error,
            );
          }
        }
      },
    );
  }



  Future<void> _handleLogout() async {
    try {
      // Navigate to home/login
      if (mounted && context.mounted) {
        context.showSnackBar(
            message: context.translate("account_deleted_successfully"),
            backgroundColor: context.primary,
            textColor: Colors.black);
        await Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            context.pop();
            ref.read(logoutNotifierProvider.notifier).logout();
            context.pop();
          }
        });
      }
    } catch (e) {
      debugPrint('Error during logout after account deletion: $e');
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVerifying =
        ref.watch(verifyDeleteAccountNotifierProvider).isVerifying;

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: _bodyWidget(context, isVerifying: isVerifying)),
    );
  }

  Widget _bodyWidget(BuildContext context, {required bool isVerifying}) {
    return Column(
      spacing: 16,
      children: [
        CommonText.bodyLarge(context.translate("verify_delete_email_message")),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 21),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Color(0xff333333)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CommonText.bodyLarge(
              widget.email,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(),
        CommonText.bodyLarge(
          context.translate("verification_code_label"),
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        CommonTextField(
          controller: _codeController,
          hintText: context.translate('enter_verification_code'),
          keyboardType: TextInputType.number,
          maxLength: 4,
          style: context.textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 19,
          ),
          fillColor: Color(0xff1A1A1A),
          textAlign: TextAlign.center,
          hintStyle: context.textTheme.displayMedium?.copyWith(
            color: Color(0xff98989A),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        CommonText.bodyLarge(
          context.translate("code_will_expire_in_30_minutes"),
          color: Color(0xff98989A),
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: 6,
        ),
        context.isMobile
            ? Column(
                spacing: 12,
                children: [
                  CustomUnderLineButtonWidget(
                    width: double.infinity,
                    title: context.translate("confirm"),
                    onTap: isVerifying ? () {} : () => _handleVerifyAccount(),
                    isLoading: isVerifying,
                    fontColor: Colors.white,
                    isRed: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomUnderLineButtonWidget(
                    width: double.infinity,
                    title: context.translate("cancel"),
                    onTap: isVerifying ? () {} : () => context.pop(),
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
                        title: context.translate("cancel"),
                        onTap: isVerifying ? () {} : () => context.pop(),
                        fontColor: Colors.white,
                        isDark: true,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomUnderLineButtonWidget(
                        title: context.translate("confirm"),
                        onTap:
                            isVerifying ? () {} : () => _handleVerifyAccount(),
                        isLoading: isVerifying,
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
    );
  }

  _handleVerifyAccount() {
    final code = _codeController.text.trim();

    if (code.isEmpty || code.length != 4) {
      context.showSnackBar(
        message: context.translate("enter_verification_code"),
        backgroundColor: context.error,
      );
      return;
    }

    ref
        .read(verifyDeleteAccountNotifierProvider.notifier)
        .verifyDeleteAccount(code: code);
  }
}
