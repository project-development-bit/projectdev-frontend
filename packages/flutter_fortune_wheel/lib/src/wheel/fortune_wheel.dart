part of 'wheel.dart';

enum HapticImpact { none, light, medium, heavy }

Offset _calculateWheelOffset(
    BoxConstraints constraints, TextDirection textDirection) {
  final smallerSide = getSmallerSide(constraints);
  var offsetX = constraints.maxWidth / 2;
  if (textDirection == TextDirection.rtl) {
    offsetX = offsetX * -1 + smallerSide / 2;
  }
  return Offset(offsetX, constraints.maxHeight / 2);
}

double _calculateSliceAngle(int index, int itemCount) {
  final anglePerChild = 2 * _math.pi / itemCount;
  final childAngle = anglePerChild * index;
  // first slice starts at 90 degrees, if 0 degrees is at the top.
  // The angle offset puts the center of the first slice at the top.
  final angleOffset = -(_math.pi / 2 + anglePerChild / 2);
  return childAngle + angleOffset;
}

double _calculateAlignmentOffset(Alignment alignment) {
  if (alignment == Alignment.topRight) {
    return _math.pi * 0.25;
  }

  if (alignment == Alignment.centerRight) {
    return _math.pi * 0.5;
  }

  if (alignment == Alignment.bottomRight) {
    return _math.pi * 0.75;
  }

  if (alignment == Alignment.bottomCenter) {
    return _math.pi;
  }

  if (alignment == Alignment.bottomLeft) {
    return _math.pi * 1.25;
  }

  if (alignment == Alignment.centerLeft) {
    return _math.pi * 1.5;
  }

  if (alignment == Alignment.topLeft) {
    return _math.pi * 1.75;
  }

  return 0;
}

class _WheelData {
  final BoxConstraints constraints;
  final int itemCount;
  final TextDirection textDirection;

  late final double smallerSide = getSmallerSide(constraints);
  late final double largerSide = getLargerSide(constraints);
  late final double sideDifference = largerSide - smallerSide;
  late final Offset offset = _calculateWheelOffset(constraints, textDirection);
  late final Offset dOffset = Offset(
    (constraints.maxHeight - smallerSide) / 2,
    (constraints.maxWidth - smallerSide) / 2,
  );
  late final double diameter = smallerSide;
  late final double radius = diameter / 2;
  late final double itemAngle = 2 * _math.pi / itemCount;

  _WheelData({
    required this.constraints,
    required this.itemCount,
    required this.textDirection,
  });
}

enum FortuneWheelStatus {
  idle,
  animating,
  completed,
}

class FortuneReward {
  final int id;
  final FortuneWheelStatus status;

  FortuneReward({required this.id, required this.status});
}

/// A fortune wheel visualizes a (random) selection process as a spinning wheel
/// divided into uniformly sized slices, which correspond to the number of
/// [items].
///
/// ![](https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-wheel-256.png?sanitize=true)
///
/// See also:
///  * [FortuneBar], which provides an alternative visualization
///  * [FortuneWidget()], which automatically chooses a fitting widget
///  * [Fortune.randomItem], which helps selecting random items from a list
///  * [Fortune.randomDuration], which helps choosing a random duration
class FortuneWheel extends HookWidget implements FortuneWidget {
  /// The default value for [indicators] on a [FortuneWheel].
  /// Currently uses a single [TriangleIndicator] on [Alignment.topCenter].
  static const List<FortuneIndicator> kDefaultIndicators = <FortuneIndicator>[
    FortuneIndicator(
      alignment: Alignment.topCenter,
      child: TriangleIndicator(),
    ),
  ];

  static const StyleStrategy kDefaultStyleStrategy = AlternatingStyleStrategy();

  /// {@macro flutter_fortune_wheel.FortuneWidget.items}
  final List<FortuneItem> items;

  /// {@macro flutter_fortune_wheel.FortuneWidget.selected}
  final Stream<FortuneReward> selected;

  /// {@macro flutter_fortune_wheel.FortuneWidget.rotationCount}
  final int rotationCount;

  /// {@macro flutter_fortune_wheel.FortuneWidget.duration}
  final Duration duration;

  /// {@macro flutter_fortune_wheel.FortuneWidget.indicators}
  final List<FortuneIndicator> indicators;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animationType}
  final Curve curve;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationStart}
  final VoidCallback? onAnimationStart;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationEnd}
  final VoidCallback? onAnimationEnd;

  /// {@macro flutter_fortune_wheel.FortuneWidget.styleStrategy}
  final StyleStrategy styleStrategy;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animateFirst}
  final bool animateFirst;

  /// {@macro flutter_fortune_wheel.FortuneWidget.physics}
  final PanPhysics physics;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onFling}
  final VoidCallback? onFling;

  /// The position to which the wheel aligns the selected value.
  ///
  /// Defaults to [Alignment.topCenter]
  final Alignment alignment;

  /// HapticFeedback strength on each section border crossing.
  ///
  /// Defaults to [HapticImpact.none]
  final HapticImpact hapticImpact;

  /// Called with the index of the item at the focused [alignment] whenever
  /// a section border is crossed.
  final ValueChanged<int>? onFocusItemChanged;

  final String? wheelImagePath;
  final String? wheelOuterPath;
  final String? wheelCenterPath;
  final double? centerWidgetSize;

  final EdgeInsetsGeometry? padding;

  final double? width;
  final double? height;

  double _getAngle(double progress) {
    return 2 * _math.pi * rotationCount * progress;
  }

  /// {@template flutter_fortune_wheel.FortuneWheel}
  /// Creates a new [FortuneWheel] with the given [items], which is centered
  /// on the [selected] value.
  ///
  /// {@macro flutter_fortune_wheel.FortuneWidget.ctorArgs}.
  ///
  /// See also:
  ///  * [FortuneBar], which provides an alternative visualization.
  /// {@endtemplate}
  FortuneWheel({
    Key? key,
    required this.items,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.selected = const Stream<FortuneReward>.empty(),
    this.duration = FortuneWidget.kDefaultDuration,
    this.curve = FortuneCurve.spin,
    this.indicators = kDefaultIndicators,
    this.styleStrategy = kDefaultStyleStrategy,
    this.animateFirst = true,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.alignment = Alignment.topCenter,
    this.hapticImpact = HapticImpact.none,
    PanPhysics? physics,
    this.onFling,
    this.onFocusItemChanged,
    this.wheelImagePath,
    this.wheelOuterPath,
    this.width,
    this.height,
    this.wheelCenterPath,
    this.padding,
    this.centerWidgetSize,
  })  : physics = physics ?? CircularPanPhysics(),
        assert(items.length > 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tick sound: use a small pool of preloaded low-latency players.
    // This avoids dropped/quiet ticks when the wheel spins very fast.
    final tickPlayers = useMemoized(() {
      return List<AudioPlayer>.generate(4, (_) {
        final player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        player.setPlayerMode(PlayerMode.lowLatency);
        player.seek(Duration(milliseconds: 40));
        player.setVolume(1.0);
        return player;
      });
    });

    final tickPlayerIndex = useRef<int>(0);

    useEffect(() {
      () async {
        for (final player in tickPlayers) {
          try {
            // Preload the audio file (do not prefix with 'assets/')
            await player.setSource(AssetSource('sound/tap.mp3'));
            await player.setVolume(1.0);
            // ignore: avoid_catches_without_on_clauses
          } catch (_) {}
        }
      }();

      return () {
        for (final player in tickPlayers) {
          player.dispose();
        }
      };
    }, []);

    // Arrow animation: Setting up the AnimationController and Animation
    final arrowController =
        useAnimationController(duration: const Duration(milliseconds: 300));
// Initializes an AnimationController with a duration of 300 milliseconds.
// This controller manages the timing of the animation.

    final arrowAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: arrowController,
        curve: Curves.easeOut, // Curve for the forward animation (ease out)
        reverseCurve:
            Curves.easeIn, // Curve for the reverse animation (ease in)
      ),
    );
// Creates an Animation that interpolates from 0 to -20 using a Tween.
// ignore: lines_longer_than_80_chars
// The animation uses a CurvedAnimation to apply easing curves for smoother motion.

    useEffect(() {
      // ignore: lines_longer_than_80_chars
      // Add a listener to the arrowController to monitor animation status changes
      arrowController.addStatusListener((status) {
        // If the animation has completed (reached the end)
        if (status == AnimationStatus.completed) {
          // Reverse the animation back to the starting point
          arrowController.reverse();
        }
      });
      // No cleanup necessary, so return null
      return null;
    }, [arrowController]); // The effect depends on arrowController

    void _animateArrow() {
      // Check if the animation has completed (reached the end)
      if (arrowController.isCompleted) {
        // Reset the animation controller to the beginning
        arrowController.reset();
      }
      // Start the animation moving forward from the current position
      arrowController.forward();
    }

    Future<void> _playTickSound() async {
      try {
        final player = tickPlayers[tickPlayerIndex.value];
        tickPlayerIndex.value =
            (tickPlayerIndex.value + 1) % tickPlayers.length;

        // Restart from beginning. Using a pool prevents rapid ticks from cutting
        // each other off.
        await player.stop();
        await player.seek(Duration.zero);
        await player.resume();
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {}
    }

    final rotateAnimCtrl = useAnimationController(duration: duration);
    final rotateAnim = useState<Animation<double>>(
        CurvedAnimation(parent: rotateAnimCtrl, curve: curve));

    Future<void> animate({bool isForeverRun = false}) async {
      if (rotateAnimCtrl.isAnimating && !isForeverRun) {
        return;
      }

      if (isForeverRun) {
        // Stop any existing animation first
        if (rotateAnimCtrl.isAnimating) {
          rotateAnimCtrl.stop();
        }
        // Reset controller to start fresh
        rotateAnimCtrl.reset();
        // Slower loop so the wheel doesn't spin too fast while waiting.
        rotateAnimCtrl.duration = const Duration(milliseconds: 10000);
        rotateAnim.value = CurvedAnimation(
            parent: rotateAnimCtrl,
            curve: Curves.linear,
            reverseCurve: Curves.linear);
        rotateAnimCtrl.repeat();
        return;
      } else {
        rotateAnimCtrl.duration = duration;
        rotateAnim.value =
            CurvedAnimation(parent: rotateAnimCtrl, curve: curve);
        await Future.microtask(() => onAnimationStart?.call());
        await rotateAnimCtrl.forward(from: 0);
      }
    }

    Future<void> stopAnimation() async {
      if (rotateAnimCtrl.isAnimating) {
        rotateAnimCtrl.stop();
        // Reset and animate to final position with deceleration
        rotateAnimCtrl.reset();
        rotateAnimCtrl.duration = duration;
        rotateAnim.value =
            CurvedAnimation(parent: rotateAnimCtrl, curve: curve);
        await rotateAnimCtrl.forward(from: 0);
      }
    }

    final selectedIndex = useState<int>(0);

    useEffect(() {
      final subscription = selected.listen((event) async {
        if (event.status == FortuneWheelStatus.animating) {
          animate(isForeverRun: true);
        } else if (event.status == FortuneWheelStatus.completed) {
          selectedIndex.value = event.id;
          await stopAnimation();

          await Future.microtask(() => onAnimationEnd?.call());
        }
      });
      return subscription.cancel;
    }, []);

    final lastVibratedAngle = useRef<double>(0);

    return SizedBox(
      width: (width != null) ? width! : null,
      height: (height != null) ? height! : null,
      child: PanAwareBuilder(
        behavior: HitTestBehavior.translucent,
        physics: physics,
        onFling: onFling,
        builder: (context, panState) {
          return Stack(
            children: [
              Container(
                padding: padding ?? EdgeInsets.all(52),
                height: height,
                width: width,
                child: AnimatedBuilder(
                  animation: rotateAnim.value,
                  builder: (context, _) {
                    final size = MediaQuery.of(context).size;
                    final meanSize = (size.width + size.height) / 2;
                    final panFactor = 6 / meanSize;

                    return LayoutBuilder(builder: (context, constraints) {
                      final wheelData = _WheelData(
                        constraints: constraints,
                        itemCount: items.length,
                        textDirection: Directionality.of(context),
                      );

                      final isAnimatingPanFactor =
                          rotateAnimCtrl.isAnimating ? 0 : 1;
                      final selectedAngle =
                          -2 * _math.pi * (selectedIndex.value / items.length);
                      final panAngle =
                          panState.distance * panFactor * isAnimatingPanFactor;
                      final rotationAngle = _getAngle(rotateAnim.value.value);
                      final alignmentOffset =
                          _calculateAlignmentOffset(alignment);
                      final totalAngle =
                          selectedAngle + panAngle + rotationAngle;

                      final focusedIndex = _borderCross(
                        totalAngle,
                        lastVibratedAngle,
                        items.length,
                        hapticImpact,
                        _animateArrow,
                        _playTickSound,
                      );
                      if (focusedIndex != null) {
                        onFocusItemChanged?.call(focusedIndex % items.length);
                      }

                      final transformedItems = [
                        for (var i = 0; i < items.length; i++)
                          TransformedFortuneItem(
                            item: items[i],
                            angle: totalAngle +
                                alignmentOffset +
                                _calculateSliceAngle(i, items.length),
                            offset: wheelData.offset,
                          ),
                      ];

                      return Stack(
                        children: [
                          wheelImagePath != null
                              ? Center(
                                  child: Transform.rotate(
                                    angle: totalAngle + alignmentOffset,
                                    child: Image.asset(
                                      wheelImagePath!,
                                      width: wheelData.diameter,
                                      height: wheelData.diameter,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox.expand(
                            child: _CircleSlices(
                              items: transformedItems,
                              wheelData: wheelData,
                              styleStrategy: styleStrategy,
                            ),
                          ),
                        ],
                      );
                    });
                  },
                ),
              ),
              wheelOuterPath != null
                  ? Center(
                      child: AnimatedBuilder(
                          animation: rotateAnim.value,
                          builder: (context, _) {
                            final size = MediaQuery.of(context).size;
                            final meanSize = (size.width + size.height) / 2;
                            final panFactor = 6 / meanSize;

                            return LayoutBuilder(
                                builder: (context, constraints) {
                              final wheelData = _WheelData(
                                constraints: constraints,
                                itemCount: items.length,
                                textDirection: Directionality.of(context),
                              );

                              final isAnimatingPanFactor =
                                  rotateAnimCtrl.isAnimating ? 0 : 1;
                              final selectedAngle = -2 *
                                  _math.pi *
                                  (selectedIndex.value / items.length);
                              final panAngle = panState.distance *
                                  panFactor *
                                  isAnimatingPanFactor;
                              final rotationAngle =
                                  _getAngle(rotateAnim.value.value);
                              final alignmentOffset =
                                  _calculateAlignmentOffset(alignment);
                              final totalAngle =
                                  selectedAngle + panAngle + rotationAngle;

                              return Transform.rotate(
                                angle: totalAngle + alignmentOffset,
                                child: Image.asset(
                                  wheelOuterPath!,
                                  width: wheelData.diameter + 35,
                                  height: wheelData.diameter + 35,
                                  fit: BoxFit.contain,
                                ),
                              );
                            });
                          }),
                    )
                  : SizedBox(),
              for (var it in indicators)
                IgnorePointer(
                  child: Container(
                    alignment: it.alignment,
                    child: AnimatedBuilder(
                      animation: arrowAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, arrowAnimation.value),
                          child: child,
                        );
                      },
                      child: it.child,
                    ),
                  ),
                ),
              wheelCenterPath != null
                  ? Center(
                      child: Image.asset(
                        wheelCenterPath!,
                        width: centerWidgetSize ?? 80,
                        height: centerWidgetSize ?? 80,
                        fit: BoxFit.contain,
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  // Future<void> celebration(
  //     AudioPlayer audioPlayer, BuildContext context) async {
  //   await audioPlayer.setSource(AssetSource('sound/celebration_sound.mp3'));
  //   await audioPlayer.resume();
  // }

  /// * vibrate, animate arrow, and play sound when cross border
  int? _borderCross(
    double angle,
    ObjectRef<double> lastVibratedAngle,
    int itemsNumber,
    HapticImpact hapticImpact,
    VoidCallback animateArrow,
    Future<void> Function() playTickSound,
  ) {
    final step = 360 / itemsNumber;
    final angleDegrees = (angle * 180 / _math.pi).abs() + step / 2;
    if (step.isNaN ||
        angleDegrees.isNaN ||
        lastVibratedAngle.value.isNaN ||
        lastVibratedAngle.value.isInfinite ||
        angleDegrees.isInfinite ||
        step == 0) {
      return null;
    }
    if (lastVibratedAngle.value ~/ step == angleDegrees ~/ step) {
      return null;
    }
    final index = angleDegrees ~/ step * angle.sign.toInt() * -1;
    final hapticFeedbackFunction;
    switch (hapticImpact) {
      case HapticImpact.none:
        // Play sound even if haptic is disabled
        playTickSound();
        // Update last segment to avoid repeated triggers within same slice
        lastVibratedAngle.value = (angleDegrees ~/ step) * step;
        return index;
      case HapticImpact.heavy:
        hapticFeedbackFunction = HapticFeedback.heavyImpact;
        break;
      case HapticImpact.medium:
        hapticFeedbackFunction = HapticFeedback.mediumImpact;
        break;
      case HapticImpact.light:
        hapticFeedbackFunction = HapticFeedback.lightImpact;
        break;
    }
    hapticFeedbackFunction();
    animateArrow();
    playTickSound();
    lastVibratedAngle.value = (angleDegrees ~/ step) * step;
    return index;
  }
}
