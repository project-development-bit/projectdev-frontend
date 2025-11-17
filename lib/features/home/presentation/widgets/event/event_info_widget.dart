import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
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
      spacing: 32,
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
        spacing: 18,
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
                    color: Color(0xff7E7E81),
                  ),
                ),
                Center(
                  child: CommonText.titleMedium(
                      context.translate("event_info_widget_subtitle_text"),
                      fontSize: 16,
                      color: Colors.white),
                ),
                SizedBox(height: 24),
                Flex(
                  direction: isSmallSize ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _eventTimeWidget(context, "28", "days"),
                    _eventTimeWidget(context, "17", "hours"),
                    _eventTimeWidget(context, "32", "minutes"),
                    _eventTimeWidget(context, "20", "seconds"),
                  ],
                ),
                SizedBox(height: 32),
                CommonText.titleMedium("Your progression"),
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
                  "[18]cases remained",
                  highlightColor: context.secondary,
                ),
                SizedBox(height: 16),
                CommonButton(
                    text: "More Details",
                    backgroundColor: Color(0xff333333),
                    fontSize: 14,
                    textColor: Color(0xff98989A),
                    onPressed: () {})
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _eventTimeWidget(BuildContext context, String title, String time) {
    return Column(
      children: [
        Center(
          child: CommonText.titleMedium(title, color: context.secondary),
        ),
        Center(
          child: CommonText.titleMedium(
            time,
            color: Colors.white,
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
            image: 'assets/images/event_visit_shop.png',
            title: "Visit The Shop",
            isSmallSize: isSmallSize),
        _moreEventItemWidget(
            image: 'assets/images/event_our_quest_today.png',
            title: "Our Quests Today!",
            isSmallSize: isSmallSize),
      ],
    );
  }

  Widget _moreEventItemWidget(
      {required String image,
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
