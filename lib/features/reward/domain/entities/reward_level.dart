import 'package:equatable/equatable.dart';

class RewardLevel extends Equatable {
  final int level;
  final int xpRequired;
  final int xpTotal;
  final String tier;
  final int tierRank;
  final int dailySpin;
  final int weeklyChest;
  final int offerBoostPct;
  final int ptcDiscountPct;

  const RewardLevel({
    required this.level,
    required this.xpRequired,
    required this.xpTotal,
    required this.tier,
    required this.tierRank,
    required this.dailySpin,
    required this.weeklyChest,
    required this.offerBoostPct,
    required this.ptcDiscountPct,
  });

  @override
  List<Object?> get props => [
        level,
        xpRequired,
        xpTotal,
        tier,
        tierRank,
        dailySpin,
        weeklyChest,
        offerBoostPct,
        ptcDiscountPct,
      ];
}
