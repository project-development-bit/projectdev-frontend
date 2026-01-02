import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_loading_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart' show MediaQueryExtension, AppColors;
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/core/widgets/cloudflare_turnstille_widgte.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/collect_treasure_hunt_notifier_state.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/uncover_treasure_state.dart';
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

class PirateTresureFoundDialog extends ConsumerStatefulWidget {
  const PirateTresureFoundDialog({super.key});
  @override
  ConsumerState<PirateTresureFoundDialog> createState() =>
      _PirateTresureFoundDialogState();
}

class _PirateTresureFoundDialogState
    extends ConsumerState<PirateTresureFoundDialog> {
  static const double designWidth = 630;
  static const double designHeight = 878;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(uncoverTreasureNotifierProvider.notifier).uncover();
    });
    ref.listenManual<CollectTreasureHuntNotifierState>(
        collectTreasureHuntNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next.status == CollectTreasureHuntNotifierStatus.success) {
        context.pop();
        context.showSnackBar(
            message:
                next.data?.message ?? context.translate('reward_collected'),
            backgroundColor: AppColors.success);
      } else if (next.status == CollectTreasureHuntNotifierStatus.error) {
        // Show error message
        context.showSnackBar(
            message: next.data?.message ??
                next.error ??
                context.translate('something_went_wrong'),
            backgroundColor: Theme.of(context).colorScheme.error);
      }
    });

    ref.listenManual<UncoverTreasureState>(uncoverTreasureNotifierProvider,
        (previous, next) {
      if (!mounted) return;
      if (next.status == UncoverTreasureStatus.success) {
        celebrationSound();
      }
    });
  }

  Future<void> celebrationSound() async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource('sound/box_award_sound.mp3'));
    await audioPlayer.resume();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
      child: SizedBox(
        width: designWidth,
        child: _DialogContent(),
      ),
    );
  }
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent();
  static const double designHeight = 878;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unCoverState = ref.watch(uncoverTreasureNotifierProvider);
    final collectState = ref.watch(collectTreasureHuntNotifierProvider);

    return Stack(
      children: [
        SafeArea(
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
                    context.translate("treasure_hunt_completed"),
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: TreasureFoundBoardWidget(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  CommonText.titleMedium(
                    context.translate('next_hunt_unlocks_in',
                        args: [unCoverState.countDownUntilNow()]),
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CloudflareTurnstileWidget(
                    action: TurnstileActionEnum.treasureHunt,
                    debugMode: false,
                  ),
                  const SizedBox(height: 24),
                  CustomUnderLineButtonWidget(
                    onTap: () {
                      final turnstileState = ref.read(turnstileNotifierProvider(
                          TurnstileActionEnum.treasureHunt));
                      if (turnstileState is! TurnstileSuccess) {
                        context.showErrorSnackBar(
                          message:
                              context.translate('captcha_required_to_claim'),
                        );
                        return;
                      }
                      ref
                          .read(collectTreasureHuntNotifierProvider.notifier)
                          .collect(
                            turnstileToken: turnstileState.token,
                          );
                    },
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    title: context.translate("collect_reward"),
                  ),
                  const SizedBox(height: 57),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: collectState.isLoading,
          child: Container(
              height: context.isMobile ? 500 : designHeight,
              color: Colors.black.withValues(alpha: 150),
              child: Center(child: CommonLoadingWidget.medium())),
        )
      ],
    );
  }
}
