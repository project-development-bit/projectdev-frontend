import 'package:flutter_svg/svg.dart';
import 'package:gigafaucet/core/common/common_loading_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_map_widget.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_process_widget.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/unlock_your_treasure_widget.dart';

void showPirateTreasureHuntDialog(
  BuildContext context,
) {
  context.showManagePopup(
    child: PirateTreasureHuntDialog(),
    barrierDismissible: true,
  );
}

class PirateTreasureHuntDialog extends ConsumerStatefulWidget {
  const PirateTreasureHuntDialog({
    super.key,
  });

  @override
  ConsumerState<PirateTreasureHuntDialog> createState() =>
      _Disable2FAConfirmationDialogState();
}

class _Disable2FAConfirmationDialogState
    extends ConsumerState<PirateTreasureHuntDialog> {
  final svgPaths = {
    AppLocalImages.island2,
    AppLocalImages.island5,
    AppLocalImages.island7,
  };

  final rasterPaths = {
    AppLocalImages.pirateTreasureHuntMap,
    AppLocalImages.pirateTreasureHuntMapRoute,
    AppLocalImages.pirateTreasureHuntMapGirl,
    AppLocalImages.questionMark,
    AppLocalImages.island1,
    AppLocalImages.island3,
    AppLocalImages.island4,
    AppLocalImages.island6,
    AppLocalImages.island8,
  };

  Future<void> _precacheAssets() async {
    debugPrint('🚀 precacheAssets Starting asset precaching...');
    try {
      await Future.wait([
        ...svgPaths.map((path) => _precacheSvg(path)),
        ...rasterPaths.map((path) => precacheImage(AssetImage(path), context)),
      ]);
      debugPrint('✅ precacheAssets All assets precached successfully.');
    } catch (e) {
      debugPrint('❌ precacheAssets Error during asset precaching: $e');
      // Handle errors if necessary
    }
  }

  Future<void> _precacheSvg(String assetPath) async {
    final loader = SvgAssetLoader(assetPath);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

  late Future<void> _loadFuture;
  bool _startedLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_startedLoading) {
      _startedLoading = true;
      _loadFuture = _precacheAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
      dialogHeight: context.isDesktop
          ? 450
          : context.isTablet
              ? 500
              : 610,
      title: context.translate("Pirate Treasure Hunt"),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.isMobile || context.isTablet
              ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
              : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: CommonText.bodyMedium(
                  context.translate('Find hidden treasure by completing tasks'),
                  color: Color(0xFF98989A),
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 24),
              PirateTreasureHuntProcessWidget(),
              const SizedBox(height: 16),
              FutureBuilder(
                future: _loadFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return SizedBox(
                      height: 450,
                      width: 550,
                      child: Center(child: CommonLoadingWidget.small()),
                    );
                  }

                  return const PirateTreasureHuntMapWidget();
                },
              ),

              // PirateTreasureHuntMapWidget(),
              const SizedBox(height: 16),
              UnlockYourTreasureWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
