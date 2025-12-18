import 'dart:async';
import 'dart:math' as math;

import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_loading_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/fortune_wheel/domain/entities/fortune_wheel_reward.dart';
import 'package:cointiply_app/features/fortune_wheel/presentation/providers/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showFortuneWheelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FortuneWheelWidget(),
  );
}

final wheelProvider = StateProvider<int>((ref) {
  return 0;
});

class FortuneWheelWidget extends ConsumerStatefulWidget {
  const FortuneWheelWidget({super.key});

  @override
  ConsumerState<FortuneWheelWidget> createState() => _FortuneWheelWidgetState();
}

class _FortuneWheelWidgetState extends ConsumerState<FortuneWheelWidget> {
  StreamController<int> selected = StreamController<int>.broadcast();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch rewards
      ref.read(fortuneWheelProvider.notifier).fetchFortuneWheelRewards(
        onSuccess: () {
          debugPrint('🎡 Rewards loaded successfully');
        },
        onError: (message) {
          debugPrint('🎡 Error loading rewards: $message');
          // Show error to user
          if (mounted) {
            context.showSnackBar(message: message);
          }
        },
      );

      // Fetch status
      ref.read(fortuneWheelStatusProvider.notifier).fetchFortuneWheelStatus(
        onSuccess: () {
          debugPrint('🎡 Status loaded successfully');
        },
        onError: (message) {
          debugPrint('🎡 Error loading status: $message');
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fortuneWheelProvider);
    if (state is FortuneWheelLoading || state is FortuneWheelInitial) {
      return Center(child: CommonLoadingWidget.medium());
    } else if (state is FortuneWheelError) {
      return Center(
        child: CommonText.bodyMedium(
          state.message,
          color: Colors.red,
        ),
      );
    }
    
    // Get rewards from any valid state
    final rewards = switch (state) {
      FortuneWheelLoaded(:final rewards) => rewards,
      FortuneWheelSpinning(:final rewards) => rewards,
      FortuneWheelSpinSuccess(:final rewards) => rewards,
      _ => <FortuneWheelReward>[],
    };

   

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: context.screenHeight * 0.8,
          child: FittedBox(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      AppLocalImages.fortuneWheelGirl,
                      fit: BoxFit.contain,
                      width: 500,
                      height: 400,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.24),
                    child: Image.asset(
                      AppLocalImages.wheelBanner,
                      fit: BoxFit.contain,
                      width: 500,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FortuneWheel(
                        height: 400,
                        width: 400,
                        centerWidgetSize: 140,
                        padding: EdgeInsets.all(42),
                        indicators: [
                          FortuneIndicator(
                            alignment: Alignment(0, -1.05),
                            child: Image.asset(
                              AppLocalImages.wheelIndicator,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                        styleStrategy: UniformStyleStrategy(
                          borderColor: context.primary,
                          borderWidth: 3,
                          color: Colors.transparent,
                        ),
                        animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: Duration(seconds: 5),
                          curve: Curves.decelerate,
                        ),
                        rotationCount: 10,
                        selected: selected.stream,
                        onAnimationStart: () {
                          // Do something when the animation starts
                        },
                        wheelImagePath: AppLocalImages.spinningInnerWheel,
                        wheelOuterPath: AppLocalImages.outerWheel,
                        wheelCenterPath: AppLocalImages.wheelCenterPath,
                        onAnimationEnd: () {},
                        items: rewards.map((e) {
                          return _fortuneWheelItem(e);
                        }).toList()),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Display spin status info
        Builder(
          builder: (context) {
            final statusState = ref.watch(fortuneWheelStatusProvider);
            if (statusState is FortuneWheelStatusLoaded) {
              final status = statusState.status;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CommonText.bodyMedium(
                  'Spins: ${status.todaySpins}/${status.dailyLimit} | Remaining: ${status.remainingSpins}',
                  color: Colors.white70,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
        Builder(
          builder: (context) {
            final statusState = ref.watch(fortuneWheelStatusProvider);
            final canSpin = statusState is FortuneWheelStatusLoaded 
                ? statusState.status.canSpin 
                : true;
            final isSpinning = state is FortuneWheelSpinning;
            
            return CustomUnderLineButtonWidget(
              title: context.translate(isSpinning ? "Spinning..." : "Spin"),
              fontSize: 14,
              height: 40,
              isViolet: true,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              onTap: (!canSpin || isSpinning) ? null : () async {
                // Call the spin API
                ref.read(fortuneWheelProvider.notifier).spinFortuneWheel(
                  onSpinResult: (winningIndex) {
                    // The API returned the winning index, now spin to that position
                    debugPrint('🎡 Spinning to index: $winningIndex');
                    setState(() {
                      selected.add(winningIndex);
                    });
                  },
                  onSuccess: () {
                    debugPrint('🎡 Spin completed successfully');

                    // Show success message after animation completes
                    final currentState = ref.read(fortuneWheelProvider);
                    if (currentState is FortuneWheelSpinSuccess) {
                      final spinResponse = currentState.spinResponse;

                      // Wait for animation to complete
                      Future.delayed(const Duration(seconds: 6), () {
                        if (context.mounted) {
                          context.showSnackBar(
                            message:
                                '${spinResponse.message}\nRemaining spins: ${spinResponse.remainingDailyCap}',
                          );
                          
                          // Refresh status after spin
                          ref.read(fortuneWheelStatusProvider.notifier).fetchFortuneWheelStatus();
                        }
                      });
                    }
                  },
                  onError: (message) {
                    debugPrint('🎡 Spin error: $message');
                    context.showSnackBar(message: message);
                  },
                );
              },
            );
          },
        )
      ],
    );
  }

  FortuneItem _fortuneWheelItem(FortuneWheelReward reward) {
    return FortuneItem(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 65),
        CommonImage(
          imageUrl: reward.iconUrl,
          width: 37,
          placeholder: Icon(Icons.image, color: Colors.white),
          height: 37,
        ),
        SizedBox(width: 10),
        Transform.rotate(
          angle: math.pi / 2, // 90 degrees in radians
          child: CommonText.titleSmall(
            '+ 100',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }
}
