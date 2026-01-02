import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/data/utils/treasure_map_builder.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';
import 'teasure_hunt_map_item_widget.dart';

class PirateTreasureHuntMapWidget extends ConsumerStatefulWidget {
  const PirateTreasureHuntMapWidget({super.key});

  @override
  ConsumerState<PirateTreasureHuntMapWidget> createState() =>
      _PirateTreasureHuntMapWidgetState();
}

class _PirateTreasureHuntMapWidgetState
    extends ConsumerState<PirateTreasureHuntMapWidget> {
  // =====================
  // Constants
  // =====================
  static const double mapWidth = 550;
  static const double mapHeight = 450;
  // static const int itemsPerPage = 8;

  static const double routeLeft = 65;
  static const double routeTop = 100;
  static const double routeWidthOffset = 125;
  static const double routeHeightOffset = 180;

  late final ScrollController _controller;

  double _dragStartX = 0;
  double _scrollStartX = 0;

  // =====================
  // Lifecycle
  // =====================
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

  // =====================
  // Build
  // =====================
  @override
  Widget build(BuildContext context) {
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
  }

  Widget _buildMap() {
    final historyState = ref.watch(treasureHuntHistoryNotifierProvider);

    if (!historyState.isSuccess || historyState.data == null) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final entries = buildMapEntriesFromHistory(historyState.data!.items);

    final pageCount = calculatePageCount(historyState.data!.items.length);
    final routeWidth = mapWidth - routeWidthOffset;
    final routeHeight = mapHeight - routeHeightOffset;
    final totalWidth = pageCount * routeWidth;

    return Center(
      child: SizedBox(
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
            Positioned(
              left: routeLeft,
              top: routeTop,
              child: SizedBox(
                width: routeWidth,
                height: routeHeight,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (details) {
                      _dragStartX = details.globalPosition.dx;
                      _scrollStartX = _controller.offset;
                    },
                    onHorizontalDragUpdate: (details) {
                      final delta = _dragStartX - details.globalPosition.dx;
                      final newOffset = (_scrollStartX + delta)
                          .clamp(0.0, _controller.position.maxScrollExtent);

                      _controller.jumpTo(newOffset);
                    },
                    child: SingleChildScrollView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
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
            ),
          ],
        ),
      ),
    );
  }
}
