import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_email_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'verification_change_email_dialog.dart';

void showChangeEmailDialog(BuildContext context) {
  context.showManagePopup(
      height: 526,
      child: const ChangeEmailDialog(),
      title: context.translate("change_your_email_title"));
}

class ChangeEmailDialog extends ConsumerStatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  ConsumerState<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends ConsumerState<ChangeEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = ref.watch(currentUserProvider).user?.email ?? '';
      _currentEmailController.text = email;
    });

    // Listen to change email provider to show messages and close dialog
    ref.listenManual<ChangeEmailState>(changeEmailProvider, (previous, next) {
      if (next.isChanging) return;
      if (next.status == ChangeEmailStatus.success) {
        // close dialog then navigate to verification page to confirm new email

        final newEmail = next.newEmail ?? '';

        // Navigate to verification page with the new email
        if (mounted && context.mounted) {
          context.pop(); // Close change email dialog

          // Show verification dialog after a short delay to ensure previous dialog is closed
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              showVerificationChangeEmailDialog(context, newEmail);
            }
          });
        }
      } else if (next.hasError) {
        context.showSnackBar(
            message: next.errorMessage ??
                context.translate('failed_to_change_email'),
            backgroundColor: context.error);
      }
    });
  }

  String? _validateCurrentEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.translate('email_required');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return context.translate('email_invalid');
    }
    return null;
  }

  String? _validateNewEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.translate('email_required');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return context.translate('email_invalid');
    }
    if (value.trim() == _currentEmailController.text.trim()) {
      return context.translate('new_email_same_as_current');
    }
    return null;
  }

  String? _validateConfirmEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.translate('email_required');
    }
    if (value.trim() != _newEmailController.text.trim()) {
      return context.translate('new_email_mismatch');
    }
    return null;
  }

  void _handleChangeEmail() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(changeEmailProvider.notifier).changeEmail(
            currentEmail: _currentEmailController.text.trim(),
            newEmail: _newEmailController.text.trim(),
            repeatNewEmail: _confirmEmailController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changeEmailState = ref.watch(changeEmailProvider);
    final isChanging = changeEmailState.isChanging;
    return _manageDialogBody(context, isChanging);
  }

  Widget _manageDialogBody(BuildContext context, bool isChanging) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 0 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CommonText.bodyMedium(
                    context.translate("change_your_email_description"),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              context.isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.bodyLarge(
                          context.translate("current_email"),
                          color: Colors.white,
                        ),
                        CommonTextField(
                          controller: _currentEmailController,
                          hintText: context.translate("current_email"),
                          validator: _validateCurrentEmail,
                          enabled: false,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: CommonText.bodyLarge(
                          context.translate("current_email"),
                          color: Colors.white,
                        )),
                        Expanded(
                          flex: 2,
                          child: CommonTextField(
                            controller: _currentEmailController,
                            hintText: context.translate("current_email"),
                            validator: _validateCurrentEmail,
                            enabled: false,
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              context.isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.bodyLarge(context.translate("new_email"),
                            color: Colors.white),
                        CommonTextField(
                          controller: _newEmailController,
                          hintText: context.translate("new_email"),
                          validator: _validateNewEmail,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: CommonText.bodyLarge(
                          context.translate("new_email"),
                          color: Colors.white,
                        )),
                        Expanded(
                          flex: 2,
                          child: CommonTextField(
                            controller: _newEmailController,
                            hintText: context.translate("new_email"),
                            validator: _validateNewEmail,
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              context.isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.bodyLarge(
                            context.translate("confirm_new_email"),
                            color: Colors.white),
                        CommonTextField(
                          controller: _confirmEmailController,
                          hintText: context.translate("confirm_new_email"),
                          validator: _validateConfirmEmail,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: CommonText.bodyLarge(
                          context.translate("confirm_new_email"),
                          color: Colors.white,
                        )),
                        Expanded(
                          flex: 2,
                          child: CommonTextField(
                            controller: _confirmEmailController,
                            hintText: context.translate("confirm_new_email"),
                            validator: _validateConfirmEmail,
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              CustomUnderLineButtonWidget(
                title: context.translate("change_your_email_btn_text"),
                fontSize: 14,
                isDark: true,
                fontWeight: FontWeight.w700,
                width: 200,
                isLoading: isChanging,
                onTap: isChanging ? null : _handleChangeEmail,
              )
            ],
          ),
        ),
      ),
    );
  }
}
