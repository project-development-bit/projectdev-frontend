import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:flutter/material.dart';

class PirateTreasureHuntProcessWidget extends StatelessWidget {
  const PirateTreasureHuntProcessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile || isTablet ? 4 : 26,
        vertical: isMobile ? 8 : 21,
      ),
      margin: EdgeInsets.only(
        top: isMobile ? 26 : 40,
        bottom: isMobile ? 26 : 32,
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
            t?.translate("Hunt Progress") ?? "Hunt Progress",
            fontWeight: FontWeight.w700,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 18),
          StatusBadge(
            label: t?.translate("Status") ?? "Status",
            statusText: t?.translate("Ready") ?? "Ready",
            statusColor: const Color(0xFF22C55E),
          ),
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
          children: [
            TextSpan(
              text: '$label : ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            TextSpan(
              text: statusText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
