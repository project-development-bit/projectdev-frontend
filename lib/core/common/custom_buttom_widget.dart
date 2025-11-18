import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

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
          gradient: LinearGradient(
            colors: [
              if (isActive)
                Color(0xFFFFCC02)
              else
                Color(0xFF333333), //TODO use from theme
              if (isActive)
                Color(0xFFFFCC02)
              else
                Color(0xFF333333), //TODO use from theme
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              // TODO use from theme
              color: isActive ? Color(0xFFB28F0C) : Color(0xFF262626),
              width: 5,
            ),
          ),
        ),
        child: Center(
          child: CommonText.titleMedium(
            title,
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w700,
            color: isActive
                ? Color(0xFF333333) //TODO use from theme
                : Color(0xFF98989A), //TODO use from theme
          ),
        ),
      ),
    );
  }
}
