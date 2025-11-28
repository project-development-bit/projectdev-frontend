import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_statistics_state.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/get_earnings_statistics_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(earningsStatisticsNotifierProvider);
    final notifier = ref.read(earningsStatisticsNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.status == EarningsStatisticsStatus.initial) {
        notifier.fetchStatistics(const EarningsStatisticsRequest());
      }
    });

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
