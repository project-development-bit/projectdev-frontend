import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class CustomUnderLineButtonWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  final bool isActive;
  final bool isDisabled;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;

  const CustomUnderLineButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
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
    // ---- 🎨 DESIGN SYSTEM COLORS ----
    const defaultBg = Color(0xFFFFCC02); // Default
    const defaultShadow = Color(0xFFB29F2C);

    const hoverBg = Color(0xFFFFD530); // Hover
    const hoverShadow = Color(0xFFC8AA28);

    const activeBg = Color(0xFFE0B702); // Active
    const activeShadow = Color(0xFFA18F24);

    const disabledBg = Color(0xFFE8DCA6); // Disabled
    const disabledShadow = Color(0xFFD3C893);

    const textColor = Color(0xFF333333);
    const disabledTextColor = Color(0xFF8C8C8C);

    // ---- 🎛 STATE LOGIC ----
    final bool isDisabled = widget.isDisabled || widget.onTap == null;

    Color bgColor;
    Color shadowColor;
    Color finalTextColor;

    if (isDisabled) {
      bgColor = disabledBg;
      shadowColor = disabledShadow;
      finalTextColor = disabledTextColor;
    } else if (_isHovering) {
      bgColor = hoverBg;
      shadowColor = hoverShadow;
      finalTextColor = textColor;
    } else if (widget.isActive) {
      bgColor = activeBg;
      shadowColor = activeShadow;
      finalTextColor = textColor;
    } else {
      bgColor = defaultBg;
      shadowColor = defaultShadow;
      finalTextColor = textColor;
    }

    return MouseRegion(
      onEnter: (_) => !isDisabled ? setState(() => _isHovering = true) : null,
      onExit: (_) => !isDisabled ? setState(() => _isHovering = false) : null,
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height ?? 48,
          width: widget.width,
          margin: widget.margin,
          padding: widget.padding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
            border: Border(
              bottom: BorderSide(
                color: shadowColor,
                width: 5,
              ),
            ),
          ),
          child: Center(
            child: CommonText.titleMedium(
              widget.title,
              fontSize: widget.fontSize ?? 18,
              fontWeight: widget.fontWeight ?? FontWeight.w700,
              color: finalTextColor,
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
