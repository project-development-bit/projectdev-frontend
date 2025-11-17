import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

class EventDailyStreakWidget extends StatelessWidget {
  const EventDailyStreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isColumn = context.isMobile || context.isTablet;
    return Flex(
      spacing: 41,
      mainAxisSize: MainAxisSize.min,
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      children: [
        Flexible(
            child: SizedBox(height: isColumn ? null: 600, child: _dailyStreakWidget(context,isColumn))),
        Flexible(
          child: SizedBox(
            height: isColumn ? null: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 41,
              children: [
                Flexible(flex: 3, child: _eventRewardWidget(context,isColumn)),
                Flexible(flex: 5, child: _invitationUserInfo(context,isColumn)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _dailyStreakWidget(BuildContext context,bool isColumn) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff333333)),
      ),
      padding: const EdgeInsets.all(22.0),
      child: Column(children: [
        _eventTitleWidget(isColumn),
        SizedBox(height: 17),
        _eventNextFaucetWidget(context,isColumn),
        SizedBox(height: 17),
        CommonText.titleLarge(
          "Daily Streak Faucet",
          fontSize: 20.0,
        ),
        CommonText.bodyLarge(
          "Earn Coins to Continue Your Streak",
          color: Colors.white,
        ),
        SizedBox(height: 24),
        _eventProgressBar(context),
        SizedBox(height: 24),
        _eventDayListWidget(context),
        SizedBox(height: 16),
        CommonText.bodyLarge(
          "Daily streak resets in 21 hours",
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ]),
    );
  }

  Widget _eventTitleWidget(bool isColumn) {
    return Flex(
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleMedium('Actual Faucet', fontWeight: FontWeight.w700),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
              color: Color(0xff100E1C),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xff333333))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.titleMedium(
                "14",
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
              SizedBox(width: 4),
              Image.asset(
                'assets/images/coin.png',
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
        CommonText.titleMedium(
          "Every 4 hours",
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _eventNextFaucetWidget(BuildContext context,bool isColumn) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1A1A1A).withAlpha(51),
        border: Border.all(color: Color(0xff262626)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText.titleMedium(
            'Next Faucet',
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.0),
          Flex(
            direction: isColumn? Axis.vertical :Axis.horizontal,
              spacing: 16.0,
              crossAxisAlignment: isColumn? CrossAxisAlignment.stretch: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _eventTime(context, time: "03", unit: "hours"),
                _eventTime(context, time: "24", unit: "minutes"),
                _eventTime(context, time: "42", unit: "seconds"),
                _eventTime(context, time: "42", unit: "seconds"),
              ]),
        ],
      ),
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
          color: context.secondary,
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

  Widget _eventProgressBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 53.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              spacing: 10.0,
              children: [
                CommonText.titleMedium(
                  "[78]%",
                  highlightColor: context.secondary,
                  fontWeight: FontWeight.w700,
                ),
                LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                ),
                CommonText.titleMedium(
                  "[2,452] XP points to next level",
                  highlightColor: context.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          CommonText.titleMedium("300"),
          Image.asset(
            'assets/images/coin.png',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _eventDayListWidget(BuildContext context) {
    final scrollController = ScrollController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.5),
      child: Scrollbar(
        controller: scrollController,
        thickness: 2,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12,
            children: [
              _eventDayItemWidget(context, day: "Day 1", coins: "50"),
              _eventDayItemWidget(context,
                  day: "Day 2", coins: "20", isActive: true),
              _eventDayItemWidget(context, day: "Day 3", coins: "40"),
              _eventDayItemWidget(context, day: "Day 4", coins: "30"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventDayItemWidget(
    BuildContext context, {
    required String day,
    required String coins,
    bool isActive = false,
  }) {
    return Container(
      decoration: isActive
          ? DottedDecoration(
              color: context.secondary,
              borderRadius: BorderRadius.circular(12),
              strokeWidth: 2,
              shape: Shape.box,
            )
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.5, vertical: 19.5),
        decoration: DottedDecoration(
          color: Color(0xff100E1C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CommonText.titleMedium(
              day,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium(
                  coins,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                SizedBox(width: 6),
                Image.asset(
                  'assets/images/coin.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventRewardWidget(BuildContext context,bool isColumn) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        image: DecorationImage(
          image: AssetImage('assets/images/trophy.png'),
          alignment: Alignment(0, 0),
          fit: BoxFit.cover,
        ),
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24.0),
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
              ),
              CommonText.titleMedium("daily contest reward",
                  color: context.secondary),
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
              mainAxisSize: MainAxisSize.min,
              spacing: 11,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _eventTime(context, time: "03", unit: "days"),
                _eventTime(context, time: "24", unit: "hours"),
                _eventTime(context, time: "42", unit: "minutes"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _invitationUserInfo(BuildContext context,bool isColumn) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 34.5),
      child: Column(
        children: [
          Image.asset(
            'assets/images/treasure_box.png',
            width: 100,
            height: 100,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              children: [
                CommonText.titleMedium(
                  "Invite your friends and win coins for lifetime!",
                  color: Color(0xff98989A),
                ),
                Flex(
                  direction: isColumn ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: isColumn ? 20: 170,
                  children: [
                    CommonText.titleLarge(
                      "Total\n[17]",
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      highlightColor: context.secondary,
                    ),
                     CommonText.titleLarge(
                      "Earning\n[12,678]",
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      highlightColor: context.secondary,
                    ),
                  ],
                ),
                CommonButton(text: "More Details",
                backgroundColor: Color(0xff333333),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                textColor: Color(0xff98989A),
                 onPressed: (){})
              ],
            ),
          )
        ],
      ),
    );
  }
}
