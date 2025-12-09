import 'package:cointiply_app/features/reward/domain/entities/sub_level.dart';

class SubLevelModel extends SubLevel {
  const SubLevelModel({
    required super.id,
    required super.label,
    required super.minLevel,
    required super.dailySpinFree,
    required super.weeklyChestFree,
    required super.offerBoostPercent,
    required super.ptcDiscountPercent,
  });

  factory SubLevelModel.fromJson(Map<String, dynamic> json) {
    return SubLevelModel(
      id: json['id'] ?? "",
      label: json['label'] ?? "",
      minLevel: json['min_level'] ?? "",
      dailySpinFree: json['daily_spin_free'] ?? "",
      weeklyChestFree: json['weekly_chest_free'] ?? "",
      offerBoostPercent: json['offer_boost_percent'] ?? "",
      ptcDiscountPercent: json['ptc_discount_percent'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'min_level': minLevel,
        'daily_spin_free': dailySpinFree,
        'weekly_chest_free': weeklyChestFree,
        'offer_boost_percent': offerBoostPercent,
        'ptc_discount_percent': ptcDiscountPercent,
      };
}
