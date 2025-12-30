import 'package:gigafaucet/features/earnings/domain/entity/statistics_data.dart';
import 'statistics_category_model.dart';

class StatisticsDataModel extends StatisticsData {
  const StatisticsDataModel({
    required super.surveys,
    required super.gameApps,
    required super.offerwalls,
    required super.totalEarned,
    required super.period,
  });

  factory StatisticsDataModel.fromJson(Map<String, dynamic> json) {
    return StatisticsDataModel(
      surveys: StatisticsCategoryModel.fromJson(
          json['surveys'] as Map<String, dynamic>? ?? {}),
      gameApps: StatisticsCategoryModel.fromJson(
          json['gameApps'] as Map<String, dynamic>? ?? {}),
      offerwalls: StatisticsCategoryModel.fromJson(
          json['offerwalls'] as Map<String, dynamic>? ?? {}),
      totalEarned: json['totalEarned'] ?? 0,
      period: json['period'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'surveys': (surveys as StatisticsCategoryModel).toJson(),
        'gameApps': (gameApps as StatisticsCategoryModel).toJson(),
        'offerwalls': (offerwalls as StatisticsCategoryModel).toJson(),
        'totalEarned': totalEarned,
        'period': period,
      };
}
