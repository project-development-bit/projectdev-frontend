import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/disable_2fa_provider.dart';
import '../providers/check_2fa_status_provider.dart';

void showDisable2FAConfirmationDialog(BuildContext context,
    {required Function() onDisabled}) {
  context.showManagePopup(
    height: context.isMobile ? 400 : 350,
    child: Disable2FAConfirmationDialog(onDisabled: onDisabled),
    barrierDismissible: true,
    title: context.translate("disable_2fa_title"),
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
            textColor: Colors.white,
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

  void _handleDisable2FA() {
    ref.read(disable2FAProvider.notifier).disable2FA();
  }

  @override
  Widget build(BuildContext context) {
    final disable2FAState = ref.watch(disable2FAProvider);
    final isDisabling = disable2FAState is Disable2FALoading;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

            const SizedBox(height: 32),

            // Action buttons
            Flex(
              direction: context.isMobile ? Axis.vertical : Axis.horizontal,
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
                  width: context.isMobile ? double.infinity : 233,
                  padding: EdgeInsets.symmetric(
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
                  fontColor: Color(0xff98989A),
                  isRed: true,
                  width: context.isMobile ? double.infinity : 233,
                    isLoading: isDisabling,
                  padding: EdgeInsets.symmetric(
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
    );
  }
}
