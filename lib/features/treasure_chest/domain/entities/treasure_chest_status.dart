import 'package:equatable/equatable.dart';

/// Treasure chest entity representing chest counts
class TreasureChestCounts extends Equatable {
  /// Base chests available
  final int base;

  /// Bonus chests available
  final int bonus;

  /// Total chests available
  final int total;

  const TreasureChestCounts({
    required this.base,
    required this.bonus,
    required this.total,
  });

  @override
  List<Object?> get props => [base, bonus, total];
}

/// Treasure chest cooldown entity
class TreasureChestCooldown extends Equatable {
  /// Whether cooldown is currently active
  final bool active;

  /// Remaining hours until next chest
  final int remainingHours;

  const TreasureChestCooldown({
    required this.active,
    required this.remainingHours,
  });

  @override
  List<Object?> get props => [active, remainingHours];
}

/// Treasure chest status entity
///
/// Represents the current treasure chest status for the user
class TreasureChestStatus extends Equatable {
  /// Chest counts (base, bonus, total)
  final TreasureChestCounts chests;

  /// Current status (e.g., "no_chest_available", "chest_available")
  final String status;

  /// Cooldown information
  final TreasureChestCooldown cooldown;

  /// Next reset timestamp
  final DateTime nextResetAt;

  /// User status/tier (e.g., "bronze", "silver", "gold")
  final String userStatus;

  /// User level
  final int userLevel;

  /// Weekly limit of chests
  final int weeklyLimit;

  /// Number of chests opened this week
  final int openedThisWeek;

  const TreasureChestStatus({
    required this.chests,
    required this.status,
    required this.cooldown,
    required this.nextResetAt,
    required this.userStatus,
    required this.userLevel,
    required this.weeklyLimit,
    required this.openedThisWeek,
  });

  /// Check if user can open a chest
  bool get canOpen => chests.total > 0 && !cooldown.active;

  /// Get remaining chests for the week
  int get remainingThisWeek => weeklyLimit - openedThisWeek;

  /// Create a copy of this status with updated fields
  TreasureChestStatus copyWith({
    TreasureChestCounts? chests,
    String? status,
    TreasureChestCooldown? cooldown,
    DateTime? nextResetAt,
    String? userStatus,
    int? userLevel,
    int? weeklyLimit,
    int? openedThisWeek,
  }) {
    return TreasureChestStatus(
      chests: chests ?? this.chests,
      status: status ?? this.status,
      cooldown: cooldown ?? this.cooldown,
      nextResetAt: nextResetAt ?? this.nextResetAt,
      userStatus: userStatus ?? this.userStatus,
      userLevel: userLevel ?? this.userLevel,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      openedThisWeek: openedThisWeek ?? this.openedThisWeek,
    );
  }

  @override
  List<Object?> get props => [
        chests,
        status,
        cooldown,
        nextResetAt,
        userStatus,
        userLevel,
        weeklyLimit,
        openedThisWeek,
      ];
}
