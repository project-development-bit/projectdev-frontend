// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:gigafaucet/core/config/app_local_images.dart';
// import 'package:gigafaucet/core/core.dart';
// import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';

// class PirateTreasureHuntMapWidgetTest extends StatelessWidget {
//   const PirateTreasureHuntMapWidgetTest({super.key});

//   static const double mapWidth = 550;
//   static const double mapHeight = 450;
//   static const int itemsPerPage = 8;

//   // 8 fixed slots on the map (percentage positions)
//   // These should match your empty-map layout.
//   static const List<Offset> _slots = [
//     Offset(0.27, 0.38),
//     Offset(0.30, 0.55),
//     Offset(0.15, 0.72),
//     Offset(0.50, 0.36),
//     Offset(0.56, 0.54),
//     Offset(0.45, 0.72),
//     Offset(0.74, 0.40),
//     Offset(0.80, 0.55),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // ---------------------------
//     // Example: "found items" from API / state
//     // Only include FOUND/UNLOCKED islands here.
//     // The widget will auto-fill the rest with question marks.
//     // ---------------------------
//     final List<TreasureMapItem> foundItems = [
//       TreasureMapItem(
//         islandIndex: 1,
//         type: MapItemType.girl,
//         isUnlocked: true,
//         x: 0.27,
//         y: 0.38,
//         width: 100,
//         height: 67,
//       ),
//       TreasureMapItem(
//         islandIndex: 2,
//         type: MapItemType.girl,
//         isUnlocked: true,
//         isCurrent: true,
//         x: 0.30,
//         y: 0.55,
//         width: 60,
//         height: 72,
//       ),
//       TreasureMapItem(
//         islandIndex: 3,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.15,
//         y: 0.72,
//         width: 65,
//         height: 55,
//       ),
//       TreasureMapItem(
//         islandIndex: 4,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.50,
//         y: 0.36,
//         width: 69,
//         height: 43.37,
//       ),
//       TreasureMapItem(
//         islandIndex: 5,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.56,
//         y: 0.54,
//         width: 95,
//         height: 77,
//       ),
//       TreasureMapItem(
//         islandIndex: 6,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.45,
//         y: 0.72,
//         width: 97.24,
//         height: 56.67,
//       ),
//       TreasureMapItem(
//         islandIndex: 7,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.74,
//         y: 0.40,
//         width: 95,
//         height: 45,
//       ),
//       TreasureMapItem(
//         islandIndex: 8,
//         type: MapItemType.question,
//         isUnlocked: true,
//         x: 0.80,
//         y: 0.55,
//         width: 56,
//         height: 42,
//       ),
//       // Add more found items to test page 2:
//       TreasureMapItem(
//         islandIndex: 8,
//         type: MapItemType.question,
//         isUnlocked: false,
//         isCurrent: true,
//         x: 0.80,
//         y: 0.55,
//         width: 56,
//         height: 42,
//       ),
//       // TreasureMapItem(...), // 9
//       // TreasureMapItem(...), // 10
//     ];

//     final pages = _buildPages(foundItems);

//     return SizedBox(
//       width: mapWidth,
//       height: mapHeight,
//       child: PageView.builder(
//         itemCount: pages.length,
//         // If you want vertical scrolling:
//         // scrollDirection: Axis.vertical,
//         itemBuilder: (context, pageIndex) {
//           return _buildMapPage(pages[pageIndex]);
//         },
//       ),
//     );
//   }

//   // ---------------------------
//   // Paging Logic
//   // ---------------------------

//   List<List<TreasureMapItem>> _buildPages(List<TreasureMapItem> foundItems) {
//     final foundCount = foundItems.length;

//     // Base pages = ceil(found/8), minimum 1
//     int pageCount = math.max(1, (foundCount / itemsPerPage).ceil());

//     // If foundCount is exactly multiple of 8, add one extra page full of questions
//     if (foundCount > 0 && foundCount % itemsPerPage == 0) {
//       pageCount += 1;
//     }

//     return List.generate(pageCount, (pageIndex) {
//       final start = pageIndex * itemsPerPage;
//       final end = math.min(start + itemsPerPage, foundCount);

//       // Items that belong to this page
//       final pageFound = foundItems.sublist(
//         math.min(start, foundCount),
//         math.min(end, foundCount),
//       );

//       // Fill up to 8 slots with question placeholders
//       final List<TreasureMapItem> pageItems = [];
//       for (int slotIndex = 0; slotIndex < itemsPerPage; slotIndex++) {
//         if (slotIndex < pageFound.length) {
//           // Use the found item in this slot
//           pageItems.add(_applySlotDefaults(pageFound[slotIndex], slotIndex));
//         } else {
//           // Empty slot => locked question
//           final globalIndex = start + slotIndex + 1; // 1-based display index
//           pageItems.add(_questionPlaceholder(slotIndex, globalIndex));
//         }
//       }

//       return pageItems;
//     });
//   }

//   // Apply consistent positioning if needed (slot position takes priority).
//   // This keeps every page aligned to the same 8-slot layout.
//   TreasureMapItem _applySlotDefaults(TreasureMapItem item, int slotIndex) {
//     final pos = _slots[slotIndex];

//     // If you do NOT want to override item.x/item.y, comment these 2 lines
//     // and return item directly.
//     return TreasureMapItem(
//       islandIndex: item.islandIndex,
//       type: item.type,
//       isUnlocked: item.isUnlocked,
//       isCurrent: item.isCurrent,
//       x: pos.dx,
//       y: pos.dy,
//       width: item.width,
//       height: item.height,
//     );
//   }

//   TreasureMapItem _questionPlaceholder(int slotIndex, int globalIndex) {
//     final pos = _slots[slotIndex];
//     return TreasureMapItem(
//       islandIndex: globalIndex,
//       type: MapItemType.question,
//       isUnlocked: false,
//       isCurrent: false,
//       x: pos.dx,
//       y: pos.dy,
//       width: 40,
//       height: 40,
//     );
//   }

//   // ---------------------------
//   // Page UI
//   // ---------------------------

//   Widget _buildMapPage(List<TreasureMapItem> items) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             AppLocalImages.pirateTreasureHuntMap,
//             fit: BoxFit.fill,
//           ),
//         ),
//         for (final item in items) _buildMapItem(item),
//       ],
//     );
//   }

//   // ---------------------------
//   // Map Item UI
//   // ---------------------------

//   Widget _buildMapItem(TreasureMapItem item) {
//     final bool isLockedGirl =
//         (item.type == MapItemType.girl || item.isCurrent) && !item.isUnlocked;

//     final String asset = _resolveAsset(item, isLockedGirl);
//     final Size size = _resolveSize(item, isLockedGirl);

//     return Positioned(
//       left: item.x * mapWidth - size.width / 2,
//       top: item.y * mapHeight - size.height / 2,
//       child: CommonImage(
//         imageUrl: asset,
//         width: size.width,
//         height: size.height,
//         fit: BoxFit.fill,
//       ),
//     );
//   }

//   String _resolveAsset(TreasureMapItem item, bool isLockedGirl) {
//     if (isLockedGirl) {
//       return AppLocalImages.pirateTreasureHuntMapGirl;
//     }

//     if (!item.isUnlocked) {
//       return _getLockedIcon(item.type);
//     }

//     // Unlocked => show island image
//     return item.getIslandImage();
//   }

//   Size _resolveSize(TreasureMapItem item, bool isLockedGirl) {
//     if (isLockedGirl) {
//       return const Size(39, 82);
//     }

//     if (!item.isUnlocked) {
//       return const Size(40, 40);
//     }

//     return Size(item.width, item.height);
//   }

//   String _getLockedIcon(MapItemType type) {
//     switch (type) {
//       case MapItemType.question:
//         return AppLocalImages.questionMark;
//       case MapItemType.girl:
//       default:
//         return AppLocalImages.pirateTreasureHuntMapGirl;
//     }
//   }
// }
