import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ProfileBonusesSection extends StatelessWidget {
  const ProfileBonusesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(context.isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            CommonText.titleLarge(
              "Under Development",
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Divider(color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 20),

            // Content placeholder
            CommonText.bodyMedium(
              'Profile bonuses will be available soon. Stay tuned!',
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
