import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_statistics_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/statistics_card.dart';
import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key, required this.state});
  final EarningsStatisticsState state;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    switch (state.status) {
      case EarningsStatisticsStatus.loading:
        return const _StatisticsLoading();

      case EarningsStatisticsStatus.error:
        return Center(
          child: CommonText.bodyMedium(
            state.error ?? "Something went wrong",
            color: Theme.of(context).colorScheme.error,
          ),
        );

      case EarningsStatisticsStatus.data:
        final data = state.data!;
        return Column(
          children: [
            StatCard(
              title: localizations?.translate("stat_surveys") ?? "Surveys",
              number: "${data.data?.surveys.count}",
              totalEarn: "${data.data?.surveys.totalEarned}",
            ),
            StatCard(
              title: localizations?.translate("stat_game_apps") ?? "Game Apps",
              number: "${data.data?.gameApps.count}",
              totalEarn: "${data.data?.gameApps.totalEarned}",
            ),
            StatCard(
              title:
                  localizations?.translate("stat_offerwalls") ?? "Offerwalls",
              number: "${data.data?.offerwalls.count}",
              totalEarn: "${data.data?.offerwalls.totalEarned}",
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _StatisticsLoading extends StatelessWidget {
  const _StatisticsLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
