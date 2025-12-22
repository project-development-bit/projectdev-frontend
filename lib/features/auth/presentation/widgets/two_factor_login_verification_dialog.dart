import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../localization/data/helpers/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../providers/verify_login_2fa_provider.dart';

/// 2FA Login Verification Dialog
///
/// Beautiful dialog that prompts users with 2FA enabled to enter
/// their authenticator code during login
class TwoFactorLoginVerificationDialog extends ConsumerStatefulWidget {
  final int userId;
  final VoidCallback? onSuccess;

  const TwoFactorLoginVerificationDialog({
    super.key,
    required this.userId,
    this.onSuccess,
  });

  @override
  ConsumerState<TwoFactorLoginVerificationDialog> createState() =>
      _TwoFactorLoginVerificationDialogState();
}

class _TwoFactorLoginVerificationDialogState
    extends ConsumerState<TwoFactorLoginVerificationDialog> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  String? _errorText;

  final GlobalKey _boxKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Auto-focus the input field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });

    // Listen to verification state changes
    ref.listenManual<VerifyLogin2FAState>(verifyLogin2FAProvider,
        (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case VerifyLogin2FASuccess(:final response):
          // Store tokens
          if (response.data != null) {
            final secureStorage = ref.read(secureStorageServiceProvider);
            await secureStorage
                .saveAuthToken(response.data!.tokens.accessToken);
            await secureStorage
                .saveRefreshToken(response.data!.tokens.refreshToken);
            await secureStorage.saveUserId(response.data!.user.id.toString());

            // Show success message
            if (mounted) {
              context.showSuccessSnackBar(
                message: response.message,
              );

              // Close dialog
              context.pop(true);

              // Call success callback
              widget.onSuccess?.call();
            }
          }
          break;
        case VerifyLogin2FAError(:final message):
          // Show error message under text field
          if (mounted) {
            setState(() {
              _errorText = message;
            });
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

  void _handleVerify() {
    // Clear previous error
    setState(() {
      _errorText = null;
    });

    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorText = context.translate('2fa_code_required');
      });
      return;
    }

    if (code.length != 6) {
      setState(() {
        _errorText = context.translate('2fa_code_must_be_6_digits');
      });
      return;
    }

    ref
        .read(verifyLogin2FAProvider.notifier)
        .verifyLogin2FA(token: code, userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final verifyLogin2FAState = ref.watch(verifyLogin2FAProvider);
    final localizations = AppLocalizations.of(context);
    final isLoading = verifyLogin2FAState is VerifyLogin2FALoading;

    final isMobile = context.isMobile;
    return PopScope(
      canPop: !isLoading,
      child: DialogBgWidget(
        isOverlayLoading: isLoading,
        key: _boxKey,
        titleFontSize: 32,
        dialogWidth: isMobile ? context.screenWidth * 0.9 : 630,
        isShowingCloseButton: false,
        dialogHeight: isMobile
            ? context.screenHeight * 0.9
            : isLoading
                ? _getDialogHeight()
                : null,
        title: context.translate('2fa_login_verification_title'),
        body: Container(
          width: isMobile ? double.infinity : 396,
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage(AppLocalImages.twoFABackground))),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo/Name

                SizedBox(height: isMobile ? 12 : 32),

                // Title
                CommonText.bodyMedium(
                  context.translate('profile_2fa_description'),
                  fontWeight: FontWeight.w500,
                  color: Color(0xff98989A),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 20 : 32),

                // Subtitle
                CommonText.bodyMedium(
                  context.translate('enter_2fa_code_caption'),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),

                // Code Input Field
                CommonTextField(
                  controller: _codeController,
                  focusNode: _codeFocusNode,
                  enabled: !isLoading,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                    color: context.onSurface,
                  ),
                  hintText: 'XXXXXX',
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
                      color: _errorText != null
                          ? AppColors.error
                          : context.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _errorText != null
                          ? AppColors.error
                          : context.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onSubmitted: isLoading ? null : (_) => _handleVerify(),
                  onChanged: (_) {
                    // Clear error when user starts typing
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                ),

                // Error Text
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  CommonText(
                    _errorText!,
                    fontSize: 14,
                    color: AppColors.error,
                    textAlign: TextAlign.center,
                  ),
                ],

                SizedBox(height: isMobile ? 20 : 32),
                CustomUnderLineButtonWidget(
                  title: context.translate("continue"),
                  onTap: isLoading ? () {} : _handleVerify,
                  fontSize: 14,
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                CustomUnderLineButtonWidget(
                  title: context.translate("sign_to_a_different_account"),
                  onTap: isLoading
                      ? () {}
                      : () {
                          // Close dialog and return false to indicate not successful
                          context.pop(false);
                        },
                  fontSize: 14,
                  width: double.infinity,
                  isDark: true,
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
                          text: localizations?.translate('2fa_support_text') ??
                              'If you do not have your security code, please ',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.onSurface.withValues(alpha: 0.6),
                          )),
                      TextSpan(
                        text: localizations?.translate('contact_support') ??
                            'contact support',
                        style: TextStyle(
                          color: context.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDialogHeight() {
    final ctx = _boxKey.currentContext;
    if (ctx == null) return;

    final renderBox = ctx.findRenderObject() as RenderBox;
    final height = renderBox.size.height; // <-- widget height
    debugPrint('height: $height');
    return height;
  }
}

/// Extension to show 2FA login verification dialog
extension TwoFactorLoginDialogExtension on BuildContext {
  /// Show 2FA login verification dialog
  Future<bool?> show2FALoginVerificationDialog({
    required int userId,
    VoidCallback? onSuccess,
  }) {
    return showManagePopup<bool>(
      barrierDismissible: false,
      child: TwoFactorLoginVerificationDialog(
        userId: userId,
        onSuccess: onSuccess,
      ),
    );
    // return showDialog<bool>(
    //   context: this,
    //   barrierDismissible: false,
    //   builder: (context) => widget(
    //     child: CustomPointerInterceptor(
    //       child: TwoFactorLoginVerificationDialog(
    //         userId: userId,
    //         onSuccess: onSuccess,
    //       ),
    //     ),
    //   ),
    // );
  }
}
