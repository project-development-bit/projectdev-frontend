import 'package:flutter/material.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';

class PirateTreasureHuntMapWidget extends StatelessWidget {
  const PirateTreasureHuntMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TreasureMapItem> mapItems = [
      TreasureMapItem(
          islandIndex: 1,
          type: MapItemType.girl,
          x: 0.27,
          y: 0.38,
          width: 100,
          height: 67),
      TreasureMapItem(
          islandIndex: 2,
          type: MapItemType.question,
          x: 0.3,
          y: 0.55,
          width: 60,
          height: 72),
      TreasureMapItem(
          islandIndex: 3,
          type: MapItemType.question,
          x: 0.15,
          y: 0.72,
          width: 65,
          height: 55),
      TreasureMapItem(
          islandIndex: 4,
          type: MapItemType.question,
          x: 0.50,
          y: 0.36,
          width: 69,
          height: 43.37),
      TreasureMapItem(
          islandIndex: 5,
          type: MapItemType.question,
          x: 0.56,
          y: 0.54,
          width: 95,
          height: 77),
      TreasureMapItem(
          islandIndex: 6,
          type: MapItemType.question,
          x: 0.45,
          y: 0.72,
          width: 97.24,
          height: 56.67),
      TreasureMapItem(
          islandIndex: 7,
          type: MapItemType.question,
          x: 0.74,
          y: 0.40,
          width: 95,
          height: 45),
      TreasureMapItem(
          islandIndex: 8,
          type: MapItemType.question,
          x: 0.80,
          y: 0.55,
          width: 56,
          height: 42),
    ];

    return SizedBox(
      width: 550,
      height: 450,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppLocalImages.pirateTreasureHuntMap,
              fit: BoxFit.fill,
            ),
          ),
          ...mapItems.map((item) => _buildMapItem(item)),
          // _buildMapItem(mapItems[0]),
        ],
      ),
    );
  }

  Widget _buildMapItem(TreasureMapItem item) {
    return Positioned(
      left: item.x * 550 - item.width / 2,
      top: item.y * 450 - item.height / 2,
      child: _loadIcon(
        item.getIslandImage(),
        item.width,
        item.height,
      ),
    );
  }

  // Widget _getItemIcon(TreasureMapItem item) {
  //   switch (item.type) {
  //     case MapItemType.girl:
  //       return _loadIcon(
  //         AppLocalImages.pirateTreasureHuntMapGirl,
  //         item.width,
  //         item.height,
  //       );
  //     case MapItemType.question:
  //       return _loadIcon(
  //         AppLocalImages.questionMark,
  //         item.width,
  //         item.height,
  //       );

  //     default:
  //       return Icon(Icons.terrain, size: item.height, color: Colors.grey);
  //   }
  // }

  Widget _loadIcon(String assetPath, double width, double height) {
    return CommonImage(
        imageUrl: assetPath, width: width, height: height, fit: BoxFit.fill);
  }
}
