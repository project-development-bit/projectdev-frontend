import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class CustomPointerInterceptor extends StatelessWidget {
  const CustomPointerInterceptor({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: child,
    );
  }
}
