import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';

class HomeFeaturesSection extends StatelessWidget {
  const HomeFeaturesSection({super.key});

  List<dynamic> get _featureItemsData {
    return [
      {
        'image': 'assets/images/features/features_1.png',
        'title': 'Claim Faucet',
        'description': 'Next Faucet\n[03:52:21]'
      },
      {
        'image': 'assets/images/features/features_2.png',
        'title': 'Treasure Chest',
        'description': 'Up to [\$2,000]'
      },
      {
        'image': 'assets/images/features/features_3.png',
        'title': 'fortune Wheel',
        'description': 'Up to [\$2,000]'
      },
      {
        'image': 'assets/images/features/features_4.png',
        'title': 'Surveys',
      },
      {
        'image': 'assets/images/features/features_5.png',
        'title': 'Exchanger',
      },
      {
        'image': 'assets/images/features/features_6.png',
        'title': 'Play Game App',
      },
      {
        'image': 'assets/images/features/features_7.png',
        'title': 'Watch Videos',
      },
      {
        'image': 'assets/images/features/features_8.png',
        'title': 'Visit Websites',
      },
      {
        'image': 'assets/images/features/features_9.png',
        'title': 'Pirate Treasure Hunt',
      },
      {
        'image': 'assets/images/features/features_10.png',
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
          fit: BoxFit.fitWidth,
          alignment: Alignment(0, -0.5),
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
                    return featuresItemWidget(feature, context);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox featuresItemWidget(feature, BuildContext context) {
    return SizedBox(
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
    );
  }
}
