import '../../domain/entities/fortune_wheel_reward.dart';

/// Fortune wheel reward model for data layer
///
/// Extends the FortuneWheelReward entity with JSON serialization capabilities
class FortuneWheelRewardModel extends FortuneWheelReward {
  const FortuneWheelRewardModel({
    required super.id,
    required super.wheelIndex,
    required super.label,
    required super.rewardCoins,
    required super.rewardUsd,
    required super.rewardType,
    required super.iconUrl,
  });

  /// Create FortuneWheelRewardModel from JSON response
  factory FortuneWheelRewardModel.fromJson(Map<String, dynamic> json) {
    return FortuneWheelRewardModel(
      id: _parseInt(json['id']),
      wheelIndex: _parseInt(json['wheel_index']),
      label: json['label'] as String? ?? '',
      rewardCoins: _parseDouble(json['reward_coins']),
      rewardUsd: _parseDouble(json['reward_usd']),
      rewardType: json['reward_type'] as String? ?? 'coins',
      iconUrl: json['icon_url'] as String? ?? '',
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wheel_index': wheelIndex,
      'label': label,
      'reward_coins': rewardCoins.toStringAsFixed(8),
      'reward_usd': rewardUsd.toStringAsFixed(2),
      'reward_type': rewardType,
      'icon_url': iconUrl,
    };
  }

  /// Convert model to entity
  FortuneWheelReward toEntity() {
    return FortuneWheelReward(
      id: id,
      wheelIndex: wheelIndex,
      label: label,
      rewardCoins: rewardCoins,
      rewardUsd: rewardUsd,
      rewardType: rewardType,
      iconUrl: iconUrl,
    );
  }

  /// Helper method to parse int values which might be int or string
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// Helper method to parse double values which might be double, int, or string
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
