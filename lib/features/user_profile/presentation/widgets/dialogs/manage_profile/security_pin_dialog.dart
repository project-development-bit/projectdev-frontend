import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/set_security_pin_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showSecurityPinDialog(BuildContext context, {bool isPinEnabled = false}) {
  context.showManagePopup(
      barrierDismissible: true,
      height: context.isDesktop ? 400 : context.screenHeight * 0.9,
      child: SecurityPinDialog(isPinEnabled: isPinEnabled),
      title: context.translate(
          isPinEnabled ? "disable_security_pin" : "enable_security_pin_title"));
}

class SecurityPinDialog extends ConsumerStatefulWidget {
  final bool isPinEnabled;

  const SecurityPinDialog({super.key, this.isPinEnabled = false});

  @override
  ConsumerState<SecurityPinDialog> createState() => _SecurityPinDialogState();
}

class _SecurityPinDialogState extends ConsumerState<SecurityPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final pinCodeController = TextEditingController();
  final confirmPinCodeController = TextEditingController();
  String? _pinError;
  String? _confirmPinError;

  @override
  void initState() {
    super.initState();

    // Listen to state changes
    ref.listenManual<SetSecurityPinState>(
      setSecurityPinNotifierProvider,
      (previous, next) {
        if (next.isSetting) return;

        if (next.isSuccess) {
          if (mounted && context.mounted) {
            context.showSnackBar(
              message: next.successMessage ??
                  context.translate("security_pin_enabled_successfully"),
              backgroundColor: context.primary,
              textColor: Colors.white,
            );

            // Refresh profile to get updated security pin status
            ref
                .read(getProfileNotifierProvider.notifier)
                .fetchProfile(isLoading: false);

            // Close dialog
            context.pop();
          }
        } else if (next.hasError) {
          if (mounted && context.mounted) {
            context.showSnackBar(
              message: next.errorMessage ??
                  context.translate("failed_to_enable_security_pin"),
              backgroundColor: context.error,
              textColor: Colors.white,
            );
          }
        }
      },
    );
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

    // Check if PINs match (only for enable flow)
    if (!widget.isPinEnabled &&
        pinCodeController.text != confirmPinCodeController.text) {
      setState(() {
        _confirmPinError = context.translate("security_pin_mismatch_error");
      });
      return;
    }

    // Parse PIN to integer
    final pin = int.tryParse(pinCodeController.text);
    if (pin == null) {
      setState(() {
        _pinError = context.translate("security_pin_must_be_numeric");
      });
      return;
    }

    // Call API to set security PIN
    ref.read(setSecurityPinNotifierProvider.notifier).setSecurityPin(
          securityPin: pin,
          enable: !widget.isPinEnabled, // Toggle enable/disable
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(setSecurityPinNotifierProvider).isSetting;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(right: 5),
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
                            context
                                .translate("enable_security_pin_description"),
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
                        pinCodeField(
                          pinCodeController,
                          errorText: _pinError,
                        ),
                      ],
                    ),
              // Only show confirm field when enabling (not disabling)
              if (!widget.isPinEnabled) ...[
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
              ],
              Center(
                child: CustomUnderLineButtonWidget(
                  onTap: isLoading ? null : _validateAndSubmit,
                  isLoading: isLoading,
                  isDark: true,
                  fontSize: 14,
                  title: context.translate(widget.isPinEnabled
                      ? "disable_security_pin"
                      : "enable_security_pin"),
                ),
              )
            ],
          ),
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
