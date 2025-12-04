import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_email_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'verification_change_email_dialog.dart';

void showChangeEmailDialog(BuildContext context) {
  context.showManagePopup(
    child: const ChangeEmailDialog(),
  );
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
    double dialogHeight = context.isDesktop
        ? 450
        : context.isTablet
            ? 560
            : 580;

    return DialogBgWidget(
        title: context.translate("change_your_email_title"),
        dialogHeight: dialogHeight,
        body: _manageDialogBody(context, isChanging));
  }

  Widget _manageDialogBody(BuildContext context, bool isChanging) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: context.isMobile || context.isTablet ? 16 : 32),
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
              context.isMobile || context.isTablet
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        CommonText.bodyLarge(
                          context.translate("current_email",
                              args: [context.isDesktop ? '\n' : ' ']),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        CommonTextField(
                          fillColor: Color(0xff1A1A1A),
                          controller: _currentEmailController,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          hintText:
                              context.translate("current_email", args: [' ']),
                          validator: _validateCurrentEmail,
                          enabled: false,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                            width: 170,
                            child: CommonText.bodyLarge(
                              context.translate("current_email",
                                  args: [context.isDesktop ? '\n' : ' ']),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )),
                        Expanded(
                          flex: 3,
                          child: CommonTextField(
                            fillColor: Color(0xff1A1A1A),
                            controller: _currentEmailController,
                            hintText:
                                context.translate("current_email", args: [' ']),
                            validator: _validateCurrentEmail,
                            enabled: false,
                            style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                                color: Color(0xffB3B3B3),
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              context.isMobile || context.isTablet
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        CommonText.bodyLarge(
                            context.translate("new_email",
                                args: [context.isDesktop ? '\n' : ' ']),
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        CommonTextField(
                          fillColor: Color(0xff1A1A1A),
                          controller: _newEmailController,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          hintText: context.translate("new_email", args: [' ']),
                          validator: _validateNewEmail,
                          hintStyle: context.textTheme.bodyMedium?.copyWith(
                              color: Color(0xffB3B3B3),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                            width: 170,
                            child: CommonText.bodyLarge(
                              context.translate("new_email",
                                  args: [context.isDesktop ? '\n' : ' ']),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )),
                        Expanded(
                          flex: 3,
                          child: CommonTextField(
                            fillColor: Color(0xff1A1A1A),
                            controller: _newEmailController,
                            hintText:
                                context.translate("new_email", args: [' ']),
                            validator: _validateNewEmail,
                            style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                                color: Color(0xffB3B3B3),
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              context.isMobile || context.isTablet
                  ? Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.bodyLarge(
                            context.translate("confirm_new_email",
                                args: [context.isDesktop ? '\n' : ' ']),
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        CommonTextField(
                          fillColor: Color(0xff1A1A1A),
                          controller: _confirmEmailController,
                          hintText: context
                              .translate("confirm_new_email", args: [' ']),
                          validator: _validateConfirmEmail,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          hintStyle: context.textTheme.bodyMedium?.copyWith(
                              color: Color(0xffB3B3B3),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                            width: 170,
                            child: CommonText.bodyLarge(
                              context.translate("confirm_new_email",
                                  args: [context.isDesktop ? '\n' : ' ']),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )),
                        Expanded(
                          flex: 1,
                          child: CommonTextField(
                            fillColor: Color(0xff1A1A1A),
                            controller: _confirmEmailController,
                            hintText: context
                                .translate("confirm_new_email", args: [' ']),
                            validator: _validateConfirmEmail,
                            style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                                color: Color(0xffB3B3B3),
                                fontWeight: FontWeight.w500),
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
                width: context.isMobile || context.isTablet
                    ? double.infinity
                    : 300,
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
