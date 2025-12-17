import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomUnderLineButtonWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final bool isActive;
  final bool isDisabled;
  final bool isDark;
  final bool isRed;
  final bool isViolet;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;

  final Color? fontColor;
  final Color? borderColor;
  final Gradient? gradient;
  final bool isLoading;
  const CustomUnderLineButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.isActive = false,
    this.isDisabled = false,
    this.isDark = false,
    this.isRed = false,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.fontColor,
    this.borderColor,
    this.gradient,
    this.isViolet = false,
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
    } else if (widget.isViolet) {
      bgColor = Color(0xff9D46B6);
      shadowColor = Color(0xFF6F1F86);
      finalTextColor = context.primary;
    } else if (widget.isRed) {
      bgColor = Color(0xffB02419);
      shadowColor = Color(0xFF7A1B12);
      finalTextColor = Color(0xFFFFFFFF);
    } else if (widget.isDark) {
      bgColor = Color(0xFF333333);
      shadowColor = Color(0xFF262626);
      finalTextColor = Color(0xFF98989A);
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
          padding: widget.isLoading
              ? EdgeInsets.zero
              : widget.padding ??
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
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        finalTextColor,
                      ),
                    ),
                  ),
                )
              : CommonText.titleMedium(
                  widget.title,
                  fontSize: widget.fontSize ?? 18,
                  fontWeight: widget.fontWeight ?? FontWeight.w700,
                  color: finalTextColor,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}

class CustomButtonWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isActive;
  final bool isDisabled;
  final bool isOutlined;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;

  const CustomButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.padding,
    this.margin,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
  });

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Solid button colors
    const defaultBg = Color(0xFFFFCC02);
    const hoverBg = Color(0xFFFFD530);
    const activeBg = Color(0xFFE0B702);
    const disabledBg = Color(0xFFE8DCA6);

    const textColor = Color(0xFF333333);
    const disabledTextColor = Color(0xFF8C8C8C);

    // Outlined button colors
    // const outlineColor = Color(0xFFFFCC02);
    const outlineHoverColor = Color(0xFFFFD530);
    const outlineDisabledBorder = Color(0xFFD3D3D3);

    final bool isDisabled = widget.isDisabled || widget.onTap == null;

    Color bgColor = Colors.transparent;
    Color txtColor = textColor;
    Color borderColor = Colors.transparent;

    if (widget.isOutlined) {
      if (isDisabled) {
        borderColor = outlineDisabledBorder;
        txtColor = disabledTextColor;
      } else if (widget.isActive) {
        if (_isHovering) {
          bgColor = outlineHoverColor;
        } else {
          bgColor = activeBg;
          txtColor = textColor;
        }
      } else if (_isHovering) {
        borderColor = outlineHoverColor;
        txtColor = outlineHoverColor;
      } else {
        borderColor = const Color(0xFF333333);
        txtColor = const Color(0xFF98989A);
      }
    } else {
      if (isDisabled) {
        bgColor = disabledBg;
        txtColor = disabledTextColor;
      } else if (_isHovering) {
        bgColor = hoverBg;
        txtColor = textColor;
      } else if (widget.isActive) {
        bgColor = activeBg;
        txtColor = textColor;
      } else {
        bgColor = defaultBg;
        txtColor = textColor;
      }
    }

    return MouseRegion(
      onEnter: (_) => !isDisabled ? setState(() => _isHovering = true) : null,
      onExit: (_) => !isDisabled ? setState(() => _isHovering = false) : null,
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: widget.width,
          margin: widget.margin,
          padding: widget.padding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: widget.isOutlined
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
          child: Center(
            child: CommonText.titleMedium(
              widget.title,
              fontSize: widget.fontSize ?? 18,
              fontWeight: widget.fontWeight ?? FontWeight.w700,
              color: txtColor,
              maxLines: widget.maxLines,
            ),
          ),
        ),
      ),
    );
  }
}
