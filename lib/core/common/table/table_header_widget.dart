import 'package:gigafaucet/core/common/common_text.dart';
import 'package:flutter/material.dart';

class TableHeaderWidget extends StatelessWidget {
  const TableHeaderWidget({
    super.key,
    required this.headers,
    this.padding,
    this.fontWeight,
    this.fontColor,
    this.fontSize,
  });
  final List<String> headers;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final Color? fontColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: headers.map((e) {
          return Expanded(
            flex: 1,
            child: CommonText.bodyMedium(
              e,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: fontColor ??
                  const Color(0xFF98989A), //TODO: use Color From Scheme
              fontSize: fontSize,
            ),
          );
        }).toList(),
      ),
    );
  }
}
