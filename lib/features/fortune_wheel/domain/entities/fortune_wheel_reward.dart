import 'package:equatable/equatable.dart';

/// Fortune wheel reward entity
///
/// Represents a reward item in the fortune wheel
class FortuneWheelReward extends Equatable {
  /// Unique identifier for the reward
  final int id;

  /// Position index on the wheel (0-9 for 10 items)
  final int wheelIndex;

  /// Display label for the reward
  final String label;

  /// Coin amount for this reward
  final double rewardCoins;

  /// USD amount for this reward
  final double rewardUsd;

  /// Type of reward (coins, cash, offer_boost, treasure_chest, etc.)
  final String rewardType;

  /// Icon URL for the reward
  final String iconUrl;

  const FortuneWheelReward({
    required this.id,
    required this.wheelIndex,
    required this.label,
    required this.rewardCoins,
    required this.rewardUsd,
    required this.rewardType,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [
        id,
        wheelIndex,
        label,
        rewardCoins,
        rewardUsd,
        rewardType,
        iconUrl,
      ];
}
