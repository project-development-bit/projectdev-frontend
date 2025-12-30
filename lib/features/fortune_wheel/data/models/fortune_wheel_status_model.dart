import '../../domain/entities/fortune_wheel_status.dart';

/// Fortune wheel status model for data layer
///
/// Extends the FortuneWheelStatus entity with JSON serialization capabilities
class FortuneWheelStatusModel extends FortuneWheelStatus {
  const FortuneWheelStatusModel({
    required super.canSpin,
    required super.spins,
    required super.dailyLimit,
  });

  /// Create FortuneWheelStatusModel from JSON response
  factory FortuneWheelStatusModel.fromJson(Map<String, dynamic> json) {
    final spinsData = json['spins'] as Map<String, dynamic>? ?? {};

    return FortuneWheelStatusModel(
      canSpin: _parseBool(json['canSpin']),
      spins: SpinCounts(
        base: _parseInt(spinsData['base']),
        bonus: _parseInt(spinsData['bonus']),
        total: _parseInt(spinsData['total']),
      ),
      dailyLimit: _parseInt(json['dailyLimit']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'canSpin': canSpin,
      'spins': {
        'base': spins.base,
        'bonus': spins.bonus,
        'total': spins.total,
      },
      'dailyLimit': dailyLimit,
    };
  }

  /// Convert model to entity
  FortuneWheelStatus toEntity() {
    return FortuneWheelStatus(
      canSpin: canSpin,
      spins: spins,
      dailyLimit: dailyLimit,
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

  /// Helper method to parse boolean values
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}
