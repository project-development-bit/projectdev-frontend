import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';

import 'event_daily_streak_widget.dart';
import 'event_info_widget.dart';
import 'join_crypto_event_widget.dart';

class HomeEventSection extends StatelessWidget {
  const HomeEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeSectionContainer(
          width: double.infinity,
          decoration: context.isMobile
              ? null
              : BoxDecoration(
                  image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment(0, -0.85),
                  image: AssetImage(
                      AppLocalImages.homeCoinBackgroundSection4Desktop),
                )),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff00131E).withAlpha(127),
                  ),
                  child: Center(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 1240),
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: JoinCryptoEventWidget()),
                  )),
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1240),
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: EventInfoWidget(),
                ),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 1240),
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: EventDailyStreakWidget())
            ],
          ),
        ),
        if (context.isMobile)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment(0, -1.5),
                  image: AssetImage(
                      AppLocalImages.homeCoinBackgroundSection4Mobile),
                )),
              ),
            ),
          )
      ],
    );
  }
}
