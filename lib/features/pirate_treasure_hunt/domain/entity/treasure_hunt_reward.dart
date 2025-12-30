import 'package:equatable/equatable.dart';

class TreasureHuntReward extends Equatable {
  const TreasureHuntReward({
    required this.type,
    required this.baseValue,
    required this.multiplier,
    required this.finalValue,
    required this.value,
    required this.label,
  });

  final String type; // coins, points, etc.
  final int baseValue;
  final int multiplier;
  final int finalValue;
  final int value;
  final String label;

  @override
  List<Object?> get props => [
        type,
        baseValue,
        multiplier,
        finalValue,
        value,
        label,
      ];
}
