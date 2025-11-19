import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/statistics_card.dart';
import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        StatCard(title: "Surveys", number: "14", totalEarn: "14"),
        StatCard(title: "Game Apps", number: "154", totalEarn: "1454"),
        StatCard(title: "Offerwalls", number: "40", totalEarn: "300"),
      ],
    );
  }
}
