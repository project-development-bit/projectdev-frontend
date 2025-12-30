import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_hunt_history_item.dart';

import '../../domain/entity/treasure_map_item.dart';
import '../../domain/entity/treasure_map_entry.dart';

const int itemsPerPage = 8;

int calculatePageCount(int rewardCount) {
  if (rewardCount == 0) return 1;
  return ((rewardCount + 1) / itemsPerPage).ceil();
}

List<TreasureMapEntry> buildMapEntriesFromHistory(
  List<TreasureHuntHistoryItem> history,
) {
  final pageCount = calculatePageCount(history.length);
  final List<TreasureMapEntry> entries = [];

  for (int page = 0; page < pageCount; page++) {
    for (int slot = 0; slot < itemsPerPage; slot++) {
      final globalIndex = page * itemsPerPage + slot;

      // 🔑 RESET islandIndex PER PAGE
      final islandIndex = slot + 1;

      TreasureMapItem item;

      if (globalIndex < history.length) {
        // ✅ Unlocked reward
        item = TreasureMapItem(
          islandIndex: islandIndex,
          type: MapItemType.girl,
          isUnlocked: true,
          isCurrent: false,
          width: 64,
          height: 64,
        );
      } else if (globalIndex == history.length) {
        // ⭐ Current / next island
        item = TreasureMapItem(
          islandIndex: islandIndex,
          type: MapItemType.question,
          isUnlocked: false,
          isCurrent: true,
          width: 48,
          height: 48,
        );
      } else {
        // 🔒 Locked future islands
        item = TreasureMapItem(
          islandIndex: islandIndex,
          type: MapItemType.question,
          isUnlocked: false,
          isCurrent: false,
          width: 40,
          height: 40,
        );
      }

      entries.add(
        TreasureMapEntry(
          item: item,
          pageIndex: page,
          slotIndex: slot,
        ),
      );
    }
  }

  return entries;
}
