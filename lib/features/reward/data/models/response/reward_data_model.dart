import 'package:cointiply_app/features/reward/domain/entities/reward_data.dart';
import 'reward_level_model.dart';

class RewardDataModel extends RewardData {
  const RewardDataModel({
    required super.currentLevel,
    required super.nextLevel,
    required super.currentXp,
    required super.xpPerCoin,
    required super.xpToNextLevel,
    required super.levelProgressPct,
    required super.currentTier,
    required super.currentTierRank,
    required super.tiers,
    required super.levels,
  });

  factory RewardDataModel.fromJson(Map<String, dynamic> json) {
    return RewardDataModel(
      currentLevel: json['current_level'],
      nextLevel: json['next_level'],
      currentXp: json['current_xp'],
      xpPerCoin: (json['xp_per_coin'] as num).toDouble(),
      xpToNextLevel: json['xp_to_next_level'],
      levelProgressPct: (json['level_progress_pct'] as num).toDouble(),
      currentTier: json['current_tier'],
      currentTierRank: json['current_tier_rank'],
      tiers: List<String>.from(json['tiers']),
      levels: (json['levels'] as List)
          .map((e) => RewardLevelModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_level': currentLevel,
        'next_level': nextLevel,
        'current_xp': currentXp,
        'xp_per_coin': xpPerCoin,
        'xp_to_next_level': xpToNextLevel,
        'level_progress_pct': levelProgressPct,
        'current_tier': currentTier,
        'current_tier_rank': currentTierRank,
        'tiers': tiers,
        'levels': levels
            .map((level) => (level as RewardLevelModel).toJson())
            .toList(),
      };

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
