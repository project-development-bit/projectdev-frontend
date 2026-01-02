import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_reward.dart';

class TreasureHuntRewardModel extends TreasureHuntReward {
  const TreasureHuntRewardModel({
    required super.type,
    required super.baseValue,
    required super.multiplier,
    required super.finalValue,
    required super.value,
    required super.label,
  });

  factory TreasureHuntRewardModel.fromJson(Map<String, dynamic> json) {
    return TreasureHuntRewardModel(
      type: json['type'] ?? '',
      baseValue: json['base_value'] ?? 0,
      multiplier: json['multiplier'] ?? 1,
      finalValue: json['final_value'] ?? 0,
      value: json['value'] ?? 0,
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'base_value': baseValue,
        'multiplier': multiplier,
        'final_value': finalValue,
        'value': value,
        'label': label,
      };
}
