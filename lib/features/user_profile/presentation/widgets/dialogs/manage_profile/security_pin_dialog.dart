import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showSecurityPinDialog(BuildContext context) {
  context.showManagePopup(
      barrierDismissible: true,
      height: 400,
      child: const SecurityPinDialog(),
      title: context.translate("enable_security_pin_title"));
}

class SecurityPinDialog extends StatefulWidget {
  const SecurityPinDialog({super.key});

  @override
  State<SecurityPinDialog> createState() => _SecurityPinDialogState();
}

class _SecurityPinDialogState extends State<SecurityPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final pinCodeController = TextEditingController();
  final confirmPinCodeController = TextEditingController();
  bool _isLoading = false;
  String? _pinError;
  String? _confirmPinError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pinCodeController.dispose();
    confirmPinCodeController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() async {
    setState(() {
      _pinError = null;
      _confirmPinError = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if PINs match
    if (pinCodeController.text != confirmPinCodeController.text) {
      setState(() {
        _confirmPinError = context.translate("security_pin_mismatch_error");
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement API call to enable security PIN
    // For now, simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      context.showSnackBar(
        message: context.translate("security_pin_enabled_successfully"),
        backgroundColor: context.primary,
      );

      // Close dialog
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText.bodySmall(
              context.translate("enable_security_pin_note"),
              fontWeight: FontWeight.w500,
              color: Color(0xff98989A),
            ),
            context.isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: CommonText.bodyLarge(
                          context.translate("enable_security_pin_description"),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: pinCodeField(
                          pinCodeController,
                          errorText: _pinError,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      CommonText.bodyMedium(
                        context.translate("enable_security_pin_description"),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      pinCodeField(
                        pinCodeController,
                        errorText: _pinError,
                      ),
                    ],
                  ),
            context.isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: CommonText.bodyLarge(
                          context.translate("repeat_4_digit_pin"),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: pinCodeField(
                          confirmPinCodeController,
                          errorText: _confirmPinError,
                          isConfirmField: true,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      CommonText.bodyMedium(
                        context.translate("repeat_4_digit_pin"),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      pinCodeField(
                        confirmPinCodeController,
                        errorText: _confirmPinError,
                        isConfirmField: true,
                      ),
                    ],
                  ),
            Center(
              child: CustomUnderLineButtonWidget(
                onTap: _validateAndSubmit,
                isLoading: _isLoading,
                height: 56,
                isActive: true,
                width: 200,
                fontSize: 14,
              title: context.translate("enter_security_pin"),
              ),
            )
          ],
        ),
      ),
    );
  }

  CommonTextField pinCodeField(
    TextEditingController controller, {
    String? errorText,
    bool isConfirmField = false,
  }) {
    return CommonTextField(
      controller: controller,
      maxLength: 4,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.translate("security_pin_empty_error");
        }
        if (value.length != 4) {
          return context.translate("security_pin_length_error");
        }
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return context.translate("security_pin_must_be_numeric");
        }
        return errorText;
      },
      hintText: context.translate("enter_security_pin_hint"),
    );
  }
}
