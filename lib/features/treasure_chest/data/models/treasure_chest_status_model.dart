import '../../domain/entities/treasure_chest_status.dart';

/// Treasure chest counts model for data layer
class TreasureChestCountsModel extends TreasureChestCounts {
  const TreasureChestCountsModel({
    required super.base,
    required super.bonus,
    required super.total,
  });

  /// Create TreasureChestCountsModel from JSON response
  factory TreasureChestCountsModel.fromJson(Map<String, dynamic> json) {
    return TreasureChestCountsModel(
      base: _parseInt(json['base']),
      bonus: _parseInt(json['bonus']),
      total: _parseInt(json['total']),
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
  TreasureChestCounts toEntity() {
    return TreasureChestCounts(
      base: base,
      bonus: bonus,
      total: total,
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
}

/// Treasure chest cooldown model for data layer
class TreasureChestCooldownModel extends TreasureChestCooldown {
  const TreasureChestCooldownModel({
    required super.active,
    required super.remainingHours,
  });

  /// Create TreasureChestCooldownModel from JSON response
  factory TreasureChestCooldownModel.fromJson(Map<String, dynamic> json) {
    return TreasureChestCooldownModel(
      active: _parseBool(json['active']),
      remainingHours: _parseInt(json['remainingHours']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'remainingHours': remainingHours,
    };
  }

  /// Convert model to entity
  TreasureChestCooldown toEntity() {
    return TreasureChestCooldown(
      active: active,
      remainingHours: remainingHours,
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

/// Treasure chest status model for data layer
///
/// Extends the TreasureChestStatus entity with JSON serialization capabilities
class TreasureChestStatusModel extends TreasureChestStatus {
  const TreasureChestStatusModel({
    required super.chests,
    required super.status,
    required super.cooldown,
    required super.nextResetAt,
    required super.userStatus,
    required super.userLevel,
    required super.weeklyLimit,
    required super.openedThisWeek,
  });

  /// Create TreasureChestStatusModel from JSON response
  factory TreasureChestStatusModel.fromJson(Map<String, dynamic> json) {
    return TreasureChestStatusModel(
      chests: TreasureChestCountsModel.fromJson(
        json['chests'] as Map<String, dynamic>,
      ),
      status: json['status'] as String? ?? '',
      cooldown: TreasureChestCooldownModel.fromJson(
        json['cooldown'] as Map<String, dynamic>,
      ),
      nextResetAt: _parseDateTime(json['next_reset_at']),
      userStatus: json['user_status'] as String? ?? '',
      userLevel: _parseInt(json['user_level']),
      weeklyLimit: _parseInt(json['weekly_limit']),
      openedThisWeek: _parseInt(json['opened_this_week']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'chests': (chests as TreasureChestCountsModel).toJson(),
      'status': status,
      'cooldown': (cooldown as TreasureChestCooldownModel).toJson(),
      'next_reset_at': nextResetAt.toIso8601String(),
      'user_status': userStatus,
      'user_level': userLevel,
      'weekly_limit': weeklyLimit,
      'opened_this_week': openedThisWeek,
    };
  }

  /// Convert model to entity
  TreasureChestStatus toEntity() {
    return TreasureChestStatus(
      chests: chests,
      status: status,
      cooldown: cooldown,
      nextResetAt: nextResetAt,
      userStatus: userStatus,
      userLevel: userLevel,
      weeklyLimit: weeklyLimit,
      openedThisWeek: openedThisWeek,
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

  /// Helper method to parse DateTime from ISO8601 string
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
