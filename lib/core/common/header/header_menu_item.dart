import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class HeaderMenuItem extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const HeaderMenuItem({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  State<HeaderMenuItem> createState() => _HeaderMenuItemState();
}

class _HeaderMenuItemState extends State<HeaderMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = context.screenWidth;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 1100 ? 16 : 3, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              CommonText.bodyLarge(
                widget.label,
                color: isHovered ? colorScheme.primary : colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: isHovered ? colorScheme.primary : colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
