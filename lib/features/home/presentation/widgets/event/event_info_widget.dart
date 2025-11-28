import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class EventInfoWidget extends StatelessWidget {
  const EventInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallSize = context.isMobile || context.isTablet;
    return Flex(
      direction: isSmallSize ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      spacing: isSmallSize ? 10 : 32,
      children: [
        Flexible(
          flex: isSmallSize ? 1 : 2,
          child: _eventStatusWidget(context, isSmallSize),
        ),
        Flexible(flex: 1, child: _moreEventWidget(context, isSmallSize))
      ],
    );
  }

  Widget _eventStatusWidget(BuildContext context, bool isSmallSize) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Flex(
        direction:
            isSmallSize && context.isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        spacing: isSmallSize ? 10 : 18,
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20),
                right: isSmallSize ? Radius.circular(20) : Radius.circular(0),
              ),
              child: Image.asset(
                'assets/images/event_poster_image.png',
                width: double.infinity,
                height: isSmallSize ? null : 370,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
              child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CommonText.titleLarge(
                    context.translate("event_info_widget_title_text"),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff7E7E81),
                  ),
                ),
                Center(
                  child: CommonText.titleMedium(
                      context.translate("event_info_widget_subtitle_text"),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: isSmallSize ? 10 : 24,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _eventTimeWidget(
                        context, "28", context.translate("event_days")),
                    _eventTimeWidget(
                        context, "17", context.translate("event_hours")),
                    _eventTimeWidget(
                        context, "32", context.translate("event_minutes")),
                    _eventTimeWidget(
                        context, "20", context.translate("event_seconds")),
                  ],
                ),
                SizedBox(height: 32),
                CommonText.titleMedium(
                    context.translate("event_your_progression"),
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.78,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                ),
                SizedBox(height: 16),
                CommonText.titleMedium(
                  context.translate("event_cases_remained", args: ["18"]),
                  highlightColor: context.primary,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 16),
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
          ))
        ],
      ),
    );
  }

  Widget _eventTimeWidget(BuildContext context, String title, String time) {
    return Column(
      spacing: 4.0,
      children: [
        Center(
          child: CommonText.titleMedium(
            title,
            color: context.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Center(
          child: CommonText.titleMedium(
            time,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _moreEventWidget(BuildContext context, bool isSmallSize) {
    return Flex(
      direction: isSmallSize ? Axis.horizontal : Axis.vertical,
      spacing: 16,
      children: [
        _moreEventItemWidget(
            context: context,
            image: 'assets/images/event_visit_shop.png',
            title: context.translate("event_visit_shop"),
            isSmallSize: isSmallSize),
        _moreEventItemWidget(
            context: context,
            image: 'assets/images/event_our_quest_today.png',
            title: context.translate("event_our_quests_today"),
            isSmallSize: isSmallSize),
      ],
    );
  }

  Widget _moreEventItemWidget(
      {required BuildContext context,
      required String image,
      required String title,
      required bool isSmallSize}) {
    final widget = SizedBox(
      height: isSmallSize ? null : 175,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 175,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                ),
                child: Center(
                  child: CommonText.titleLarge(
                    title,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    if (isSmallSize) {
      return Expanded(child: widget);
    } else {
      return widget;
    }
  }
}
