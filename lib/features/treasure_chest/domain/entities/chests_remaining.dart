import 'package:equatable/equatable.dart';

/// Chests remaining entity
///
/// Represents the number of treasure chests available
class ChestsRemaining extends Equatable {
  /// Base chests available
  final int base;

  /// Bonus chests available
  final int bonus;

  /// Total chests available
  final int total;

  const ChestsRemaining({
    required this.base,
    required this.bonus,
    required this.total,
  });

  @override
  List<Object?> get props => [base, bonus, total];
}
