import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showFortuneWheelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: 600,
        width: 600,
        child: FortuneWheelWidget(),
      ),
    ),
  );
}

final wheelProvider = StateProvider<int>((ref) {
  return 0;
});

class FortuneWheelWidget extends StatefulWidget {
  const FortuneWheelWidget({super.key});

  @override
  State<FortuneWheelWidget> createState() => _FortuneWheelWidgetState();
}

class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
  StreamController<int> selected = StreamController<int>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          width: 400,
          child: FortuneWheel(
              indicators: [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: Colors.red,
                  ),
                ),
              ],
              
              styleStrategy: UniformStyleStrategy(
                borderColor: Colors.black,
                borderWidth: 2,
              ),
              animateFirst: false,
              physics: CircularPanPhysics(
                duration: Duration(seconds: 4),
                curve: Curves.decelerate,
              ),
              rotationCount: 20,
              selected: selected.stream,
              onAnimationStart: () {
                // Do something when the animation starts
              },
              onAnimationEnd: () {},
              items: List.generate(10, (v) {
                return FortuneItem(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 8),
                    Text('Prize $v'),
                  ],
                ));
              })),
        ),
        MaterialButton(
          onPressed: () {
            final random = (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 5;

            setState(() {
              selected.add(random);
            });
          },
          child: Text('Close'),
          color: Colors.blue,
        )
      ],
    );
  }
}
