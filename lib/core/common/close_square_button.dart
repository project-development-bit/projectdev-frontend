import 'package:flutter/material.dart';

class CloseSquareButton extends StatefulWidget {
  final VoidCallback onTap;

  const CloseSquareButton({super.key, required this.onTap});

  @override
  State<CloseSquareButton> createState() => _CloseSquareButtonState();
}

class _CloseSquareButtonState extends State<CloseSquareButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    const Color normalColor = Color(0xFFF4C236);
    const Color hoverColor = Color(0xFFFFE27A);

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: isHover ? hoverColor : normalColor,
              width: 0.5,
            ),
            color: isHover ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12), // Rounded square
          ),
          child: Center(
            child: Icon(
              Icons.close,
              size: 22,
              color: isHover ? Colors.black : normalColor,
            ),
          ),
        ),
      ),
    );
  }
}
