import 'package:cointiply_app/core/common/common_text.dart';
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

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              CommonText.titleMedium(
                widget.label,
                color: isHovered ? colorScheme.primary : colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 2),
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
