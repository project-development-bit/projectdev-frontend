import 'package:gigafaucet/core/common/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem extends StatelessWidget {
  final int index;
  final String label;
  final String iconPath;
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavItem({
    super.key,
    required this.index,
    required this.label,
    required this.iconPath,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = index == currentIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              isActive ? colorScheme.primary : colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 3),
          CommonText.titleSmall(
            label,
            color: isActive ? colorScheme.primary : colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
