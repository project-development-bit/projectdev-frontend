import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_actions_widget.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/widgets/pirate_treasure_hunt_process_widget.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning message
              CommonText.bodyMedium(
                context.translate('Find hidden treasure by completing tasks'),
                color: Color(0xFF98989A),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              PirateTreasureHuntProcessWidget(),
              const SizedBox(height: 16),
              Center(
                child: CommonText.titleLarge(
                  context.translate('Unlock [Your Treasure]'),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  fontSize: 32,
                ),
              ),
              Center(
                child: CommonText.bodyMedium(
                  context.translate(
                      'Complete [1] task to uncover the hidden treasure.'),
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
              PirateTreasureHuntActionsWidget(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
