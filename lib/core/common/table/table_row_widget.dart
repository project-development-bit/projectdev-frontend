import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class TableRowWidget extends StatelessWidget {
  final List<String> values;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final Color? fontColor;
  final double? fontSize;

  const TableRowWidget(
      {super.key,
      required this.values,
      this.padding,
      this.fontWeight,
      this.fontColor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: values.map((e) {
          return Expanded(
            child: CommonText.bodySmall(
              e,
              color: fontColor ??
                  const Color(0xFF808080), //TODO: use Color From Scheme
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          );
        }).toList(),
      ),
    );
  }
}
