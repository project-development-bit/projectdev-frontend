import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class CustomUnderLineButtonWidget extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final bool isActive;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomUnderLineButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.padding,
    this.margin,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.borderRadius,
  });

  @override
  State<CustomUnderLineButtonWidget> createState() =>
      _CustomUnderLineButtonWidgetState();
}

class _CustomUnderLineButtonWidgetState
    extends State<CustomUnderLineButtonWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor = const Color(0xFFB28F0C);
    final bottomHoverColor =
        Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1);
    final defaultBorderColor = const Color(0xFF262626);

    return MouseRegion(
      onHover: (_) {
        setState(() => _isHovering = true);
      },
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        // <-- IMPORTANT
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 120),
            height: widget.height,
            width: widget.width,
            margin: widget.margin,
            padding: widget.padding ??
                const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _isHovering
                      ? hoverColor
                      : widget.isActive
                          ? const Color(0xFFFFCC02)
                          : const Color(0xFF333333),
                  _isHovering
                      ? hoverColor
                      : widget.isActive
                          ? const Color(0xFFFFCC02)
                          : const Color(0xFF333333),
                ],
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              border: Border(
                bottom: BorderSide(
                  color: _isHovering
                      ? bottomHoverColor
                      : widget.isActive
                          ? hoverColor
                          : defaultBorderColor,
                  width: 5,
                ),
              ),
            ),
            child: Center(
              child: CommonText.titleMedium(
                widget.title,
                fontSize: widget.fontSize ?? 18,
                fontWeight: widget.fontWeight ?? FontWeight.w700,
                color: widget.textColor ??
                    (widget.isActive
                        ? const Color(0xFF333333)
                        : const Color(0xFF98989A)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.padding,
    this.margin,
    this.width,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 17,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isActive
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFFCC02),
                    Color(0xFFFFCC02),
                  ],
                )
              : null,
          border: isActive
              ? null
              : Border.all(
                  color: Color(0xFF333333), // subtle border same as screenshot
                  width: 1.5,
                ),
        ),
        child: Center(
          child: CommonText.titleMedium(
            title,
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w700,
            color: isActive ? const Color(0xFF333333) : const Color(0xFF98989A),
          ),
        ),
      ),
    );
  }
}
