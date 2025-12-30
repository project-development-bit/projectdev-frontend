import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  // =====================
  // Constants
  // =====================
  static const double mapWidth = 550;
  static const double mapHeight = 450;
  static const int itemsPerPage = 8;

  static const double routeLeft = 65;
  static const double routeTop = 100;
  static const double routeWidthOffset = 125;
  static const double routeHeightOffset = 180;

  late final ScrollController _controller;
  late final Future<void> _precacheFuture;

  // =====================
  // Lifecycle
  // =====================
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  bool _isInit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      _precacheFuture = _precacheAssets();
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // =====================
  // Asset Preload (Raster ONLY)
  // =====================
// =====================
  // Asset Preload
  // =====================
  Future<void> _precacheAssets() async {
    try {
      final rasterPaths = {
        AppLocalImages.pirateTreasureHuntMap,
        AppLocalImages.pirateTreasureHuntMapRoute,
        AppLocalImages.pirateTreasureHuntMapGirl,
        AppLocalImages.questionMark,
        AppLocalImages.island4,
      };

      final svgPaths = {
        AppLocalImages.island1,
        AppLocalImages.island2,
        AppLocalImages.island3,
        AppLocalImages.island5,
        AppLocalImages.island6,
        AppLocalImages.island7,
        AppLocalImages.island8,
      };

      await Future.wait([
        ...rasterPaths.map((path) => precacheImage(AssetImage(path), context)),
        ...svgPaths.map((path) => _precacheSvg(path)),
      ]);
    } catch (e) {
      debugPrint('Error precaching assets: $e');
    }
  }

  Future<void> _precacheSvg(String assetPath) async {
    final loader = SvgAssetLoader(assetPath);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

  // =====================
  // Build
  // =====================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _precacheFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            width: mapWidth,
            height: mapHeight,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          );
        }

        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: mapWidth,
              height: mapHeight,
              child: _buildMap(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    final foundItems = _mockFoundItems();
    final pageCount = _calculatePageCount(foundItems.length);
    final entries = _buildVisibleItems(foundItems, pageCount);

    final routeWidth = mapWidth - routeWidthOffset;
    final routeHeight = mapHeight - routeHeightOffset;
    final totalWidth = pageCount * routeWidth;

    return Stack(
      children: [
        // Background map
        Positioned.fill(
          child: Image.asset(
            AppLocalImages.pirateTreasureHuntMap,
            fit: BoxFit.fill,
            gaplessPlayback: true,
          ),
        ),

        // Scrollable route
        Positioned(
          left: routeLeft,
          top: routeTop,
          child: SizedBox(
            width: routeWidth,
            height: routeHeight,
            child: Scrollbar(
              controller: _controller,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: totalWidth,
                  height: routeHeight,
                  child: Stack(
                    children: [
                      // Route image
                      Positioned.fill(
                        child: Image.asset(
                          AppLocalImages.pirateTreasureHuntMapRoute,
                          repeat: ImageRepeat.repeatX,
                          alignment: Alignment.centerLeft,
                          gaplessPlayback: true,
                        ),
                      ),

                      // Items
                      for (final entry in entries)
                        TeasureHuntMapItemWidget(
                          item: entry.item,
                          pageIndex: entry.pageIndex,
                          slotIndex: entry.slotIndex,
                          pageWidth: routeWidth,
                          pageHeight: routeHeight,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =====================
  // Data Helpers
  // =====================
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

  // =====================
  // Mock Data
  // =====================
  List<TreasureMapItem> _mockFoundItems() {
    return [
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
    ];
  }
}
