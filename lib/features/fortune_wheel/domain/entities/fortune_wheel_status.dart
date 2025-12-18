import 'package:equatable/equatable.dart';

/// Fortune wheel status entity
///
/// Represents the current spin status for the user
class FortuneWheelStatus extends Equatable {
  /// Whether the user can currently spin
  final bool canSpin;

  /// Number of spins used today
  final int todaySpins;

  /// Daily limit of spins
  final int dailyLimit;

  /// Remaining spins available today
  final int remainingSpins;

  const FortuneWheelStatus({
    required this.canSpin,
    required this.todaySpins,
    required this.dailyLimit,
    required this.remainingSpins,
  });

  @override
  List<Object?> get props => [
        canSpin,
        todaySpins,
        dailyLimit,
        remainingSpins,
      ];
}
