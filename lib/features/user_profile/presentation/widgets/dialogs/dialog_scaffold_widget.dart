import 'package:flutter/material.dart';

class DialogScaffoldWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const DialogScaffoldWidget({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: padding ?? const EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
        child: child);
  }
}
