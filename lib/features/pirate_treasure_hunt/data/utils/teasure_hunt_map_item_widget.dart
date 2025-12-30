// import 'package:flutter/material.dart';
// import '../../domain/entity/treasure_map_item.dart';

// class TeasureHuntMapItemWidget extends StatelessWidget {
//   final TreasureMapItem item;
//   final int pageIndex;
//   final int slotIndex;
//   final double pageWidth;
//   final double pageHeight;

//   const TeasureHuntMapItemWidget({
//     super.key,
//     required this.item,
//     required this.pageIndex,
//     required this.slotIndex,
//     required this.pageWidth,
//     required this.pageHeight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final left = pageIndex * pageWidth + (slotIndex % 4) * (pageWidth / 4);
//     final top = (slotIndex ~/ 4) * (pageHeight / 2);

//     return Positioned(
//       left: left + 20,
//       top: top + 20,
//       child: AnimatedScale(
//         scale: item.isCurrent ? 1.15 : 1,
//         duration: const Duration(milliseconds: 300),
//         child: Container(
//           width: item.width,
//           height: item.height,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: item.isUnlocked
//                 ? Colors.amber
//                 : item.isCurrent
//                     ? Colors.orangeAccent
//                     : Colors.grey.shade700,
//             boxShadow: item.isCurrent
//                 ? [
//                     BoxShadow(
//                       color: Colors.orange.withOpacity(0.6),
//                       blurRadius: 12,
//                       spreadRadius: 2,
//                     )
//                   ]
//                 : [],
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             item.type == MapItemType.question ? '?' : '🏝',
//             style: const TextStyle(fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }
