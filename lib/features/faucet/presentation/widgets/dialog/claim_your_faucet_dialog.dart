import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/providers/turnstile_provider.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/core/widgets/cloudflare_turnstille_widgte.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/claim_faucet_notifier_provider.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/claim_faucet_state.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_scaffold_widget.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showClaimYourFaucetDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => DialogScaffoldWidget(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: ClaimYourFaucetDialog(onClaimTap: () {})),
  );
}

class ClaimYourFaucetDialog extends ConsumerStatefulWidget {
  const ClaimYourFaucetDialog({super.key, required this.onClaimTap});
  final Function onClaimTap;
  @override
  ConsumerState<ClaimYourFaucetDialog> createState() =>
      _YourFaucetDialogState();
}

class _YourFaucetDialogState extends ConsumerState<ClaimYourFaucetDialog> {
  int selectedTab = 0;

  @override
  void initState() {
    ref.listenManual<ClaimFaucetState>(claimFaucetNotifierProvider,
        (previous, next) {
      if (!mounted) return;
      switch (next.status) {
        case ClaimFaucetStatus.success:
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.translate("faucet_claimed_successfully")),
              backgroundColor: AppColors.success,
            ),
          );
          break;
        case ClaimFaucetStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? context.translate("unknown_error")),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserState = ref.watch(getFaucetNotifierProvider);
    final status = ref.watch(getFaucetNotifierProvider).status;
    final claimFaucetState = ref.watch(claimFaucetNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return DialogBgWidget(
      isOverlayLoading:
          currentUserState.isLoading || claimFaucetState.isLoading,
      dialogHeight:
          context.screenWidth <= 430 ? context.screenHeight * 0.9 : 500,
      title: context.translate("claim_your_faucet"),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: (context.isMobile || context.isTablet)
              ? const EdgeInsets.symmetric(
                  horizontal: 17,
                )
              : const EdgeInsets.symmetric(
                  horizontal: 31,
                ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CommonText.bodyMedium(
                context.translate(
                    "you_need_to_resolve_captcha_to_claim_your_faucet"),
                color: Color(0xFF98989A),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Flex(
                direction:
                    context.screenWidth < 365 ? Axis.vertical : Axis.horizontal,
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonText.headlineSmall(
                      context.translate('event_your_faucet'),
                      color: colorScheme.inversePrimary,
                      fontWeight: FontWeight.w700),
                  Container(
                    width: 130,
                    height: 40,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff100E1C),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xff333333))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText.headlineSmall(
                          "${status?.rewardPerClaim ?? 0}",
                          fontWeight: FontWeight.w700,
                          color: colorScheme.inversePrimary,
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          AppLocalImages.coin,
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            CloudflareTurnstileWidget(
              action: TurnstileActionEnum.faucetClaim,
              debugMode: false,
            ),
            SizedBox(height: 40),
            Center(
              child: CustomUnderLineButtonWidget(
                isDark: true,
                onTap: () {
                  final turnstileState = ref.read(turnstileNotifierProvider(
                      TurnstileActionEnum.faucetClaim));
                  if (turnstileState is! TurnstileSuccess) {
                    context.showErrorSnackBar(
                      message: context.translate(
                          'you_need_to_resolve_captcha_to_claim_your_faucet'),
                    );
                    return;
                  }
                  ref.read(claimFaucetNotifierProvider.notifier).claim();
                },
                fontSize: 14,
                fontWeight: FontWeight.w700,
                title: context.translate("claim_faucet"),
              ),
            ),
            SizedBox(height: 57),
          ]),
        ),
      ),
    );
  }
}
