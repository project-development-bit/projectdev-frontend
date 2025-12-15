import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
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
      decoration: BoxDecoration(
        image: context.isMobile
            ? DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: Alignment(0, -1.5),
                image:
                    AssetImage(AppLocalImages.homeCoinBackgroundSection2Mobile),
              )
            : null,
      ),
      child: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: 1240),
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: isSmallSize
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                CommonText.titleLarge(
                  context.isMobile
                      ? context.translate(
                          'home_level_and_reward_section_title_mobile')
                      : context
                          .translate('home_level_and_reward_section_title'),
                  fontWeight: FontWeight.w700,
                  textAlign: isSmallSize ? TextAlign.start : TextAlign.center,
                  fontSize: 40,
                ),
                SizedBox(height: isSmallSize ? 16 : 42),
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
      padding: isSmallSize
          ? EdgeInsets.all(16)
          : EdgeInsets.symmetric(horizontal: 10, vertical: 34),
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
          AppLocalImages.whale,
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
      padding: isSmallSize
          ? EdgeInsets.all(16)
          : EdgeInsets.symmetric(horizontal: 31, vertical: 33.5),
      child: Column(
        children: [
          CommonText.titleLarge(
            context.translate('home_reward_widget_title'),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            maxLines: 2,
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
                      AppLocalImages.offerBoostReward,
                      width: 41,
                    ),
                    SizedBox(width: 14),
                    CommonText.titleLarge(
                      '[78] %',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      highlightColor: context.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonText.bodyLarge(
                        context.translate('home_reward_boost_and_serveys_text'),
                        fontWeight: FontWeight.w700,
                        color: Color(0xff98989A),
                        maxLines: 2,
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
                      AppLocalImages.shopDiscount,
                      width: 41,
                    ),
                    SizedBox(width: 14),
                    CommonText.titleLarge(
                      '[+24%]',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      highlightColor: context.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonText.bodyLarge(
                          context.translate('home_reward_discount_text'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 34),
          Center(
            child: CustomUnderLineButtonWidget(
              width: 180,
              fontSize: 16,
              isDark: true,
              fontWeight: FontWeight.w700,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              margin: const EdgeInsets.symmetric(vertical: 8.5),
              title: context.translate("level_stat_widget_button_text"),
              onTap: () {},
            ),
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
                AppLocalImages.shieldIcon,
                width: 32,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonText.titleMedium(
                      "[78] %",
                      fontWeight: FontWeight.w700,
                      highlightColor: context.primary,
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
                      context.translate('xp_points_to_next_level',
                          args: ['2,452']),
                      fontWeight: FontWeight.w700,
                      highlightColor: context.primary,
                      textAlign: TextAlign.center,
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
            child: CustomUnderLineButtonWidget(
              width: 180,
              fontSize: 16,
              isDark: true,
              fontWeight: FontWeight.w700,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              margin: const EdgeInsets.symmetric(vertical: 8.5),
              title: context.translate("level_stat_widget_button_text"),
              onTap: () {},
            ),
          )
        ]);
  }
}
