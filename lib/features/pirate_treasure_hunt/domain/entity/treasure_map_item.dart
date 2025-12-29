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
        return 'assets/images/pirate_treasure_hunt/islands/island1.svg';
      case 2:
        return 'assets/images/pirate_treasure_hunt/islands/treasure-ship.svg';
      case 3:
        return 'assets/images/pirate_treasure_hunt/islands/island3.svg';
      case 4:
        return 'assets/images/pirate_treasure_hunt/islands/island4.png';
      case 5:
        return 'assets/images/pirate_treasure_hunt/islands/island5.svg';
      case 6:
        return 'assets/images/pirate_treasure_hunt/islands/island6.svg';
      case 7:
        return 'assets/images/pirate_treasure_hunt/islands/island7.svg';
      case 8:
        return 'assets/images/pirate_treasure_hunt/islands/island8.svg';
      default:
        return 'assets/images/pirate_treasure_hunt/island_1.svg';
    }
  }
}
