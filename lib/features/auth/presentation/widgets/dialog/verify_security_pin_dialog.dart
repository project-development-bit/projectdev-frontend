import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/common_textfield.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/theme/app_colors.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/security_pin_providers.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/verify_security_pin_notifier.dart';
import 'package:go_router/go_router.dart';

void showVerifySecurityPinDialog(BuildContext context,
    {Function(BuildContext ctx)? onPinVerified}) {
  context.showManagePopup(
    barrierDismissible: true,
    child: VerifySecurityPinDialog(onPinVerified: onPinVerified),
  );
}

class VerifySecurityPinDialog extends ConsumerStatefulWidget {
  final Function(BuildContext ctx)? onPinVerified;

  const VerifySecurityPinDialog({super.key, this.onPinVerified});

  @override
  ConsumerState<VerifySecurityPinDialog> createState() =>
      _SecurityPinDialogState();
}

class _SecurityPinDialogState extends ConsumerState<VerifySecurityPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();

    // Listen to state changes
    ref.listenManual<VerifySecurityPinState>(
      verifySecurityPinNotifierProvider,
      (previous, next) async {
        if (next.isLoaing) return;
        if (next.isSuccess) {
          if (mounted && context.mounted) {
            context.showSuccessSnackBar(message: next.successMessage ?? "");
          }
        } else if (next.hasError) {
          if (mounted && context.mounted) {
            context.showSnackBar(
              message: next.errorMessage ?? "",
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
    _codeController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() => _errorText = null);

    final pinText = _codeController.text.trim();

    // 1️⃣ Empty check
    if (pinText.isEmpty) {
      setState(() {
        _errorText = context.translate("security_pin_empty_error");
      });
      return;
    }

    // 2️⃣ Length check
    if (pinText.length != 4) {
      setState(() {
        _errorText = context.translate("security_pin_length_error");
      });
      return;
    }

    // 3️⃣ Numeric check
    if (!RegExp(r'^[0-9]{4}$').hasMatch(pinText)) {
      setState(() {
        _errorText = context.translate("security_pin_must_be_numeric");
      });
      return;
    }

    // 4️⃣ Parse PIN
    final pin = int.tryParse(pinText);
    if (pin == null) {
      setState(() {
        _errorText = context.translate("security_pin_invalid_error");
      });
      return;
    }

    // 5️⃣ Submit
    ref.read(verifySecurityPinNotifierProvider.notifier).verifySecurityPin(
          securityPin: pinText,
          onVerified: () {
            context.pop();
            widget.onPinVerified?.call(context);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(verifySecurityPinNotifierProvider).isLoaing;
    final isMobile = context.isMobile;
    return DialogBgWidget(
      isOverlayLoading: isLoading,
      isInitLoading: false,
      titleFontSize: 32,
      dialogWidth: isMobile ? context.screenWidth * 0.9 : 630,
      isShowingCloseButton: true,
      dialogHeight: isMobile
          ? context.screenHeight * 0.9
          : isLoading
              ? _getDialogHeight()
              : null,
      title: context.translate("verify_security_pin"),
      onRouteBack: () {
        if (!isLoading) {
          context.pop();
        }
      },
      body: SingleChildScrollView(
        padding: context.isMobile || context.isTablet
            ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
            : const EdgeInsets.symmetric(horizontal: 124, vertical: 22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bodyMedium(
                context.translate("verify_pin_description"),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 20 : 32),

              // Subtitle
              Center(
                child: CommonText.bodyMedium(
                  context.translate('enter_your_4_digit_pin'),
                  fontSize: 14,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 32),

              // Code Input Field
              CommonTextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 4,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                  color: context.onSurface,
                ),
                hintText: 'XXXX',
                hintStyle: TextStyle(
                  color: Color(0xff6F6F6F),
                  letterSpacing: 10,
                ),
                fillColor: Colors.transparent,
                filled: true,
                borderRadius: 8,
                borderColor:
                    _errorText != null ? AppColors.error : context.outline,
                borderWidth: 1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color:
                        _errorText != null ? AppColors.error : context.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        _errorText != null ? AppColors.error : context.primary,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onSubmitted: isLoading ? null : (_) => _validateAndSubmit(),
                onChanged: (_) {
                  // Clear error when user starts typing
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
              ),
              SizedBox(height: isMobile ? 20 : 32),

              CustomUnderLineButtonWidget(
                title: context.translate("verify_pin"),
                onTap: isLoading ? () {} : () => _validateAndSubmit(),
                fontSize: 14,
                width: double.infinity,
              ),
              SizedBox(height: isMobile ? 20 : 32),

              // Support Link
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: context.onSurface.withValues(alpha: 0.6),
                  ),
                  children: [
                    TextSpan(
                        text: context.translate('2fa_support_text'),
                        style: TextStyle(
                          fontSize: 14,
                          color: context.onSurface.withValues(alpha: 0.6),
                        )),
                    TextSpan(
                      text: context.translate('contact_support'),
                      style: TextStyle(
                        color: context.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  double? _getDialogHeight() {
    return context.isDesktop
        ? 400
        : context.isTablet
            ? 450
            : 500;
  }
}
