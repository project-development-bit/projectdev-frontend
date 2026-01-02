import 'package:equatable/equatable.dart';
import 'treasure_hunt_reward.dart';

class TreasureHuntHistoryItem extends Equatable {
  const TreasureHuntHistoryItem({
    required this.id,
    required this.eventType,
    required this.stepNumber,
    required this.reward,
    required this.userLevel,
    required this.userStatus,
    required this.statusMultiplier,
    required this.rewardLabel,
    required this.createdAt,
  });

  final int id;
  final String eventType;
  final int stepNumber;
  final TreasureHuntReward reward;
  final int userLevel;
  final String userStatus;
  final String statusMultiplier;
  final String rewardLabel;
  final DateTime createdAt;

  bool get isRewardGranted => eventType == 'reward_granted';

  @override
  List<Object?> get props => [
        id,
        eventType,
        stepNumber,
        reward,
        userLevel,
        userStatus,
        statusMultiplier,
        rewardLabel,
        createdAt,
      ];
}
