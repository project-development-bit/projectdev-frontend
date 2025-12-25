import 'package:gigafaucet/core/common/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarMenuItem extends ConsumerWidget {
  const TabBarMenuItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.width,
    required this.text,
    required this.onTap,
  });
  final int index;
  final bool isSelected;
  final double width;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  width: 1,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
        ),
        child: Center(
          child: CommonText.titleMedium(
            text,
            fontWeight: FontWeight.w700,
            fontSize: isSelected ? 16 : 14,
            color:
                isSelected ? const Color(0xff333333) : const Color(0xff98989A),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
