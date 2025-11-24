import 'package:cointiply_app/features/reward/domain/entities/reward_level.dart';
import 'package:equatable/equatable.dart';

class RewardData extends Equatable {
  final int currentLevel;
  final int nextLevel;
  final int currentXp;
  final double xpPerCoin;
  final int xpToNextLevel;
  final double levelProgressPct;
  final String currentTier;
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
