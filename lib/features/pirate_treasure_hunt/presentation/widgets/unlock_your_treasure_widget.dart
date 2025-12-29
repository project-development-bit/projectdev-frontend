import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_actions_widget.dart';

class UnlockYourTreasureWidget extends StatelessWidget {
  const UnlockYourTreasureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleLarge(
          context.translate('Unlock [Your Treasure]'),
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          fontSize: 32,
        ),
        const SizedBox(height: 16),
        CommonText.bodyMedium(
          context
              .translate('Complete [1] task to uncover the hidden treasure.'),
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        PirateTreasureHuntActionsWidget(),
        SizedBox(height: 32),
        CustomUnderLineButtonWidget(
          isDark: true,
          onTap: () {},
          fontSize: 14,
          fontWeight: FontWeight.w700,
          title: context.translate("Start Treasure Hunt"),
        )
      ],
    );
  }
}
