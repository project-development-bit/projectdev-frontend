import 'package:equatable/equatable.dart';

/// Treasure chest reward entity
///
/// Represents a reward received from opening a treasure chest
class TreasureChestReward extends Equatable {
  /// Type of reward (coins, bonus_spin, etc.)
  final String type;

  /// Value of the reward
  final num value;

  /// Display label for the reward
  final String label;

  const TreasureChestReward({
    required this.type,
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [type, value, label];
}
