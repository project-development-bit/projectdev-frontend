import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_email_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
// removed unused import
import 'package:cointiply_app/routing/verification_page_parameter.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showChangeEmailDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => const ChangeEmailDialog(),
  );
}

class ChangeEmailDialog extends ConsumerStatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  ConsumerState<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends ConsumerState<ChangeEmailDialog> {
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
        context.pop();
        context.pushToVerification(email: newEmail, isFromChangeEmail: true);
      } else if (next.hasError) {
        context.showSnackBar(
            message: next.errorMessage ??
                context.translate('failed_to_change_email'),
            backgroundColor: context.error);
      }
    });
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
    return DialogBgWidget(
      dialogHeight: 526,
      body: _manageDialogBody(context, isChanging),
      title: context.translate("change_your_email_title"),
    );
  }

  Widget _manageDialogBody(BuildContext context, bool isChanging) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
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
          Row(
            children: [
              Expanded(
                  child: CommonText.bodyMedium(
                      context.translate("current_email"))),
              Expanded(
                flex: 2,
                child: CommonTextField(
                    controller: _currentEmailController,
                    hintText: context.translate("current_email")),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                  child: CommonText.bodyMedium(context.translate("new_email"))),
              Expanded(
                flex: 2,
                child: CommonTextField(
                    controller: _newEmailController,
                    hintText: context.translate("new_email")),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                  child: CommonText.bodyMedium(
                      context.translate("confirm_new_email"))),
              Expanded(
                flex: 2,
                child: CommonTextField(
                    controller: _confirmEmailController,
                    hintText: context.translate("confirm_new_email")),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          CommonButton(
            text: context.translate("change_your_email_btn_text"),
            backgroundColor: Color(0xff333333),
            isLoading: isChanging,
            onPressed: () {
              final current = _currentEmailController.text.trim();
              final n = _newEmailController.text.trim();
              final confirm = _confirmEmailController.text.trim();

              if (current.isEmpty || n.isEmpty || confirm.isEmpty) {
                context.showSnackBar(
                    message: context.translate('please_fill_required_fields'));
                return;
              }

              if (n != confirm) {
                context.showSnackBar(
                    message: context.translate('new_email_mismatch'));
                return;
              }

              ref.read(changeEmailProvider.notifier).changeEmail(
                    currentEmail: current,
                    newEmail: n,
                    repeatNewEmail: confirm,
                  );
            },
          ),
        ],
      ),
    );
  }
}
