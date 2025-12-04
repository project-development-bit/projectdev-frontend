import 'package:flutter/material.dart';

class DialogScaffoldWidget extends StatelessWidget {
  final Widget child;
  const DialogScaffoldWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: child),
        );
      }),
    );
  }
}
