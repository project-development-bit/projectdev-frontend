import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_level.g.dart';

@JsonSerializable()
class RewardLevel extends Equatable {
  final int level;

  @JsonKey(name: 'xp_required')
  final int xpRequired;

  @JsonKey(name: 'xp_total')
  final int xpTotal;

  final String tier;

  @JsonKey(name: 'tier_rank')
  final int tierRank;

  @JsonKey(name: 'daily_spin')
  final int dailySpin;

  @JsonKey(name: 'weekly_chest')
  final int weeklyChest;

  @JsonKey(name: 'offer_boost_pct')
  final int offerBoostPct;

  @JsonKey(name: 'ptc_discount_pct')
  final int ptcDiscountPct;

  const RewardLevel({
    required this.level,
    required this.xpRequired,
    required this.xpTotal,
    required this.tier,
    required this.tierRank,
    required this.dailySpin,
    required this.weeklyChest,
    required this.offerBoostPct,
    required this.ptcDiscountPct,
  });

  factory RewardLevel.fromJson(Map<String, dynamic> json) =>
      _$RewardLevelFromJson(json);

  Map<String, dynamic> toJson() => _$RewardLevelToJson(this);

  @override
  List<Object?> get props => [
        level,
        xpRequired,
        xpTotal,
        tier,
        tierRank,
        dailySpin,
        weeklyChest,
        offerBoostPct,
        ptcDiscountPct,
      ];
}
