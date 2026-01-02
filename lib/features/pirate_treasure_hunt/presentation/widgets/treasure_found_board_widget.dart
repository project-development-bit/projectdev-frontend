import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart'
    show LocalizationExtension;
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';

class TreasureFoundBoardWidget extends ConsumerWidget {
  const TreasureFoundBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unCoverState = ref.watch(uncoverTreasureNotifierProvider);

    return Container(
      width: 461,
      height: 314,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppLocalImages.treasureFoundBoard),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 130),
          if (unCoverState.isCoinTypeReward)
            CommonText.titleMedium(
              context.translate(
                '+${unCoverState.data?.reward?.baseValue ?? 0}',
              ),
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              fontSize: 20,
              color: Color(0xFF00131E),
            ),
          CommonText.titleMedium(
            context.translate(
              unCoverState.formatTreasureReward,
            ),
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            fontSize: 20,
            color: Color(0xFF00131E),
          ),
          if (unCoverState.isCoinTypeReward)
            CommonText.titleMedium(
              context.translate('treasure_final_reward',
                  args: ['${unCoverState.data?.reward?.finalValue ?? 0}']),
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              fontSize: 20,
              color: Color(0xFF00131E),
            ),
        ],
      ),
    );
  }
}
