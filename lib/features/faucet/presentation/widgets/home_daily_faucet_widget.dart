import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDailyFaucetWidget extends ConsumerWidget {
  const HomeDailyFaucetWidget({super.key, required this.isColumn});
  final bool isColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff333333)),
      ),
      padding: const EdgeInsets.all(22.0),
      child: Column(children: [
        _eventTitleWidget(context, isColumn),
        SizedBox(height: 17),
        _eventNextFaucetWidget(context, isColumn),
        SizedBox(height: 17),
        CommonText.titleLarge(
          context.translate("event_daily_streak_faucet"),
          fontSize: 20.0,
        ),
        CommonText.bodyLarge(
          context.translate("event_earn_coins_continue_streak"),
          color: Colors.white,
        ),
        SizedBox(height: 24),
        _eventProgressBar(context, isColumn),
        SizedBox(height: 24),
        _eventDayListWidget(context),
        SizedBox(height: 16),
        CommonText.bodyLarge(
          context.translate("event_daily_streak_resets", args: ["21"]),
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ]),
    );
  }

  Widget _eventProgressBar(BuildContext context, bool isColumn) {
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
                  highlightColor: context.primary,
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
                  highlightColor: context.primary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          SizedBox(
            height: context.isMobile ? 80 : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("300"),
                Image.asset(
                  'assets/images/rewards/coin.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventDayListWidget(BuildContext context) {
    final scrollController = ScrollController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.5).copyWith(),
      child: Scrollbar(
        controller: scrollController,
        thickness: 2,
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
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

  Widget _eventTitleWidget(BuildContext context, bool isColumn) {
    return Flex(
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleMedium(context.translate('event_actual_faucet'),
            fontWeight: FontWeight.w700),
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
                'assets/images/rewards/coin.png',
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
        CommonText.titleMedium(
          context.translate("event_every_hours", args: ["4"]),
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _eventNextFaucetWidget(BuildContext context, bool isColumn) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1A1A1A),
        border: Border.all(color: Color(0xff262626)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText.titleMedium(
            context.translate('event_next_faucet'),
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.0),
          Row(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _eventTime(context,
                    time: "03", unit: context.translate("event_hours")),
                _eventTime(context,
                    time: "24", unit: context.translate("event_minutes")),
                _eventTime(context,
                    time: "42", unit: context.translate("event_seconds")),
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

  Widget _eventDayItemWidget(
    BuildContext context, {
    required String day,
    required String coins,
    bool isActive = false,
  }) {
    return Container(
      decoration: isActive
          ? DottedDecoration(
              color: context.primary,
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
              context
                  .translate("event_day", args: [day.replaceAll("Day ", "")]),
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
                  'assets/images/rewards/coin.png',
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
}
