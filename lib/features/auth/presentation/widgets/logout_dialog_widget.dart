import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/auth/presentation/providers/logout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

showLogoutDialog(BuildContext context) {
  context.showManagePopup(
    child: const LogoutDialogWidget(),
    barrierDismissible: false,
  );
}

class LogoutDialogWidget extends ConsumerStatefulWidget {
  const LogoutDialogWidget({super.key});

  @override
  ConsumerState<LogoutDialogWidget> createState() => _LogoutDialogWidgetState();
}

class _LogoutDialogWidgetState extends ConsumerState<LogoutDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(logoutNotifierProvider) is LogoutLoading;

    return DialogBgWidget(
        dialogWidth: 400,
        isOverlayLoading: isLoading,
        dialogHeight: context.isDesktop ? 250 : 240,
        body: _dialogBody(),
        title: context.translate("logout_title"));
  }

  Widget _dialogBody() {
    return Padding(
      padding: context.isMobile
          ? const EdgeInsetsGeometry.symmetric(vertical: 28, horizontal: 15.5)
          : const EdgeInsets.symmetric(vertical: 21.0, horizontal: 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText.bodyMedium(
            context.translate("logout_description"),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.isMobile ? 28 : 32,
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: CustomUnderLineButtonWidget(
                    title: context.translate("cancel"),
                    width: double.infinity,
                    isDark: true,
                    fontSize: 14,
                    onTap: () {
                      context.pop();
                    }),
              ),
              Expanded(
                child: CustomUnderLineButtonWidget(
                    title: context.translate("logout"),
                    isRed: true,
                    width: double.infinity,
                    fontSize: 14,
                    onTap: () async {
                      await ref.read(logoutNotifierProvider.notifier).logout();
                      final logoutState = ref.read(logoutNotifierProvider);
                      if (mounted) {
                        if (logoutState is LogoutSuccess) {
                          if (context.mounted) {
                            context.showSnackBar(
                                message: context.translate('logout_successful'),
                                backgroundColor: Colors.green);
                          }
                        } else if (logoutState is LogoutError) {
                          // Show error message
                          if (context.mounted) {
                            context.showSnackBar(
                              message: logoutState.message,
                              backgroundColor: context.error,
                            );
                          }
                        }
                        context.pop();
                      }
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
