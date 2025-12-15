import 'package:flutter/material.dart';

class DialogScaffoldWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const DialogScaffoldWidget({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          insetPadding: padding ?? const EdgeInsets.all(20),
          clipBehavior: Clip.hardEdge,
          child: child),
    );
  }
}
