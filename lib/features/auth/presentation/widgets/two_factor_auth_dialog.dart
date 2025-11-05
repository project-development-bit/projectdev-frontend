import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart' show CommonText;
import 'package:cointiply_app/core/common/common_textfield.dart'
    show CommonTextField;
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/verify_2fa_provider.dart';

class TwoFactorAuthDialog extends ConsumerStatefulWidget {
  const TwoFactorAuthDialog({
    super.key,
    required this.email,
    this.sessionToken,
    this.onSuccess,
  });

  final String email;
  final String? sessionToken;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<TwoFactorAuthDialog> createState() =>
      _TwoFactorAuthDialogState();
}

class _TwoFactorAuthDialogState extends ConsumerState<TwoFactorAuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen to 2FA verification state changes
    ref.listenManual<Verify2FAState>(verify2FANotifierProvider,
        (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case Verify2FASuccess():
          // Show success message
          if (mounted) {
            context.showSuccessSnackBar(
              message: next.message,
            );

            // Close dialog
            context.pop();

            // Call success callback
            widget.onSuccess?.call();
          }
          break;
        case Verify2FAError():
          // Show error message
          if (mounted) {
            context.showErrorSnackBar(
              message: next.message,
            );
          }
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the 6-digit code';
    }
    if (value.length != 6) {
      return 'Code must be exactly 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code must contain only numbers';
    }
    return null;
  }

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final verify2FANotifier = ref.read(verify2FANotifierProvider.notifier);

    await verify2FANotifier.verify2FA(
      email: widget.email,
      twoFactorCode: _codeController.text.trim(),
      sessionToken: widget.sessionToken,
      onSuccess: () {
        debugPrint('✅ 2FA verification successful in dialog');
      },
      onError: (errorMessage) {
        debugPrint('❌ 2FA verification error in dialog: $errorMessage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final localizations = AppLocalizations.of(context);
    final isLoading = ref.watch(is2FALoadingProvider);
    final isMobile = context.isMobile;

    final qrCodeData = "12345678"; // Replace with actual data for QR code

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 500,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15,
                children: [
                  // Close button
                  dialogAppBar(colorScheme, isLoading, context),
                  Divider(
                    color: colorScheme.outline.withAlpha(77), // 0.3 * 255 = 77
                    thickness: 1,
                  ),

                  //subtitle and body text
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.labelMedium(
                          context.translate("2fa_dialog_subtitle"),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        CommonText.bodyMedium(
                          context.translate("2fa_dialog_body_text"),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  /// QR Code Display
                  QrImageView(
                    data: qrCodeData,
                    size: 150,
                    backgroundColor: Colors.white,
                  ),

                  /// note text
                  _2faNoteText(context, qrCodeData),

                  /// Verification Code Input
                  CommonTextField(
                    controller: _codeController,
                    focusNode: _codeFocusNode,
                    labelText:
                        context.translate("security_verification_required"),
                    hintText: 'Enter 6-digit code',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    enabled: !isLoading,
                    validator: _validateCode,
                    onSubmitted: (_) => _handleVerify(),
                  ),

                  CommonButton(
                      text: context.translate("2fa_verify_button_text"),
                      onPressed: () {
                        _handleVerify();
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container _2faNoteText(BuildContext context, String qrCodeData) {
    return Container(
        decoration: DottedDecoration(
          color: context.primary,
          shape: Shape.box,
          dash: [4, 4],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: context.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.bodyMedium(
                        context.translate("2fa_dialog_note_text"),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: qrCodeData),
                                );
                                context.showSuccessSnackBar(
                                  message: 'Copied to clipboard',
                                );
                              },
                              child: CommonText.labelMedium(qrCodeData)),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              size: 20,
                              color: context.primary,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: qrCodeData),
                              );
                              context.showSuccessSnackBar(
                                message: 'Copied to clipboard',
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget dialogAppBar(
      ColorScheme colorScheme, bool isLoading, BuildContext context) {
    return Row(
      children: [
        Align(
          child: CommonText.titleSmall(
            context.translate("two_factor_authentication_title"),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: isLoading ? null : () => context.pop(false),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}

/// Helper function to show 2FA dialog
Future<bool?> show2FADialog(
  BuildContext context, {
  required String email,
  String? sessionToken,
  VoidCallback? onSuccess,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => TwoFactorAuthDialog(
      email: email,
      sessionToken: sessionToken,
      onSuccess: onSuccess,
    ),
  );
}
