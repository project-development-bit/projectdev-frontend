import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class LevelTierRowWidget extends StatefulWidget {
  const LevelTierRowWidget({super.key});

  @override
  State<LevelTierRowWidget> createState() => _LevelTierRowWidgetState();
}

class _LevelTierRowWidgetState extends State<LevelTierRowWidget> {
  int selectedIndex = 0;
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final levels = [
      {
        "title": localizations?.translate("level_hodler") ?? "",
        "range": localizations?.translate("level_hodler_range") ?? "",
        "image": "assets/images/levels/hodler.png",
      },
      {
        "title": localizations?.translate("level_staker") ?? "",
        "range": localizations?.translate("level_staker_range") ?? "",
        "image": "assets/images/levels/staker.png",
      },
      {
        "title": localizations?.translate("level_collector") ?? "",
        "range": localizations?.translate("level_collector_range") ?? "",
        "image": "assets/images/levels/collector.png",
      },
      {
        "title": localizations?.translate("level_whale") ?? "",
        "range": localizations?.translate("level_whale_range") ?? "",
        "image": "assets/images/levels/whale.png",
      },
      {
        "title": localizations?.translate("level_cryptolord") ?? "",
        "range": localizations?.translate("level_cryptolord_range") ?? "",
        "image": "assets/images/levels/cryptolord.png",
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerLow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = context.isMobile
              ? constraints.maxWidth / 2.2
              : constraints.maxWidth / 5.3;

          return Wrap(
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(levels.length, (index) {
              final level = levels[index];
              final isSelected = selectedIndex == index;
              final isHovered = hoveredIndex == index;

              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: cardWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : isHovered
                                ? colorScheme.primaryContainer
                                : Colors.transparent,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: colorScheme.primaryContainer,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        if (isHovered && !isSelected && !context.isMobile)
                          BoxShadow(
                            color: colorScheme.primaryContainer,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: context.isMobile ? -25 : -30,
                          child: Image.asset(
                            level["image"]!,
                            height: context.isMobile ? 60 : 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.isMobile ? 40 : 50,
                            bottom: 16,
                          ),
                          child: Column(
                            children: [
                              CommonText.titleMedium(
                                level["title"]!,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              CommonText.bodySmall(
                                level["range"]!,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
