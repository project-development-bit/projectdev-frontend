import 'package:flutter/material.dart';

class HomeSectionContainer extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final BoxDecoration? decoration;
  const HomeSectionContainer(
      {super.key,
      required this.child,
      this.width,
      this.height,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: width ?? double.infinity,
      height: height,
      child: child,
    );
  }
}
