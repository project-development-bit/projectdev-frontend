import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';

class RewardLevelModel extends RewardLevel {
  const RewardLevelModel({
    required super.level,
    required super.xpRequired,
    required super.xpTotal,
    required super.tier,
    required super.tierRank,
    required super.dailySpin,
    required super.weeklyChest,
    required super.offerBoostPct,
    required super.ptcDiscountPct,
  });

  factory RewardLevelModel.fromJson(Map<String, dynamic> json) {
    return RewardLevelModel(
      level: json['level'],
      xpRequired: json['xp_required'],
      xpTotal: json['xp_total'],
      tier: json['tier'],
      tierRank: json['tier_rank'],
      dailySpin: json['daily_spin'],
      weeklyChest: json['weekly_chest'],
      offerBoostPct: json['offer_boost_pct'],
      ptcDiscountPct: json['ptc_discount_pct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'xp_required': xpRequired,
      'xp_total': xpTotal,
      'tier': tier,
      'tier_rank': tierRank,
      'daily_spin': dailySpin,
      'weekly_chest': weeklyChest,
      'offer_boost_pct': offerBoostPct,
      'ptc_discount_pct': ptcDiscountPct,
    };
  }
}
