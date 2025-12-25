import 'package:gigafaucet/core/common/common_text.dart';
import 'package:flutter/material.dart';

class ParentItemWidget extends StatefulWidget {
  final String label;
  final bool isOpen;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const ParentItemWidget({
    super.key,
    required this.label,
    required this.isOpen,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<ParentItemWidget> createState() => _ParentItemWidgetState();
}

class _ParentItemWidgetState extends State<ParentItemWidget> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;

    final color = isHovering
        ? Color(0xFFFFd530) //TODO: use from theme
        : widget.isOpen
            ? colorScheme.primary
            : colorScheme.onPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding:
              const EdgeInsets.only(left: 18, right: 9.5, top: 18, bottom: 18),
          child: Row(
            children: [
              Expanded(
                child: CommonText.bodyLarge(
                  widget.label,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Transform.rotate(
                angle: widget.isOpen ? 3.1416 : 0,
                child: Icon(Icons.keyboard_arrow_down, size: 20, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
