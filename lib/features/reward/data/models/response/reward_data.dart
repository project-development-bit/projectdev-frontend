import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'reward_level.dart';

part 'reward_data.g.dart';

@JsonSerializable(explicitToJson: true)
class RewardData extends Equatable {
  @JsonKey(name: 'current_level')
  final int currentLevel;

  @JsonKey(name: 'next_level')
  final int nextLevel;

  @JsonKey(name: 'current_xp')
  final int currentXp;

  @JsonKey(name: 'xp_per_coin')
  final double xpPerCoin;

  @JsonKey(name: 'xp_to_next_level')
  final int xpToNextLevel;

  @JsonKey(name: 'level_progress_pct')
  final double levelProgressPct;

  @JsonKey(name: 'current_tier')
  final String currentTier;

  @JsonKey(name: 'current_tier_rank')
  final int currentTierRank;

  final List<String> tiers;

  final List<RewardLevel> levels;

  const RewardData({
    required this.currentLevel,
    required this.nextLevel,
    required this.currentXp,
    required this.xpPerCoin,
    required this.xpToNextLevel,
    required this.levelProgressPct,
    required this.currentTier,
    required this.currentTierRank,
    required this.tiers,
    required this.levels,
  });

  factory RewardData.fromJson(Map<String, dynamic> json) =>
      _$RewardDataFromJson(json);

  Map<String, dynamic> toJson() => _$RewardDataToJson(this);

  @override
  List<Object?> get props => [
        currentLevel,
        nextLevel,
        currentXp,
        xpPerCoin,
        xpToNextLevel,
        levelProgressPct,
        currentTier,
        currentTierRank,
        tiers,
        levels,
      ];
}
