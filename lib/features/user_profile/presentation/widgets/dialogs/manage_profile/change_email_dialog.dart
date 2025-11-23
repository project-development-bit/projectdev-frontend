import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:flutter/material.dart';


void showChangeEmailDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => const ChangeEmailDialog(),
  );
}


class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    return DialogBgWidget(
      dialogHeight: 526,
      body: _manageDialogBody(context),
      title: context.translate("change_your_email_title"),
    );
  }

  Widget _manageDialogBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20 ),
              child: CommonText.bodyMedium(
                context.translate("change_your_email_description"),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: CommonText.bodyMedium(context.translate("current_email"))),
              Expanded(
                flex: 2,
                child: CommonTextField(
                  controller: _currentEmailController,
                  hintText: context.translate("current_email")
                ),
              )
            ],
          ),
          SizedBox(height: 24,),
          Row(
            children: [
              Expanded(
                  child: CommonText.bodyMedium(
                      context.translate("new_email"))),
              Expanded(
                flex: 2,
                child: CommonTextField(
                    controller: _currentEmailController,
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
                    controller: _currentEmailController,
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
            onPressed: (){

            },
          ),
        ],
      ),
    );
  }
}