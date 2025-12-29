import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart'
    show LocalizationExtension;

class TreasureFoundBoardWidget extends StatelessWidget {
  const TreasureFoundBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          CommonText.titleMedium(
            context.translate(
              '+300',
            ),
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            fontSize: 20,
            color: Color(0xFF00131E),
          ),
          CommonText.titleMedium(
            context.translate(
              'Gold Bonus x 1.2',
            ),
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            fontSize: 20,
            color: Color(0xFF00131E),
          ),
          CommonText.titleMedium(
            context.translate(
              'Final Reward : +360',
            ),
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
