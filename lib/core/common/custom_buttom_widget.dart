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
    final hoverColor =
        const Color(0xFFFFD530); // TODO: to use Color from scheme
    final bottomHoverColor =
        const Color(0xFFC8AA28); // TODO: to use Color from scheme
    final defaultBorderColor =
        const Color(0xFF262626); // TODO: to use Color from scheme

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
                          ? const Color(
                              0xFFFFCC02) // TODO: to use Color from scheme
                          : const Color(
                              0xFF333333), // TODO: to use Color from scheme
                  _isHovering
                      ? hoverColor
                      : widget.isActive
                          ? const Color(
                              0xFFFFCC02) // TODO: to use Color from scheme
                          : const Color(
                              0xFF333333), // TODO: to use Color from scheme
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
                color: _isHovering
                    ? const Color(0xFF333333) // TODO: to use Color from scheme
                    : widget.textColor ??
                        (widget.isActive
                            ? const Color(
                                0xFF333333) // TODO: to use Color from scheme
                            : const Color(
                                0xFF98989A)), // TODO: to use Color from scheme
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWidget extends StatefulWidget {
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
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor =
        const Color(0xFFFFD530); // TODO: to use Color from scheme

    final activeBg = const Color(0xFFFFCC02); // TODO: to use Color from scheme
    final inactiveBorder =
        const Color(0xFF333333); // TODO: to use Color from scheme

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: widget.width,
            margin: widget.margin,
            padding: widget.padding ??
                const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

              /// HOVER + ACTIVE rules
              gradient: _isHovering
                  ? LinearGradient(colors: [hoverColor, hoverColor])
                  : widget.isActive
                      ? LinearGradient(colors: [activeBg, activeBg])
                      : null,

              border: widget.isActive
                  ? null
                  : Border.all(
                      color: _isHovering ? hoverColor : inactiveBorder,
                      width: 1.5,
                    ),
            ),
            child: Center(
              child: CommonText.titleMedium(
                widget.title,
                fontSize: widget.fontSize ?? 18,
                fontWeight: widget.fontWeight ?? FontWeight.w700,
                color: widget.isActive
                    ? const Color(
                        0xFF333333) // active text color// TODO: to use Color from scheme
                    : _isHovering
                        ? const Color(
                            0xFF333333) // hover text. // TODO: to use Color from scheme
                        : const Color(
                            0xFF98989A), // default text// TODO: to use Color from scheme
              ),
            ),
          ),
        ),
      ),
    );
  }
}
