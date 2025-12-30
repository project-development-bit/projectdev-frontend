import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/dialogs/pirate_tresure_found_dialog.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_actions_widget.dart';
import 'package:gigafaucet/routing/app_router.dart';

class UnlockYourTreasureWidget extends ConsumerWidget {
  const UnlockYourTreasureWidget({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final treasureHuntStatus = ref.watch(treasureHuntStatusNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleLarge(
          context.translate('unlock_your_treasure_title'),
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          fontSize: 32,
        ),
        const SizedBox(height: 16),
        CommonText.bodyMedium(
          context.translate(
            "unlock_your_treasure_description",
            args: [(treasureHuntStatus.data?.requiredTasks ?? 1).toString()],
          ),
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        PirateTreasureHuntActionsWidget(),
        SizedBox(height: 32),
        CustomUnderLineButtonWidget(
          isDark: true,
          onTap: () {
            if (treasureHuntStatus.isUncoverTreasureReady) {
              context.pop();
              showPirateTresureFoundDialog(context);
            } else if (treasureHuntStatus.isInProgress) {
              context.pop();
            } else {
              ref.read(startTreasureHuntNotifierProvider.notifier).start();
            }
          },
          fontSize: 14,
          fontWeight: FontWeight.w700,
          title: (treasureHuntStatus.isUncoverTreasureReady)
              ? context.translate("uncover_treasure")
              : (treasureHuntStatus.isInProgress)
                  ? context.translate("continue_hunt")
                  : context.translate("start_treasure_hunt"),
        )
      ],
    );
  }
}
