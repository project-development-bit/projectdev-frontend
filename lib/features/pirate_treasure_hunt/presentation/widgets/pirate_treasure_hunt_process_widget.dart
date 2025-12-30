import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/common/common_text.dart' show CommonText;
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart'
    show MediaQueryExtension, ColorSchemeExtension;
import 'package:gigafaucet/core/theme/app_typography.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart'
    show LocalizationHelper;
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';

class PirateTreasureHuntProcessWidget extends ConsumerWidget {
  const PirateTreasureHuntProcessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobile;
    final colorScheme = Theme.of(context).colorScheme;

    final treasureHuntStatus = ref.watch(treasureHuntStatusNotifierProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.4,
          color: const Color(0xFF333333),
        ),
        image: DecorationImage(
          image: AssetImage(AppLocalImages.pirateTreasureHuntProcessBg),
          fit: isMobile ? BoxFit.cover : BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          CommonText.headlineSmall(
            context.translate("Hunt Progress"),
            fontWeight: FontWeight.w700,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 23),
          _StepProgressIndicator(
            totalSteps: 3,
            currentStep: treasureHuntStatus.data?.currentStep ?? 1,
          ),
          const SizedBox(height: 10),
          StatusBadge(
            label: context.translate("Status"),
            statusText: context.translate("Ready"),
            statusColor: const Color(0xFF22C55E),
          ),
          if (!(treasureHuntStatus.data?.canStart ?? true) &&
              (treasureHuntStatus.data?.status != "in_progress")) ...[
            const SizedBox(height: 10),
            CommonText.titleMedium(
              context.translate(
                  'Next Hunt Unlocks In - [${treasureHuntStatus.data?.cooldownUntil}]'),
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color statusColor;
  final String statusText;

  const StatusBadge({
    super.key,
    this.label = 'Status',
    this.statusText = 'Ready',
    this.statusColor = const Color(0xFF4AC97E), // green
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F14), // dark background
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Color(0xFF333333),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: '$label : ',
              style: TextStyle(
                color: context.onSurface,
              ),
            ),
            TextSpan(
              text: statusText,
              style: TextStyle(
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const _StepProgressIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  static const Color activeColor = Color(0xFFFFCC00);
  static const Color inactiveColor = Color(0xFF262626);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Step circle
        if (index.isEven) {
          final step = index ~/ 2 + 1;
          final isActive = step <= currentStep;

          return _StepCircle(
            number: step,
            isActive: isActive,
          );
        }
        return _StepLine(
          isActive: (index ~/ 2 + 1) < currentStep,
        );
      }),
    );
  }
}

/* ------------------ Step Circle ------------------ */

class _StepCircle extends StatelessWidget {
  final int number;
  final bool isActive;

  const _StepCircle({
    required this.number,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? _StepProgressIndicator.activeColor
            : _StepProgressIndicator.inactiveColor,
        border: Border.all(
          color: _StepProgressIndicator.activeColor,
          width: 2,
        ),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.black : _StepProgressIndicator.activeColor,
        ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 2,
      color: _StepProgressIndicator.activeColor,
    );
  }
}
