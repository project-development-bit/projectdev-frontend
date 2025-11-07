import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class LevelProcessBarWidget extends StatelessWidget {
  const LevelProcessBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    const currentLevel = 1;
    const nextLevel = currentLevel + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/levels/hodler.png",
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                CommonText.titleMedium(
                  localizations?.translate("level_prefix",
                          args: ["$currentLevel"]) ??
                      "",
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            CommonText.titleMedium(
              localizations?.translate("level_prefix", args: ["$nextLevel"]) ??
                  "",
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: 0.4,
            minHeight: 10,
            backgroundColor: colorScheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation(colorScheme.primary),
          ),
        ),
        const SizedBox(height: 12),
        CommonText.bodySmall(
          localizations?.translate("level_progress_description") ?? "",
          color: colorScheme.onSurfaceVariant,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
