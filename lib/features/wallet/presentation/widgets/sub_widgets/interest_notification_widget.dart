import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class InterestNotificationWidget extends StatelessWidget {
  const InterestNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary,
          width: 0.5,
        ),
        color: Color(0xFF0C0B38),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyMedium(
                  localizations?.translate('interest_notification_title') ??
                      "Don’t miss out on 5% interest!",
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                CommonText.bodySmall(
                  localizations
                          ?.translate('interest_notification_description') ??
                      "Keep at least 35,000 Coins to earn 5% interest. Interest is paid every week. Turn it on in your settings.",
                  color: Color(0xFF98989A),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
