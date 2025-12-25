import 'package:flutter/material.dart';
import 'package:gigafaucet/core/common/common_text.dart';

class FooterSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Map<String, VoidCallback>? actions;

  const FooterSection({
    super.key,
    required this.title,
    required this.items,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 50, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.bodyMedium(
            title,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          const SizedBox(height: 31),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: actions?[item],
                  child: CommonText.bodyMedium(
                    item,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
