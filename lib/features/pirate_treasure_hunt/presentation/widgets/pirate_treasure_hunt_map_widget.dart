import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_entry.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/treasure_map_item.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/teasure_hunt_map_item_widget.dart';

class PirateTreasureHuntMapWidget extends StatefulWidget {
  const PirateTreasureHuntMapWidget({super.key});

  @override
  State<PirateTreasureHuntMapWidget> createState() =>
      _PirateTreasureHuntMapWidgetState();
}

class _PirateTreasureHuntMapWidgetState
    extends State<PirateTreasureHuntMapWidget> {
  static const double mapWidth = 550;
  static const double mapHeight = 450;
  static const int itemsPerPage = 8;

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TreasureMapItem> foundItems = [
      TreasureMapItem(
        islandIndex: 1,
        type: MapItemType.girl,
        isUnlocked: true,
        isCurrent: false,
        width: 120,
        height: 74,
      ),
      TreasureMapItem(
        islandIndex: 2,
        type: MapItemType.girl,
        isUnlocked: true,
        isCurrent: true,
        width: 64,
        height: 80,
      ),
      TreasureMapItem(
        islandIndex: 3,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 65,
        height: 55,
      ),
      TreasureMapItem(
        islandIndex: 4,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 69,
        height: 43.37,
      ),
      TreasureMapItem(
        islandIndex: 5,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 95,
        height: 77,
      ),
      TreasureMapItem(
        islandIndex: 6,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 97.24,
        height: 56.67,
      ),
      TreasureMapItem(
        islandIndex: 7,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 95,
        height: 45,
      ),
      TreasureMapItem(
        islandIndex: 8,
        type: MapItemType.question,
        isUnlocked: true,
        isCurrent: false,
        width: 56,
        height: 42,
      ),
      TreasureMapItem(
        islandIndex: 1,
        type: MapItemType.girl,
        isUnlocked: true,
        isCurrent: false,
        width: 120,
        height: 74,
      ),
    ];

    final pageCount = _calculatePageCount(foundItems.length);
    final visibleItems = _buildVisibleItems(foundItems, pageCount);

    final mapRouteWidth = mapWidth - 125;
    final mapRouteHeight = mapHeight - 180;

    final totalWidth = pageCount * mapRouteWidth;

    return FutureBuilder(future: () async {
      precacheImage(
        AssetImage(AppLocalImages.pirateTreasureHuntMap),
        context,
      );
      precacheImage(
        AssetImage(AppLocalImages.pirateTreasureHuntMapRoute),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island1.svg'),
        context,
      );
      precacheImage(
        AssetImage(
            'assets/images/pirate_treasure_hunt/islands/treasure-ship.svg'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island3.svg'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island4.png'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island5.svg'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island6.svg'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island7.svg'),
        context,
      );
      precacheImage(
        AssetImage('assets/images/pirate_treasure_hunt/islands/island8.svg'),
        context,
      );
    }(), builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return Center(
            child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            width: mapWidth,
            height: mapHeight,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
      }
      return Center(
          child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SizedBox(
          width: mapWidth,
          height: mapHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppLocalImages.pirateTreasureHuntMap,
                  fit: BoxFit.fill,
                  repeat: ImageRepeat.repeatX,
                  alignment: Alignment.centerLeft,
                ),
              ),
              Positioned(
                left: 65,
                top: 100,
                child: SizedBox(
                  width: mapRouteWidth,
                  height: mapRouteHeight,
                  child: Scrollbar(
                    controller: _controller,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalWidth,
                        height: mapRouteHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppLocalImages.pirateTreasureHuntMapRoute,
                                width: mapRouteWidth,
                                height: mapRouteHeight,
                                repeat: ImageRepeat.repeatX,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            for (final entry in visibleItems)
                              TeasureHuntMapItemWidget(
                                item: entry.item,
                                pageIndex: entry.pageIndex,
                                slotIndex: entry.slotIndex,
                                pageWidth: mapRouteWidth,
                                pageHeight: mapRouteHeight,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    });
  }

  int _calculatePageCount(int foundCount) {
    int pageCount = math.max(1, (foundCount / itemsPerPage).ceil());
    if (foundCount > 0 && foundCount % itemsPerPage == 0) {
      pageCount += 1;
    }
    return pageCount;
  }

  List<TreasureMapEntry> _buildVisibleItems(
    List<TreasureMapItem> foundItems,
    int pageCount,
  ) {
    final List<TreasureMapEntry> out = [];

    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      for (int slotIndex = 0; slotIndex < itemsPerPage; slotIndex++) {
        final globalIndex = pageIndex * itemsPerPage + slotIndex;

        if (globalIndex < foundItems.length) {
          out.add(TreasureMapEntry(
            item: foundItems[globalIndex],
            pageIndex: pageIndex,
            slotIndex: slotIndex,
          ));
        } else {
          final isFirstPlaceholder = globalIndex == foundItems.length;

          out.add(TreasureMapEntry(
            item: _questionPlaceholder(
              islandIndex: globalIndex + 1,
              isCurrent: isFirstPlaceholder,
            ),
            pageIndex: pageIndex,
            slotIndex: slotIndex,
          ));
        }
      }
    }
    return out;
  }

  TreasureMapItem _questionPlaceholder({
    required int islandIndex,
    bool isCurrent = false,
  }) {
    return TreasureMapItem(
      islandIndex: islandIndex,
      type: MapItemType.question,
      isUnlocked: false,
      isCurrent: isCurrent,
      width: 40,
      height: 40,
    );
  }
}
