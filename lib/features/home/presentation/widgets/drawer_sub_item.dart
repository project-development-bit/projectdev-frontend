import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerSubItem extends StatefulWidget {
  const DrawerSubItem({
    super.key,
    required this.label,
    required this.route,
    required this.onTap,
  });
  final String label;
  final String route;
  final VoidCallback onTap;

  @override
  State<DrawerSubItem> createState() => _DrawerSubItemState();
}

class _DrawerSubItemState extends State<DrawerSubItem> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final currentRoute = GoRouterState.of(context).uri.toString();
    final currentRoute = "/daily-rewards";
    final bool isActive = currentRoute.startsWith(widget.route);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          context.pop();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 3,
                height: 28,
                margin: const EdgeInsets.only(left: 19, right: 12),
                decoration: BoxDecoration(
                  color: isActive ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // --- Label ---
              CommonText.bodyLarge(
                widget.label,
                color: isHovering
                    ? Color(0xFFFFd530) //TODO: use from theme
                    : isActive
                        ? colorScheme.primary
                        : const Color(0xFF98989A), //TODO: use from theme
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
