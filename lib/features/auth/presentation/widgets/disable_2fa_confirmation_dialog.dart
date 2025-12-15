// import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/disable_2fa_provider.dart';
import '../providers/check_2fa_status_provider.dart';

void showDisable2FAConfirmationDialog(BuildContext context,
    {required Function() onDisabled}) {
  context.showManagePopup(
    child: Disable2FAConfirmationDialog(onDisabled: onDisabled),
    barrierDismissible: true,
  );
}

/// Confirmation dialog for disabling 2FA
///
/// Shows a warning message and requires user confirmation before disabling 2FA
class Disable2FAConfirmationDialog extends ConsumerStatefulWidget {
  final Function() onDisabled;
  const Disable2FAConfirmationDialog({super.key, required this.onDisabled});

  @override
  ConsumerState<Disable2FAConfirmationDialog> createState() =>
      _Disable2FAConfirmationDialogState();
}

class _Disable2FAConfirmationDialogState
    extends ConsumerState<Disable2FAConfirmationDialog> {
  final _tokenController = TextEditingController();
  final _tokenFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    ref.listenManual<Disable2FAState>(disable2FAProvider, (previous, next) {
      if (next is Disable2FALoading) return;

      if (next is Disable2FASuccess) {
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: next.response.message,
            backgroundColor: context.primary,
            textColor: Colors.black,
          );

          // Close dialog
          context.pop();

          // Refresh 2FA status
          ref.read(check2FAStatusProvider.notifier).check2FAStatus();
          widget.onDisabled();
        }
      } else if (next is Disable2FAError) {
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: next.message,
            backgroundColor: context.error,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _tokenFocusNode.dispose();
    super.dispose();
  }

  String? _validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate('please_enter_2fa_code');
    }
    if (value.length != 6) {
      return context.translate('code_must_be_exactly_6_digits');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return context.translate('code_must_be_numbers_only');
    }
    return null;
  }

  void _handleDisable2FA() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref
        .read(disable2FAProvider.notifier)
        .disable2FA(_tokenController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final disable2FAState = ref.watch(disable2FAProvider);
    final isDisabling = disable2FAState is Disable2FALoading;

    return DialogBgWidget(
      isOverlayLoading: isDisabling,
      dialogHeight: context.isDesktop
          ? 450
          : context.isTablet
              ? 500
              : 610,
      title: context.translate("disable_2fa_title"),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: context.isMobile || context.isTablet
                ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
                : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning message
                CommonText.bodyLarge(
                  context.translate('disable_2fa_warning_message'),
                  color: context.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),

                // Security note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: context.error,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonText.bodyMedium(
                          context.translate('disable_2fa_security_note'),
                          color: context.error,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2FA Token Input
                CommonText.bodyMedium(
                  context.translate('enter_2fa_code_from_app'),
                  color: context.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 12),
                CommonTextField(
                  controller: _tokenController,
                  focusNode: _tokenFocusNode,
                  hintText: context.translate("enter_verification_code"),
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: _validateToken,
                  maxLength: 6,
                  enabled: !isDisabling,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  fillColor: const Color(0xff1A1A1A),
                  onSubmitted: (value) {
                    if (!isDisabling) {
                      _handleDisable2FA();
                    }
                  },
                ),

                const SizedBox(height: 32),

                // Action buttons
                Flex(
                  direction: context.isMobile || context.isTablet
                      ? Axis.vertical
                      : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.0,
                  textDirection:
                      context.isMobile ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    CustomButtonWidget(
                      title: context.translate("cancel"),
                      onTap: isDisabling
                          ? null
                          : () {
                              context.pop();
                              ref.read(disable2FAProvider.notifier).reset();
                            },
                      isOutlined: true,
                      width: context.isMobile || context.isTablet
                          ? double.infinity
                          : 233,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(width: 16),
                    CustomUnderLineButtonWidget(
                      title: context.translate("disable_2fa"),
                      onTap: isDisabling ? null : _handleDisable2FA,
                      fontColor: const Color(0xff98989A),
                      isRed: true,
                      width: context.isMobile || context.isTablet
                          ? double.infinity
                          : 233,
                      isLoading: isDisabling,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
