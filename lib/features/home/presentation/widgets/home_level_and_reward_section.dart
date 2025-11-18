import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

import 'home_section_container.dart';

class HomeLevelAndRewardSection extends StatelessWidget {
  const HomeLevelAndRewardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallSize = context.isMobile || context.isTablet;
    return HomeSectionContainer(
      width: double.infinity,
      child: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: 1240),
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                CommonText.titleLarge(
                  context.translate('home_level_and_reward_section_title'),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  fontSize: 40,
                ),
                SizedBox(height: 42),
                SizedBox(
                  height: isSmallSize ? null : 300,
                  child: Flex(
                    direction: isSmallSize ? Axis.vertical : Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 30,
                    children: [
                      Flexible(child: _levelWidget(context, isSmallSize)),
                      Flexible(child: _rewardWidget(context, isSmallSize)),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _levelWidget(BuildContext context, bool isSmallSize) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface.withAlpha(127),
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 34),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Flex(
          direction: isSmallSize ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileWidget(context),
            SizedBox(width: 27),
            Flexible(child: _levelStatWidget(context, isSmallSize)),
          ],
        ),
      ),
    );
  }

  ClipRRect _profileWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: context.primary.withAlpha(127),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: context.secondary, width: 5),
        ),
        child: Image.asset(
          'assets/images/levels/whale.png',
          width: 83,
          height: 83,
        ),
      ),
    );
  }

  Container _rewardWidget(BuildContext context, bool isSmallSize) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface.withAlpha(127),
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 31, vertical: 33.5),
      child: Column(
        children: [
          CommonText.titleLarge(
            context.translate('home_reward_widget_title'),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          SizedBox(height: 34),
          Flex(
            direction: isSmallSize ? Axis.vertical : Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/rewards/offer_boost_reward.png',
                      width: 41,
                    ),
                    SizedBox(width: 14),
                    CommonText.titleLarge(
                      '[78] %',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      highlightColor: context.secondary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonText.bodyLarge(
                        context.translate('home_reward_boost_and_serveys_text'),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: isSmallSize ? 40 : 1,
                height: isSmallSize ? 1 : 40,
                margin: isSmallSize
                    ? EdgeInsets.symmetric(vertical: 20)
                    : EdgeInsets.symmetric(horizontal: 20),
                color: Color(0xff333333),
              ),
              Flexible(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/rewards/shop_discount.png',
                      width: 41,
                    ),
                    SizedBox(width: 14),
                    CommonText.titleLarge(
                      '[+24%]',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      highlightColor: context.secondary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonText.bodyLarge(
                        context.translate('home_reward_discount_text'),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 34),
          Center(
            child: CommonButton(
                text: context.translate("level_stat_widget_button_text"),
                onPressed: () {}),
          )
        ],
      ),
    );
  }

  Widget _levelStatWidget(BuildContext context, bool isSmallSize) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isSmallSize ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          CommonText.titleMedium(
            'Jack',
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 8),
          Row(
            spacing: 20.0,
            children: [
              Image.asset(
                'assets/images/rewards/shield_icon.png',
                width: 32,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      "[78] %",
                      fontWeight: FontWeight.w700,
                      highlightColor: context.secondary,
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.78,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(20),
                      backgroundColor: Colors.white.withAlpha(50),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(context.primary),
                    ),
                    SizedBox(height: 16),
                    CommonText.titleMedium(
                      "[2,452] XP points to next level",
                      fontWeight: FontWeight.w700,
                      highlightColor: context.secondary,
                    ),
                  ],
                ),
              ),
              CommonText.titleMedium(
                'Lvl\n20',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: 34),
          Center(
            child: CommonButton(
                text: context.translate("level_stat_widget_button_text"),
                onPressed: () {}),
          )
        ]);
  }
}
