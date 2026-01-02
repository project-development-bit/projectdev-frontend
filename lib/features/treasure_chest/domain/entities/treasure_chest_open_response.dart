import 'package:equatable/equatable.dart';
import 'treasure_chest_reward.dart';
import 'chests_remaining.dart';

/// Treasure chest open response entity
///
/// Represents the result of opening a treasure chest
class TreasureChestOpenResponse extends Equatable {
  /// Whether the operation was successful
  final bool success;

  /// Message from server
  final String message;

  /// Reward received
  final TreasureChestReward reward;

  /// Remaining chests
  final ChestsRemaining chestsRemaining;

  const TreasureChestOpenResponse({
    required this.success,
    required this.message,
    required this.reward,
    required this.chestsRemaining,
  });

  @override
  List<Object?> get props => [success, message, reward, chestsRemaining];
}
