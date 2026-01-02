import '../../domain/entities/treasure_chest_reward.dart';

/// Treasure chest reward model for data layer
///
/// Extends the TreasureChestReward entity with JSON serialization capabilities
class TreasureChestRewardModel extends TreasureChestReward {
  const TreasureChestRewardModel({
    required super.type,
    required super.value,
    required super.label,
  });

  /// Create TreasureChestRewardModel from JSON response
  factory TreasureChestRewardModel.fromJson(Map<String, dynamic> json) {
    return TreasureChestRewardModel(
      type: json['type'] as String? ?? 'coins',
      value: json['value'] as num? ?? 0,
      label: json['label'] as String? ?? '',
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'label': label,
    };
  }

  /// Convert model to entity
  TreasureChestReward toEntity() {
    return TreasureChestReward(
      type: type,
      value: value,
      label: label,
    );
  }
}
