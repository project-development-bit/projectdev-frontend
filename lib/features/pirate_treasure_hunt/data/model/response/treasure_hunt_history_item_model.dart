import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_history_item.dart';
import 'treasure_hunt_reward_model.dart';

class TreasureHuntHistoryItemModel extends TreasureHuntHistoryItem {
  const TreasureHuntHistoryItemModel({
    required super.id,
    required super.eventType,
    required super.stepNumber,
    required super.reward,
    required super.userLevel,
    required super.userStatus,
    required super.statusMultiplier,
    required super.rewardLabel,
    required super.createdAt,
  });

  factory TreasureHuntHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntHistoryItemModel(
      id: json['id'] ?? 0,
      eventType: json['event_type'] ?? '',
      stepNumber: json['step_number'] ?? 0,
      reward: TreasureHuntRewardModel.fromJson(json['reward_data'] ?? {}),
      userLevel: json['user_level'] ?? 0,
      userStatus: json['user_status'] ?? '',
      statusMultiplier: json['status_multiplier']?.toString() ?? '',
      rewardLabel: json['reward_label'] ?? '',
      createdAt: DateTime.tryParse(
            json['created_at'] ?? '',
          ) ??
          DateTime.now(),
    );
  }
}
