import 'package:gigafaucet/core/common/common_button.dart';
import 'package:gigafaucet/core/common/common_text.dart' show CommonText;
import 'package:gigafaucet/core/common/common_textfield.dart'
    show CommonTextField;
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/user_profile/presentation/widgets/dialogs/dialog_scaffold_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/routing/routing.dart';
import 'package:flutter/material.dart';
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

            if (mounted) {
              // Close dialog
              context.pop();
            }

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
    final setup2FAState = ref.watch(setup2FAProvider);
    final isEnabling = ref.watch(isEnable2FALoadingProvider);

    final isInitLoading = ref.watch(setup2FAProvider) is Setup2FALoading;
    double dialogHeight = context.isDesktop
        ? 645
        : context.isTablet
            ? 700
            : 750;

    return DialogBgWidget(
      isOverlayLoading: isEnabling,
      dialogHeight: dialogHeight,
      isInitLoading: isInitLoading,
      title: context.translate("setup_2fa_app_title"),
      body: SingleChildScrollView(
        child: Padding(
            padding: context.isDesktop
                ? const EdgeInsets.symmetric(horizontal: 31, vertical: 16)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildContent(setup2FAState, isEnabling)),
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
          CommonText.bodyMedium(
            context.translate("setup_2fa_app_description"),
            fontWeight: FontWeight.w500,
            highlightColor: Colors.white,
            highlightFontWeight: FontWeight.w700,
            highlightFontSize: 16,
          ),
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

/// QR Code Section
class _QRCodeSection extends StatelessWidget {
  const _QRCodeSection({required this.qrCodeData});

  final String qrCodeData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.onError,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.scrim.withAlpha(26), // 0.1 * 255
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: QrImageView(
        data: qrCodeData,
        size: 150,
        backgroundColor: colorScheme.onError,
      ),
    );
  }
}

/// Manual Entry Section
class _ManualEntrySection extends StatelessWidget {
  const _ManualEntrySection({required this.secret});

  final String secret;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.bodyMedium(
          context.translate("2fa_dialog_note_text"),
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 12),
        Container(
          width: isMobile ? double.infinity : 450,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xff333333),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.zero,
            child: Center(
              child: CommonText.bodyMedium(
                secret,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
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
    return _VerificationForm(
      codeController: codeController,
      codeFocusNode: codeFocusNode,
      validateCode: validateCode,
      handleVerify: handleVerify,
      isVerifying: isVerifying,
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
    required this.isVerifying,
  });

  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final String? Function(String?) validateCode;
  final Future<void> Function() handleVerify;
  final bool isVerifying;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bodyLarge(context.translate("authentication_code"),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              const SizedBox(height: 8),
              CommonTextField(
                controller: codeController,
                focusNode: codeFocusNode,
                hintText: context.translate("enter_verification_code"),
                keyboardType: TextInputType.number,
                validator: validateCode,
                style:
                    context.textTheme.bodyMedium?.copyWith(color: Colors.white),
                fillColor: const Color(0xff1A1A1A),
                onSubmitted: (_) => handleVerify(),
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonText.bodyLarge(context.translate("authentication_code"),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextField(
                  controller: codeController,
                  focusNode: codeFocusNode,
                  hintText: context.translate("enter_verification_code"),
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: validateCode,
                  fillColor: const Color(0xff1A1A1A),
                  onSubmitted: (_) => handleVerify(),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        CustomUnderLineButtonWidget(
          title: context.translate("enable_2fa_button"),
          onTap: handleVerify,
          fontColor: Color(0xff98989A),
          isDark: true,
          width: isMobile ? double.infinity : 233,
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 10,
          ),
          fontSize: 14,
          fontWeight: FontWeight.w700,
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
    builder: (context) => DialogScaffoldWidget(
      child: TwoFactorAuthDialog(
        email: email,
        sessionToken: sessionToken,
        onSuccess: onSuccess,
      ),
    ),
  );
}
