import 'package:flutter/material.dart';

class HomeSectionContainer extends StatelessWidget {
  final Widget child;
  final double? width, height;
  const HomeSectionContainer(
      {super.key, required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: child,
    );
  }
}
