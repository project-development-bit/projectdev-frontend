import 'package:equatable/equatable.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_reward.dart';

class TreasureHuntUncover extends Equatable {
  const TreasureHuntUncover({
    required this.success,
    required this.message,
    required this.reward,
    required this.cooldownUntil,
    required this.status,
  });

  final bool success;
  final String message;

  /// Present only when success = true
  final TreasureHuntReward? reward;

  /// Present only when success = true
  final DateTime? cooldownUntil;

  /// Present only when success = false (e.g. no_active_hunt)
  final String? status;

  bool get hasReward => reward != null;
  bool get hasCooldown => cooldownUntil != null;

  TreasureHuntUncover copyWith({
    bool? success,
    String? message,
    TreasureHuntReward? reward,
    DateTime? cooldownUntil,
    String? status,
  }) {
    return TreasureHuntUncover(
      success: success ?? this.success,
      message: message ?? this.message,
      reward: reward ?? this.reward,
      cooldownUntil: cooldownUntil ?? this.cooldownUntil,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        reward,
        cooldownUntil,
        status,
      ];
}
