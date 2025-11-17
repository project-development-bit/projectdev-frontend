import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';

import 'event_daily_streak_widget.dart';
import 'event_info_widget.dart';
import 'join_crypto_event_widget.dart';

class HomeEventSection extends StatelessWidget {
  const HomeEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSectionContainer(
      width: double.infinity,
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
    );
  }
}
