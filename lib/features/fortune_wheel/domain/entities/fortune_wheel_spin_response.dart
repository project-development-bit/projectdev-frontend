import 'package:equatable/equatable.dart';

/// Fortune wheel spin response entity
///
/// Represents the result of spinning the fortune wheel
class FortuneWheelSpinResponse extends Equatable {
  /// The wheel index position of the reward won (0-based)
  final int wheelIndex;

  /// Display label for the reward
  final String label;

  /// Coin amount won
  final double rewardCoins;

  /// USD amount won
  final double rewardUsd;

  /// Type of reward (coins, cash, offer_boost, treasure_chest, etc.)
  final String rewardType;

  /// Remaining daily spin cap
  final int remainingDailyCap;

  /// Message from server
  final String message;

  const FortuneWheelSpinResponse({
    required this.wheelIndex,
    required this.label,
    required this.rewardCoins,
    required this.rewardUsd,
    required this.rewardType,
    required this.remainingDailyCap,
    required this.message,
  });

  @override
  List<Object?> get props => [
        wheelIndex,
        label,
        rewardCoins,
        rewardUsd,
        rewardType,
        remainingDailyCap,
        message,
      ];
}
