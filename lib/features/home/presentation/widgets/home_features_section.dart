import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/claim_faucet.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/dialog/claim_your_faucet_dialog.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/dialog/your_faucet_dialog.dart';
import 'package:gigafaucet/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';

import '../../../fortune_wheel/presentation/widgets/fortune_wheel_widget.dart';

class HomeFeaturesSection extends StatelessWidget {
  const HomeFeaturesSection({super.key});

  List<dynamic> get _featureItemsData {
    return [
      {
        'image': AppLocalImages.features1,
        'title': 'Claim Faucet',
        'description': 'Next Faucet\n[03:52:21]'
      },
      {
        'image': AppLocalImages.features2,
        'title': 'Treasure Chest',
        'description': 'Up to [\$2,000]'
      },
      {
        'image': AppLocalImages.features3,
        'title': 'fortune Wheel',
        'description': 'Up to [\$2,000]'
      },
      {
        'image': AppLocalImages.features4,
        'title': 'Surveys',
      },
      {
        'image': AppLocalImages.features5,
        'title': 'Exchanger',
      },
      {
        'image': AppLocalImages.features6,
        'title': 'Play Game App',
      },
      {
        'image': AppLocalImages.features7,
        'title': 'Watch Videos',
      },
      {
        'image': AppLocalImages.features8,
        'title': 'Visit Websites',
      },
      {
        'image': AppLocalImages.features9,
        'title': 'Pirate Treasure Hunt',
      },
      {
        'image': AppLocalImages.features10,
        'title': 'Quests',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HomeSectionContainer(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: context.isDesktop ? BoxFit.contain : BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
          image: AssetImage(
            context.isMobile
                ? AppLocalImages.homeCoinBackgroundSection1Mobile
                : AppLocalImages.homeCoinBackgroundSection1Desktop,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1240),
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText.titleLarge(
                  context.translate('home_features_section_title'),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  fontSize: 40,
                ),
                SizedBox(height: 42),
                Wrap(
                  spacing: 20,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children: _featureItemsData.map((feature) {
                    if (feature['title'] == 'Claim Faucet') {
                      return ClaimFaucet();
                    }
                    return featuresItemWidget(feature, context, () {
                      if (feature['title'] == 'fortune Wheel') {
                        showFortuneWheelDialog(context);
                        return;
                      }
                      if (feature['title'] == 'Claim Faucet') {
                        // Show faucet dialog
                        // Assuming showYourFaucetDialog is defined elsewhere
                        showYourFaucetDialog(context, () {
                          showClaimYourFaucetDialog(context);
                        });
                      }
                    });
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget featuresItemWidget(feature, BuildContext context, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 190,
        child: Column(
          children: [
            SizedBox(
              width: 190,
              height: 190,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      feature['image'],
                      width: 190,
                      height: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (feature['description'] != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: CommonText.titleMedium(
                          feature['description'],
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          highlightFontSize: 24,
                          highlightColor: context.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            CommonText.labelMedium(
              feature['title'],
              fontWeight: FontWeight.w700,
              fontSize: 16,
              textAlign: TextAlign.center,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
