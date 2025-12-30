import 'package:equatable/equatable.dart';

/// Spin counts entity representing available spins
class SpinCounts extends Equatable {
  /// Base spins available
  final int base;

  /// Bonus spins available
  final int bonus;

  /// Total spins available
  final int total;

  const SpinCounts({
    required this.base,
    required this.bonus,
    required this.total,
  });

  @override
  List<Object?> get props => [base, bonus, total];
}

/// Fortune wheel status entity
///
/// Represents the current spin status for the user
class FortuneWheelStatus extends Equatable {
  /// Whether the user can currently spin
  final bool canSpin;

  /// Spin counts (base, bonus, total)
  final SpinCounts spins;

  /// Daily limit of spins
  final int dailyLimit;

  const FortuneWheelStatus({
    required this.canSpin,
    required this.spins,
    required this.dailyLimit,
  });

  @override
  List<Object?> get props => [
        canSpin,
        spins,
        dailyLimit,
      ];
}
