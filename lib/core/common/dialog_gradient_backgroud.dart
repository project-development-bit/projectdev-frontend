import 'dart:ui';

import 'package:flutter/material.dart';

class DialogGradientBackground extends StatelessWidget {
  const DialogGradientBackground({super.key, this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 580,
      height: height ?? 680,
      child: Stack(
        children: [
          Container(
            width: width ?? 580,
            height: height ?? 680,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00131E),
                  Color(0xFF1E005E),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            // child: const ProfileDialogContent(),
          ),
          Positioned(
              top: 46,
              left: 26,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF00C7).withValues(alpha: 0.5),
                      Color(0xFF02005A),
                    ],
                  ),
                ),
              )),
          Positioned(
              bottom: 0,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.centerLeft,
                    radius: 1.0,
                    colors: [
                      Color(0xFFFA0A8C).withValues(alpha: 0.1),
                      Color(0xFFFA0A8C).withValues(alpha: 0.4),
                    ],
                  ),
                ),
              )),
          Positioned(
              bottom: 46,
              left: -26,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1400FF).withValues(alpha: 0.6)),
              )),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: SizedBox(
              width: width ?? 580,
              height: height ?? 680,
            ),
          ))
        ],
      ),
    );
  }
}
