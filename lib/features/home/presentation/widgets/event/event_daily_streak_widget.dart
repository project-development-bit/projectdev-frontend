import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/home_daily_faucet_widget.dart';
import 'package:flutter/material.dart';

class EventDailyStreakWidget extends StatelessWidget {
  const EventDailyStreakWidget({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    final isColumn = context.isMobile || context.isTablet;
    return Flex(
      spacing: 41,
      mainAxisSize: MainAxisSize.min,
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      children: [
        Flexible(
            child: SizedBox(
                height: isColumn ? null : 600,
                child: HomeDailyFaucetWidget(isColumn: isColumn))),
        Flexible(
          child: SizedBox(
            height: isColumn ? null : 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 41,
              children: [
                Flexible(flex: 3, child: _eventRewardWidget(context, isColumn)),
                Flexible(
                    flex: 5, child: _invitationUserInfo(context, isColumn)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _eventTime(BuildContext context,
      {required String time, required String unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleLarge(
          time,
          fontSize: 20,
          color: context.primary,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 4),
        CommonText.titleSmall(
          unit,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _eventRewardWidget(BuildContext context, bool isColumn) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        image: DecorationImage(
          image: AssetImage(AppLocalImages.eventDailyStreakBg),
          alignment: Alignment(0, 0),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: isColumn
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              .copyWith(bottom: 25)
          : const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Flex(
            direction: isColumn ? Axis.vertical : Axis.horizontal,
            spacing: 11.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText.titleLarge(
                "\$250",
                highlightColor: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
              CommonText.titleMedium(
                context.translate("event_daily_contest_reward"),
                fontWeight: FontWeight.w700,
                color: context.primary,
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              border: Border.all(color: Color(0xff262626)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: isColumn ? MainAxisSize.max : MainAxisSize.min,
              spacing: 11,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _eventTime(context,
                    time: "03", unit: context.translate("event_days")),
                _eventTime(context,
                    time: "24", unit: context.translate("event_hours")),
                _eventTime(context,
                    time: "42", unit: context.translate("event_minutes")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _invitationUserInfo(BuildContext context, bool isColumn) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: isColumn
          ? const EdgeInsets.symmetric(horizontal: 17.5, vertical: 19.5)
          : const EdgeInsets.symmetric(horizontal: 14.0, vertical: 24.5),
      child: Column(
        children: [
          Image.asset(
            AppLocalImages.eventTreasureBox,
            width: 100,
            height: 100,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              spacing: isColumn ? 14 : 10,
              children: [
                CommonText.titleMedium(
                  context.translate("event_invite_friends_win_coins"),
                  color: Color(0xff98989A),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisSize: isColumn ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: isColumn ? 20 : 170,
                  children: [
                    CommonText.titleLarge(
                      context.translate("event_total", args: ["17"]),
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      highlightColor: context.primary,
                    ),
                    Column(
                      children: [
                        CommonText.titleLarge(
                          context.translate("event_earned"),
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            CommonText.titleLarge(
                              "[12,678]",
                              color: Colors.white,
                              textAlign: TextAlign.center,
                              fontSize: 20,
                              highlightColor: context.primary,
                            ),
                            Image.asset(
                              AppLocalImages.coin,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                CustomUnderLineButtonWidget(
                  width: 180,
                  fontSize: 16,
                  isDark: true,
                  fontWeight: FontWeight.w700,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  margin: const EdgeInsets.symmetric(vertical: 8.5),
                  title: context.translate("event_more_details"),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
