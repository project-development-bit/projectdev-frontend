import 'package:equatable/equatable.dart';

class SubLevel extends Equatable {
  final String id;
  final String label;
  final int minLevel;
  final int dailySpinFree;
  final int weeklyChestFree;
  final int offerBoostPercent;
  final int ptcDiscountPercent;
  const SubLevel({
    required this.id,
    required this.label,
    required this.minLevel,
    required this.dailySpinFree,
    required this.weeklyChestFree,
    required this.offerBoostPercent,
    required this.ptcDiscountPercent,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        minLevel,
        dailySpinFree,
        weeklyChestFree,
        offerBoostPercent,
        ptcDiscountPercent,
      ];
}
