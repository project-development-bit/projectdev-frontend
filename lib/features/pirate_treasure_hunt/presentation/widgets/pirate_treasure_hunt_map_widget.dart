import 'package:flutter/material.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';

class PirateTreasureHuntMapWidget extends StatelessWidget {
  const PirateTreasureHuntMapWidget({super.key});

  static const double mapWidth = 550;
  static const double mapHeight = 450;

  @override
  Widget build(BuildContext context) {
    final List<TreasureMapItem> mapItems = [
      TreasureMapItem(
        islandIndex: 1,
        type: MapItemType.girl,
        x: 0.27,
        y: 0.38,
        isUnlocked: true,
        width: 100,
        height: 67,
      ),
      TreasureMapItem(
        islandIndex: 2,
        type: MapItemType.girl,
        isUnlocked: true,
        isCurrent: true,
        x: 0.3,
        y: 0.55,
        width: 60,
        height: 72,
      ),
      TreasureMapItem(
        islandIndex: 3,
        type: MapItemType.question,
        isUnlocked: true,
        x: 0.15,
        y: 0.72,
        width: 65,
        height: 55,
      ),
      TreasureMapItem(
        islandIndex: 4,
        type: MapItemType.question,
        isUnlocked: true,
        x: 0.50,
        y: 0.36,
        width: 69,
        height: 43.37,
      ),
      TreasureMapItem(
        islandIndex: 5,
        type: MapItemType.question,
        isUnlocked: true,
        x: 0.56,
        y: 0.54,
        width: 95,
        height: 77,
      ),
      TreasureMapItem(
        islandIndex: 6,
        type: MapItemType.question,
        isUnlocked: true,
        x: 0.45,
        y: 0.72,
        width: 97.24,
        height: 56.67,
      ),
      TreasureMapItem(
        islandIndex: 7,
        type: MapItemType.question,
        isCurrent: true,
        x: 0.74,
        y: 0.40,
        width: 95,
        height: 45,
      ),
      TreasureMapItem(
        islandIndex: 8,
        type: MapItemType.question,
        x: 0.80,
        y: 0.55,
        width: 56,
        height: 42,
      ),
    ];

    return SizedBox(
      width: mapWidth,
      height: mapHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppLocalImages.pirateTreasureHuntMap,
              fit: BoxFit.fill,
            ),
          ),
          for (final item in mapItems) _buildMapItem(item),
        ],
      ),
    );
  }

  // ---------------------------
  // Map Item Builder
  // ---------------------------

  Widget _buildMapItem(TreasureMapItem item) {
    final bool isLockedGirl =
        (item.type == MapItemType.girl || item.isCurrent) && !item.isUnlocked;

    final String asset = _resolveAsset(item, isLockedGirl);
    final Size size = _resolveSize(item, isLockedGirl);

    return Positioned(
      left: item.x * mapWidth - size.width / 2,
      top: item.y * mapHeight - size.height / 2,
      child: CommonImage(
        imageUrl: asset,
        width: size.width,
        height: size.height,
        fit: BoxFit.fill,
      ),
    );
  }

  // ---------------------------
  // Asset Resolver
  // ---------------------------

  String _resolveAsset(TreasureMapItem item, bool isLockedGirl) {
    if (isLockedGirl) {
      return AppLocalImages.pirateTreasureHuntMapGirl;
    }

    if (!item.isUnlocked) {
      return _getLockedIcon(item.type);
    }

    return item.getIslandImage();
  }

  // ---------------------------
  // Size Resolver
  // ---------------------------

  Size _resolveSize(TreasureMapItem item, bool isLockedGirl) {
    if (isLockedGirl) {
      return const Size(39, 82);
    }

    if (!item.isUnlocked) {
      return const Size(40, 40);
    }

    return Size(item.width, item.height);
  }

  // ---------------------------
  // Locked Icon Resolver
  // ---------------------------

  String _getLockedIcon(MapItemType type) {
    switch (type) {
      case MapItemType.question:
        return AppLocalImages.questionMark;
      case MapItemType.girl:
      default:
        return AppLocalImages.pirateTreasureHuntMapGirl;
    }
  }
}
