import '../../domain/entities/chests_remaining.dart';

/// Chests remaining model for data layer
///
/// Extends the ChestsRemaining entity with JSON serialization capabilities
class ChestsRemainingModel extends ChestsRemaining {
  const ChestsRemainingModel({
    required super.base,
    required super.bonus,
    required super.total,
  });

  /// Create ChestsRemainingModel from JSON response
  factory ChestsRemainingModel.fromJson(Map<String, dynamic> json) {
    return ChestsRemainingModel(
      base: json['base'] as int? ?? 0,
      bonus: json['bonus'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'bonus': bonus,
      'total': total,
    };
  }

  /// Convert model to entity
  ChestsRemaining toEntity() {
    return ChestsRemaining(
      base: base,
      bonus: bonus,
      total: total,
    );
  }
}
