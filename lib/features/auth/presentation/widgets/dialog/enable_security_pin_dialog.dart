import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/common_textfield.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/extensions.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/security_pin_providers.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/set_security_pin_notifier.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showEnableSecurityPinDialog(BuildContext context,
    {bool isPinEnabled = false}) {
  context.showManagePopup(
    barrierDismissible: true,
    // height: context.isDesktop ? 400 : context.screenHeight * 0.9,
    child: EnableSecurityPinDialog(isPinEnabled: isPinEnabled),
    // title: context.translate(
    //     isPinEnabled ? "disable_security_pin" : "enable_security_pin_title")
  );
}

class EnableSecurityPinDialog extends ConsumerStatefulWidget {
  final bool isPinEnabled;

  const EnableSecurityPinDialog({super.key, this.isPinEnabled = false});

  @override
  ConsumerState<EnableSecurityPinDialog> createState() =>
      _SecurityPinDialogState();
}

class _SecurityPinDialogState extends ConsumerState<EnableSecurityPinDialog> {
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
      (previous, next) async {
        if (next.isLoaing) return;

        if (next.isSuccess) {
          if (mounted && context.mounted) {
            context.showSuccessSnackBar(
                message: next.successMessage ??
                    context.translate("security_pin_enabled_successfully"));

            // Refresh profile to get updated security pin status
            ref
                .read(getProfileNotifierProvider.notifier)
                .fetchProfile(isLoading: false);
            ref.read(currentUserProvider.notifier).getCurrentUser();

            // Close dialog

            if (mounted) {
              context.pop();
            }
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
          securityPin: pinCodeController.text,
          enable: !widget.isPinEnabled, // Toggle enable/disable
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(setSecurityPinNotifierProvider).isLoaing;

    return DialogBgWidget(
      isOverlayLoading: isLoading,
      dialogHeight: _getDialogHeight(),
      title: context.translate(
          widget.isPinEnabled ? "disable_security_pin" : "enable_security_pin"),
      body: SingleChildScrollView(
        padding: context.isMobile || context.isTablet
            ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
            : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bodyMedium(
                context.translate("enable_security_pin_note"),
                fontWeight: FontWeight.w500,
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
                  width: context.isDesktop ? 233 : double.infinity,
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
      fillColor: Color(0xff1A1A1A),
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
      onSubmitted: (_) => _validateAndSubmit(),
      hintText: context.translate("enter_security_pin_hint"),
    );
  }

  double? _getDialogHeight() {
    if (widget.isPinEnabled) {
      return context.isDesktop
          ? 300
          : context.isTablet
              ? 350
              : 360;
    }
    return context.isDesktop
        ? 400
        : context.isTablet
            ? 450
            : 500;
  }
}
