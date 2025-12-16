// import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showLoginRequiredDialog(BuildContext context,
    {required Function() onGoToLogin}) {
  context.showManagePopup(
    child: LoginRequiredDialog(onGoToLogin: onGoToLogin),
    barrierDismissible: true,
  );
}

class LoginRequiredDialog extends ConsumerStatefulWidget {
  final Function() onGoToLogin;
  const LoginRequiredDialog({super.key, required this.onGoToLogin});

  @override
  ConsumerState<LoginRequiredDialog> createState() =>
      _Disable2FAConfirmationDialogState();
}

class _Disable2FAConfirmationDialogState
    extends ConsumerState<LoginRequiredDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
      dialogHeight: context.isDesktop
          ? 450
          : context.isTablet
              ? 500
              : 610,
      title: context.translate("login_required"),
      body: SingleChildScrollView(
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
                context.translate('you_must_login_to_continue'),
                color: context.onSurface,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),

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
                    onTap: () {
                      context.pop();
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
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 8,
                    ),
                    height: 41,
                    onTap: () {
                      context.pop();
                      widget.onGoToLogin();
                    },
                    width: context.isMobile || context.isTablet
                        ? double.infinity
                        : 233,
                    fontSize: 14,
                    title: context.translate("login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
