import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ReferralStatCard extends StatelessWidget {
  final String label;
  final String value;

  const ReferralStatCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: context.isMobile ? double.infinity : 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.bodySmall(label, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 8),
          CommonText.titleMedium(
            value,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
