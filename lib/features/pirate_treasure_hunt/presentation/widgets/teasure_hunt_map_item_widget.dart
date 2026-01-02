import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';

class TeasureHuntMapItemWidget extends StatelessWidget {
  const TeasureHuntMapItemWidget({
    super.key,
    required this.item,
    required this.pageIndex,
    required this.slotIndex,
    required this.pageWidth,
    required this.pageHeight,
  });
  final TreasureMapItem item;
  final int pageIndex;
  final int slotIndex;
  final double pageWidth;
  final double pageHeight;
  // 8 fixed slots (percentage positions within ONE page)
  static const List<Offset> _slots = [
    Offset(0.20, 0.18),
    Offset(0.25, 0.55),
    Offset(0.08, 0.82),
    Offset(0.52, 0.25),
    Offset(0.62, 0.50),
    Offset(0.45, 0.75),
    Offset(0.85, 0.26),
    Offset(0.88, 0.50),
  ];
  static const List<Offset> _treasureImageOffset = [
    Offset(15, 10),
    Offset(15, 1),
    Offset(20, 5),
    Offset(15, 5),
    Offset(10, 1),
    Offset(20, 2),
    Offset(15, 20),
    Offset(15, 2),
  ];
  @override
  Widget build(BuildContext context) {
    final slot = _slots[slotIndex];

    final left = (pageIndex * pageWidth) + (slot.dx * pageWidth);
    final top = slot.dy * pageHeight;

    final bool isLockedGirl =
        (item.type == MapItemType.girl || item.isCurrent) && !item.isUnlocked;

    final String asset = _resolveAsset(item, isLockedGirl);
    final Size size = _resolveSize(item, isLockedGirl);

    final treasureImageOffset = _treasureImageOffset[slotIndex];

    return Positioned(
      left: left - size.width / 2,
      top: top - size.height / 2,
      child: Stack(
        children: [
          CommonImage(
            imageUrl: asset,
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
            placeholder: SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          if (item.isUnlocked && (item.treasureImage?.isNotEmpty ?? false))
            Positioned(
              bottom: treasureImageOffset.dy,
              right: treasureImageOffset.dx,
              child: CommonImage(
                imageUrl: item.treasureImage ?? "",
                width: 25,
                height: 25,
                fit: BoxFit.fill,
                placeholder: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _resolveAsset(TreasureMapItem item, bool isLockedGirl) {
    if (isLockedGirl) return AppLocalImages.pirateTreasureHuntMapGirl;

    if (!item.isUnlocked) {
      return item.type == MapItemType.question
          ? AppLocalImages.questionMark
          : AppLocalImages.pirateTreasureHuntMapGirl;
    }

    return item.getIslandImage();
  }

  Size _resolveSize(TreasureMapItem item, bool isLockedGirl) {
    if (isLockedGirl) return const Size(39, 82);
    if (!item.isUnlocked) return const Size(40, 40);
    return Size(item.width, item.height);
  }
}
