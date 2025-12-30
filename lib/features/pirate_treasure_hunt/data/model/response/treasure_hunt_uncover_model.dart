import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_uncover.dart';
import 'treasure_hunt_reward_model.dart';

class TreasureHuntUncoverModel extends TreasureHuntUncover {
  const TreasureHuntUncoverModel({
    required super.success,
    required super.message,
    required super.reward,
    required super.cooldownUntil,
    required super.status,
  });

  factory TreasureHuntUncoverModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntUncoverModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: json['status'],
      reward: json['reward'] != null
          ? TreasureHuntRewardModel.fromJson(json['reward'])
          : null,
      cooldownUntil: json['cooldown_until'] != null
          ? DateTime.tryParse(json['cooldown_until'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'reward': reward is TreasureHuntRewardModel
            ? (reward as TreasureHuntRewardModel).toJson()
            : null,
        'cooldown_until': cooldownUntil?.toIso8601String(),
      };
}
