import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart' show MediaQueryExtension;
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/core/widgets/cloudflare_turnstille_widgte.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/treasure_found_board_widget.dart';
import 'package:gigafaucet/routing/app_router.dart' show GoRouterExtension;

import '../../../../../core/extensions/context_extensions.dart'
    show DialogExtension;

void showPirateTresureFoundDialog(
  BuildContext context,
) {
  context.showManagePopup(
    child: PirateTresureFoundDialog(),
    barrierDismissible: true,
  );
}

class PirateTresureFoundDialog extends StatelessWidget {
  const PirateTresureFoundDialog({super.key});

  static const double designWidth = 630;
  static const double designHeight = 878;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Container(
      width: designWidth,
      height: isMobile ? 500 : designHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(AppLocalImages.treasureFoundBg),
          fit: BoxFit.fill,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: SizedBox(
                width: designWidth,
                child: _DialogContent(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              CommonImage(
                imageUrl: AppLocalImages.treasureFoundTitle,
                width: 362,
                height: 171,
              ),
              const SizedBox(height: 26),
              CommonText.bodyMedium(
                "You’ve completed this hunt.",
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              TreasureFoundBoardWidget(),
              const SizedBox(height: 26),
              CommonText.titleMedium(
                context.translate(
                  'Next Hunt Unlocks In - [3 Days 12 hours]',
                ),
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CloudflareTurnstileWidget(
                action: TurnstileActionEnum.faucetClaim,
                debugMode: false,
              ),
              const SizedBox(height: 24),
              CustomUnderLineButtonWidget(
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
                  context.pop();
                },
                fontSize: 14,
                fontWeight: FontWeight.w700,
                title: context.translate("Collect Reward"),
              ),
              const SizedBox(height: 57),
            ],
          ),
        ),
      ),
    );
  }
}
