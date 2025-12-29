import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';

class TreasureMapEntry {
  final TreasureMapItem item;
  final int pageIndex;
  final int slotIndex;

  const TreasureMapEntry({
    required this.item,
    required this.pageIndex,
    required this.slotIndex,
  });
}
