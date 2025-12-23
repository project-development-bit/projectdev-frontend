import '../../domain/entities/fortune_wheel_spin_response.dart';

/// Fortune wheel spin response model for data layer
///
/// Extends the FortuneWheelSpinResponse entity with JSON serialization capabilities
class FortuneWheelSpinResponseModel extends FortuneWheelSpinResponse {
  const FortuneWheelSpinResponseModel({
    required super.wheelIndex,
    required super.label,
    required super.rewardCoins,
    required super.rewardUsd,
    required super.rewardType,
    required super.remainingDailyCap,
    required super.message,
  });

  /// Create FortuneWheelSpinResponseModel from JSON response
  factory FortuneWheelSpinResponseModel.fromJson(
    Map<String, dynamic> json,
    String? message,
  ) {
    return FortuneWheelSpinResponseModel(
      wheelIndex: _parseInt(json['wheel_index']),
      label: json['label'] as String? ?? '',
      rewardCoins: _parseDouble(json['reward_coins']),
      rewardUsd: _parseDouble(json['reward_usd']),
      rewardType: json['reward_type'] as String? ?? 'coins',
      remainingDailyCap: _parseInt(json['remaining_daily_cap']),
      message: message ?? 'You won!',
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'wheel_index': wheelIndex,
      'label': label,
      'reward_coins': rewardCoins.toStringAsFixed(8),
      'reward_usd': rewardUsd.toStringAsFixed(2),
      'reward_type': rewardType,
      'remaining_daily_cap': remainingDailyCap,
      'message': message,
    };
  }

  /// Convert model to entity
  FortuneWheelSpinResponse toEntity() {
    return FortuneWheelSpinResponse(
      wheelIndex: wheelIndex,
      label: label,
      rewardCoins: rewardCoins,
      rewardUsd: rewardUsd,
      rewardType: rewardType,
      remainingDailyCap: remainingDailyCap,
      message: message,
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
