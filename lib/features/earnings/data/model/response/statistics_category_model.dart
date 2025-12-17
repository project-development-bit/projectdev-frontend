import 'package:gigafaucet/features/earnings/domain/entity/statistics_category.dart';

class StatisticsCategoryModel extends StatisticsCategory {
  const StatisticsCategoryModel({
    required super.count,
    required super.totalEarned,
  });

  factory StatisticsCategoryModel.fromJson(Map<String, dynamic> json) {
    return StatisticsCategoryModel(
      count: json['count'] ?? 0,
      totalEarned: json['totalEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'totalEarned': totalEarned,
      };
}
