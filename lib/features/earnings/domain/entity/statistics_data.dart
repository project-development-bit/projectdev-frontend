import 'package:equatable/equatable.dart';
import 'statistics_category.dart';

class StatisticsData extends Equatable {
  final StatisticsCategory surveys;
  final StatisticsCategory gameApps;
  final StatisticsCategory offerwalls;

  final int totalEarned;
  final String period;

  const StatisticsData({
    required this.surveys,
    required this.gameApps,
    required this.offerwalls,
    required this.totalEarned,
    required this.period,
  });

  @override
  List<Object?> get props =>
      [surveys, gameApps, offerwalls, totalEarned, period];
}
