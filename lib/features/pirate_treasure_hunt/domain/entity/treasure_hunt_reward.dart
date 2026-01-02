import 'package:equatable/equatable.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';

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

  String get rewardImage {
    switch (type) {
      case 'coins':
        return _coinImagesByQty;
      case 'extra_spin':
        return AppLocalImages.treasurespins;
      case 'offer_boost':
        return AppLocalImages.treasurespins;
      case 'ptc_discount':
        return AppLocalImages.treasurePtc;
      default:
        return AppLocalImages.treasure30Coins;
    }
  }

  String get _coinImagesByQty {
    switch (finalValue) {
      case 30:
        return AppLocalImages.treasure30Coins;
      case 50:
        return AppLocalImages.treasure50Coins;
      case 100:
        return AppLocalImages.treasure100Coins;
      case 300:
        return AppLocalImages.treasure300Coins;
      case 1000:
        return AppLocalImages.treasure1000Coins;
      case 5000:
        return AppLocalImages.treasure5000Coins;
      case 20000:
        return AppLocalImages.treasure20000Coins;
      default:
        return AppLocalImages.treasure30Coins;
    }
  }
}
