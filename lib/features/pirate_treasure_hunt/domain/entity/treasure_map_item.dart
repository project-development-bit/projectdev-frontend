import 'package:gigafaucet/core/config/app_local_images.dart';

enum MapItemType {
  girl,
  question,
  island,
  pirate,
  lighthouse,
  rock,
}

class TreasureMapItem {
  final MapItemType type;
  final int islandIndex;
  final double width;
  final double height;
  final bool isUnlocked;
  final bool isCurrent;

  const TreasureMapItem({
    required this.type,
    this.islandIndex = 1,
    this.width = 40,
    this.height = 40,
    this.isUnlocked = false,
    this.isCurrent = false,
  });

  String getIslandImage() {
    switch (islandIndex) {
      case 1:
        return AppLocalImages.island1;
      case 2:
        return AppLocalImages.island2;
      case 3:
        return AppLocalImages.island3;
      case 4:
        return AppLocalImages.island4;
      case 5:
        return AppLocalImages.island5;
      case 6:
        return AppLocalImages.island6;
      case 7:
        return AppLocalImages.island7;
      case 8:
        return AppLocalImages.island8;
      default:
        return AppLocalImages.island1;
    }
  }
}
