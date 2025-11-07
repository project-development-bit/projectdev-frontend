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
import '../providers/setup_2fa_provider.dart';
import '../providers/enable_2fa_provider.dart';
import '../../data/models/setup_2fa_response.dart';

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

  // Store the secret from setup response to use in enable API
  String? _secret;

  @override
  void initState() {
    super.initState();

    // Fetch 2FA setup data when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(setup2FAProvider.notifier).setup2FA();
    });

    // Listen to Enable 2FA state changes
    ref.listenManual<Enable2FAState>(enable2FAProvider, (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case Enable2FASuccess():
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
        case Enable2FAError():
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

    // Listen to 2FA verification state changes (fallback for login flow)
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

    // Check if we have the secret from setup
    if (_secret == null) {
      if (mounted) {
        context.showErrorSnackBar(
          message: 'Setup data not available. Please try again.',
        );
      }
      return;
    }

    // Call enable 2FA API
    final enable2FANotifier = ref.read(enable2FAProvider.notifier);

    await enable2FANotifier.enable2FA(
      token: _codeController.text.trim(),
      secret: _secret!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final setup2FAState = ref.watch(setup2FAProvider);
    final isEnabling = ref.watch(isEnable2FALoadingProvider);
    final isMobile = context.isMobile;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                _DialogHeader(
                  isLoading: setup2FAState is Setup2FALoading || isEnabling,
                ),
                const SizedBox(height: 16),
                Divider(
                  color: colorScheme.outline.withAlpha(77),
                  thickness: 1,
                ),
                const SizedBox(height: 16),

                // Content based on state
                _buildContent(setup2FAState, isEnabling),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Setup2FAState state, bool isEnabling) {
    return switch (state) {
      Setup2FAInitial() => const SizedBox.shrink(),
      Setup2FALoading() => _LoadingState(),
      Setup2FASuccess(:final data) => Builder(
          builder: (context) {
            // Store the secret for use in enable API
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _secret = data.secret;
            });

            return _SetupSuccessState(
              data: data,
              formKey: _formKey,
              codeController: _codeController,
              codeFocusNode: _codeFocusNode,
              validateCode: _validateCode,
              handleVerify: _handleVerify,
              isVerifying: isEnabling,
            );
          },
        ),
      Setup2FAError(:final message) => _ErrorState(
          message: message,
          onRetry: () => ref.read(setup2FAProvider.notifier).setup2FA(),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

// ============================================================================
// SEPARATED WIDGETS BY STATE
// ============================================================================

/// Dialog Header Widget
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CommonText.titleSmall(
          context.translate("two_factor_authentication_title"),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.close,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: isLoading ? null : () => context.pop(false),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

/// Loading State Widget
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: context.primary,
          ),
          const SizedBox(height: 24),
          CommonText.bodyLarge(
            context.translate("loading_2fa_setup"),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Error State Widget
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.error,
          ),
          const SizedBox(height: 16),
          CommonText.bodyLarge(
            message,
            textAlign: TextAlign.center,
            color: context.error,
          ),
          const SizedBox(height: 24),
          CommonButton(
            text: context.translate("retry"),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Success State Widget - Shows QR Code and Verification Form
class _SetupSuccessState extends StatelessWidget {
  const _SetupSuccessState({
    required this.data,
    required this.formKey,
    required this.codeController,
    required this.codeFocusNode,
    required this.validateCode,
    required this.handleVerify,
    required this.isVerifying,
  });

  final Setup2FAData data;
  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final String? Function(String?) validateCode;
  final Future<void> Function() handleVerify;
  final bool isVerifying;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Instructions
          _InstructionsSection(),
          const SizedBox(height: 24),

          // QR Code Section
          _QRCodeSection(qrCodeData: data.otpauthUrl),
          const SizedBox(height: 24),

          // Manual Entry Section
          _ManualEntrySection(secret: data.secret),
          const SizedBox(height: 24),

          // Verification Form
          _VerificationFormSection(
            codeController: codeController,
            codeFocusNode: codeFocusNode,
            validateCode: validateCode,
            handleVerify: handleVerify,
            isVerifying: isVerifying,
          ),
        ],
      ),
    );
  }
}

/// Instructions Section
class _InstructionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primary.withAlpha(26), // 0.1 * 255
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText.labelMedium(
                  context.translate("2fa_dialog_subtitle"),
                  color: context.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CommonText.bodyMedium(
            context.translate("2fa_dialog_body_text"),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

/// QR Code Section
class _QRCodeSection extends StatelessWidget {
  const _QRCodeSection({required this.qrCodeData});

  final String qrCodeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonText.labelLarge(
          context.translate("scan_qr_code"),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26), // 0.1 * 255
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: QrImageView(
            data: qrCodeData,
            size: 200,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Manual Entry Section
class _ManualEntrySection extends StatelessWidget {
  const _ManualEntrySection({required this.secret});

  final String secret;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(
        color: context.primary,
        shape: Shape.box,
        dash: const [4, 4],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.primary.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.vpn_key_outlined,
                  color: context.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                CommonText.labelMedium(
                  context.translate("manual_entry_code"),
                  color: context.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            CommonText.bodySmall(
              context.translate("2fa_dialog_note_text"),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.primary.withAlpha(128), // 0.5 * 255
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SelectableText(
                      secret,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.onSurface,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 20,
                      color: context.primary,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: secret));
                      context.showSuccessSnackBar(
                        message: context.translate("code_copied"),
                      );
                    },
                    tooltip: context.translate("copy_code"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Verification Form Section
class _VerificationFormSection extends StatelessWidget {
  const _VerificationFormSection({
    required this.codeController,
    required this.codeFocusNode,
    required this.validateCode,
    required this.handleVerify,
    required this.isVerifying,
  });

  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final String? Function(String?) validateCode;
  final Future<void> Function() handleVerify;
  final bool isVerifying;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show verifying overlay when processing
        if (isVerifying)
          _VerifyingOverlay()
        else
          _VerificationForm(
            codeController: codeController,
            codeFocusNode: codeFocusNode,
            validateCode: validateCode,
            handleVerify: handleVerify,
          ),
      ],
    );
  }
}

/// Verifying Overlay - Shows when enable 2FA is in progress
class _VerifyingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: context.primary.withAlpha(13), // 0.05 * 255
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primary.withAlpha(51), // 0.2 * 255
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated circular progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  color: context.primary,
                  strokeWidth: 3,
                ),
              ),
              Icon(
                Icons.security,
                size: 28,
                color: context.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          CommonText.titleMedium(
            context.translate("verifying_code"),
            textAlign: TextAlign.center,
            color: context.primary,
          ),
          const SizedBox(height: 8),
          CommonText.bodyMedium(
            context.translate("please_wait"),
            textAlign: TextAlign.center,
            color: context.onSurface.withAlpha(179), // 0.7 * 255
          ),
        ],
      ),
    );
  }
}

/// Verification Form - Shows input field and verify button
class _VerificationForm extends StatelessWidget {
  const _VerificationForm({
    required this.codeController,
    required this.codeFocusNode,
    required this.validateCode,
    required this.handleVerify,
  });

  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final String? Function(String?) validateCode;
  final Future<void> Function() handleVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonTextField(
          controller: codeController,
          focusNode: codeFocusNode,
          labelText: context.translate("enter_verification_code"),
          hintText: 'Enter 6-digit code',
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: validateCode,
          onSubmitted: (_) => handleVerify(),
          prefixIcon: Icon(
            Icons.pin,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CommonButton(
            text: context.translate("2fa_verify_button_text"),
            onPressed: handleVerify,
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
