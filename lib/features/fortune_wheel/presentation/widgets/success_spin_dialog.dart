import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:gigafaucet/core/common/close_square_button.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

showSuccessSpinDialog(BuildContext context,
    {required String rewardImageUrl, required String rewardLabel}) {
  showDialog(
    context: context,
    builder: (context) => SuccessSpinDialogWidget(
      rewardImageUrl: rewardImageUrl,
      rewardLabel: rewardLabel,
    ),
  );
}

class SuccessSpinDialogWidget extends StatefulWidget {
  final String rewardImageUrl;
  final String rewardLabel;
  const SuccessSpinDialogWidget(
      {super.key, required this.rewardImageUrl, required this.rewardLabel});

  @override
  State<SuccessSpinDialogWidget> createState() =>
      _SuccessSpinDialogWidgetState();
}

class _SuccessSpinDialogWidgetState extends State<SuccessSpinDialogWidget> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 6));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path _coinParticlePath(Size size) {
    final path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    path.addOval(rect);
    final inner = Rect.fromCenter(
      center: rect.center,
      width: size.width * 0.68,
      height: size.height * 0.68,
    );
    path.addOval(inner);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: SizedBox(
        width: isMobile
            ? MediaQuery.of(context).size.width * 0.9
            : isTablet
                ? MediaQuery.of(context).size.width * 0.7
                : 630,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.7
            : isTablet
                ? 650
                : 696,
        child: Stack(
          children: [
            // Confetti overlay
            Container(
              width: isMobile
                  ? MediaQuery.of(context).size.width * 0.9
                  : isTablet
                      ? MediaQuery.of(context).size.width * 0.7
                      : 630,
              height: isMobile
                  ? MediaQuery.of(context).size.height * 0.7
                  : isTablet
                      ? 650
                      : 696,
              padding: isMobile
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(isMobile
                      ? AppLocalImages.spinNotRemainBgMobile
                      : AppLocalImages.successSpingDialogBg),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: isMobile ? 20 : 40),
                    CommonImage(
                      imageUrl: AppLocalImages.congratsLabel,
                      fit: BoxFit.contain,
                      width: isMobile
                          ? context.screenWidth * 0.6
                          : isTablet
                              ? 350
                              : 400,
                    ),
                    SizedBox(height: isMobile ? 20 : 40),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonText.bodyLarge(
                        widget.rewardLabel,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        maxLines: 2,
                        fontSize: isMobile ? 24 : 24,
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 40),
                    CommonImage(
                      imageUrl: AppLocalImages.fortuneWheelGirlCong,
                      fit: isMobile ? BoxFit.contain : BoxFit.cover,
                      alignment:
                          isMobile ? Alignment.center : Alignment.topCenter,
                      width: isMobile
                          ? context.screenWidth * 0.75
                          : isTablet
                              ? 250
                              : 270,
                      height: isMobile
                          ? context.screenHeight * 0.7
                          : isTablet
                              ? 300
                              : 370,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                right: isMobile ? 10 : 16,
                top: isMobile ? 10 : 16,
                child: CloseSquareButton(onTap: () {
                  context.pop();
                })),
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: math.pi / 2,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.08,
                    numberOfParticles: 20,
                    maxBlastForce: 40,
                    minBlastForce: 3,
                    gravity: 0.35,
                    particleDrag: 0.05,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      const Color(0xFFFFD54F),
                      const Color(0xFFFFC107),
                      const Color(0xFFFFB300),
                      const Color(0xFFFFF59D),
                    ],
                    createParticlePath: _coinParticlePath,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinRainOverlay extends StatefulWidget {
  const _CoinRainOverlay({
    required this.coinAssetPath,
    required this.particleCount,
  });

  final String coinAssetPath;
  final int particleCount;

  @override
  State<_CoinRainOverlay> createState() => _CoinRainOverlayState();
}

class _CoinRainOverlayState extends State<_CoinRainOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_CoinParticle> _particles;

  ImageStream? _coinStream;
  ImageStreamListener? _coinStreamListener;
  ui.Image? _coinImage;

  double _timeBaseSeconds = 0;
  late final double _periodSeconds;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _periodSeconds = _controller.duration!.inMilliseconds / 1000.0;
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timeBaseSeconds += _periodSeconds;
          _controller.forward(from: 0);
        }
      })
      ..forward(from: 0);

    // Deterministic randomness for stable visuals.
    final random = math.Random(42);
    _particles = List.generate(widget.particleCount, (index) {
      final size = random.nextDouble() * 40 + 40; // 40..80
      final speed = random.nextDouble() * 140 + 110; // px/sec
      final startX = random.nextDouble(); // 0..1 (fraction)
      final startY = -random.nextDouble(); // -1..0 (fraction of height)
      final rotationSpeed = (random.nextDouble() * 2 - 1) * 1.4; // rad/sec
      final rotationStart = random.nextDouble() * math.pi * 2;
      final opacity = 0.65 + random.nextDouble() * 0.35;
      return _CoinParticle(
        size: size,
        speed: speed,
        startX: startX,
        startY: startY,
        rotationSpeed: rotationSpeed,
        rotationStart: rotationStart,
        opacity: opacity,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveCoinImage();
  }

  @override
  void didUpdateWidget(covariant _CoinRainOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinAssetPath != widget.coinAssetPath) {
      _resolveCoinImage();
    }
  }

  void _resolveCoinImage() {
    // Cancel any previous stream listener.
    if (_coinStream != null && _coinStreamListener != null) {
      _coinStream!.removeListener(_coinStreamListener!);
    }

    final provider = AssetImage(widget.coinAssetPath);
    // Warm cache to avoid first-frame decode jank.
    precacheImage(provider, context);

    final stream = provider.resolve(createLocalImageConfiguration(context));
    _coinStream = stream;
    _coinStreamListener = ImageStreamListener((imageInfo, _) {
      if (!mounted) return;
      setState(() {
        _coinImage = imageInfo.image;
      });
    });
    stream.addListener(_coinStreamListener!);
  }

  @override
  void dispose() {
    if (_coinStream != null && _coinStreamListener != null) {
      _coinStream!.removeListener(_coinStreamListener!);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_coinImage == null) {
      return const SizedBox.expand();
    }

    return RepaintBoundary(
      child: CustomPaint(
        painter: _CoinRainPainter(
          coinImage: _coinImage!,
          particles: _particles,
          timeBaseSeconds: _timeBaseSeconds,
          periodSeconds: _periodSeconds,
          animation: _controller,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _CoinRainPainter extends CustomPainter {
  _CoinRainPainter({
    required this.coinImage,
    required this.particles,
    required this.timeBaseSeconds,
    required this.periodSeconds,
    required this.animation,
  }) : super(repaint: animation);

  final ui.Image coinImage;
  final List<_CoinParticle> particles;
  final double timeBaseSeconds;
  final double periodSeconds;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = timeBaseSeconds + (animation.value * periodSeconds);

    final src = Rect.fromLTWH(
      0,
      0,
      coinImage.width.toDouble(),
      coinImage.height.toDouble(),
    );

    for (final particle in particles) {
      final centerX = particle.startX * size.width;

      final startYpx = particle.startY * size.height;
      final totalTravel = size.height + particle.size * 2;
      final topY =
          ((startYpx + particle.speed * t) % totalTravel) - particle.size;
      final centerY = topY + particle.size / 2;

      final angle = particle.rotationStart + particle.rotationSpeed * t;

      final paint = Paint()
        ..filterQuality = FilterQuality.low
        ..isAntiAlias = true
        ..colorFilter = ColorFilter.mode(
          Colors.white.withOpacity(particle.opacity),
          BlendMode.modulate,
        );

      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(angle);

      final dst = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size,
      );
      canvas.drawImageRect(coinImage, src, dst, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CoinRainPainter oldDelegate) {
    return oldDelegate.coinImage != coinImage ||
        oldDelegate.particles != particles ||
        oldDelegate.timeBaseSeconds != timeBaseSeconds ||
        oldDelegate.periodSeconds != periodSeconds ||
        oldDelegate.animation != animation;
  }
}

class _CoinParticle {
  const _CoinParticle({
    required this.size,
    required this.speed,
    required this.startX,
    required this.startY,
    required this.rotationSpeed,
    required this.rotationStart,
    required this.opacity,
  });

  final double size;
  final double speed;
  final double startX;
  final double startY;
  final double rotationSpeed;
  final double rotationStart;
  final double opacity;
}
