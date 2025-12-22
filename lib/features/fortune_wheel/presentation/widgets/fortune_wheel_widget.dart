import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_loading_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/providers/auth_provider.dart';
import 'package:cointiply_app/features/fortune_wheel/domain/entities/fortune_wheel_reward.dart';
import 'package:cointiply_app/features/fortune_wheel/presentation/providers/fortune_wheel_provider.dart';
import 'package:cointiply_app/features/fortune_wheel/presentation/widgets/out_of_spin_dialog_widget.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wndr_flutter_confetti/wndr_flutter_confetti.dart';

import 'success_spin_dialog.dart';

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
  StreamController<FortuneReward> selected =
      StreamController<FortuneReward>.broadcast();

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
            context.showSnackBar(
                message: context.translate("spin_wheel_error_message"),
                backgroundColor: Colors.red,
                textColor: Colors.white);
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
                    child: IgnorePointer(
                      ignoring: true,
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
                            duration: Duration(seconds: 10),
                            curve: Curves.decelerate,
                          ),
                          rotationCount: 50,
                          selected: selected.stream,
                          wheelImagePath: AppLocalImages.spinningInnerWheel,
                          wheelOuterPath: AppLocalImages.outerWheel,
                          wheelCenterPath: AppLocalImages.wheelCenterPath,
                          items: rewards.map((e) {
                            return _fortuneWheelItem(e);
                          }).toList()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Consumer(
          builder: (context, ref, child) {
            final statusState = ref.watch(fortuneWheelStatusProvider);
            final canSpin = statusState is FortuneWheelStatusLoaded
                ? statusState.status.canSpin
                : true;
            final isSpinning = state is FortuneWheelSpinning;
            final isAuth = ref.watch(isAuthenticatedObservableProvider);

            return CustomUnderLineButtonWidget(
              title: !isAuth
                  ? context.translate('login_to_spin')
                  : context.translate(isSpinning ? "Spinning..." : "Spin"),
              fontSize: 14,
              height: 40,
              isViolet: true,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              onTap: () async {
                if (!isAuth) {
                  context.pop();
                  context.goNamedLogin();
                  return;
                }
                if (isSpinning) {
                  return;
                }
                if ((!canSpin)) {
                  showOutofSpinDialog(context);
                  return;
                }
                selected.add(
                    FortuneReward(id: 0, status: FortuneWheelStatus.animating));
                // Call the spin API
                ref.read(fortuneWheelProvider.notifier).spinFortuneWheel(
                  onSpinResult: (winningIndex) {
                    // The API returned the winning index, now spin to that position
                    debugPrint('🎡 Spinning to index: $winningIndex');
                    selected.add(FortuneReward(
                        id: winningIndex,
                        status: FortuneWheelStatus.completed));
                  },
                  onSuccess: (v) async {
                    await spinMethod(ref, context);
                  },
                  onError: (message) async {
                    selected.add(FortuneReward(
                        id: 0, status: FortuneWheelStatus.completed));

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

  Future<void> spinMethod(WidgetRef ref, BuildContext context) async {
    debugPrint('🎡 Spin completed successfully');

    // Show success message after animation completes
    final currentState = ref.read(fortuneWheelProvider);
    if (currentState is FortuneWheelSpinSuccess) {
      final spinResponse = currentState.spinResponse;
    
    
      final reward = currentState.rewards
          .firstWhere(
          (element) => element.wheelIndex == spinResponse.wheelIndex);

      await celebrationSound();
      // Wait for animation to complete
      if (context.mounted) {
        showSuccessSpinDialog(context,
            rewardImageUrl: reward.iconUrl,
            rewardLabel: context.translate("spin_success_message", args: [
              reward.label +
                  (reward.rewardCoins == 1
                      ? ' coin'
                      : reward.rewardUsd == 1
                          ? ' USD'
                          : reward.rewardCoins > 1
                              ? ' coins'
                              : reward.rewardUsd > 1
                                  ? ' USD'
                                  : '')
            ]));
        await runConfetti(context);

        // Refresh status after spin
        ref.read(fortuneWheelStatusProvider.notifier).fetchFortuneWheelStatus();
      }
    }
  }

  Future<void> celebrationSound() async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource('sound/celebration_sound.mp3'));
    await audioPlayer.resume();
  }

  Future<void> runConfetti(
    BuildContext context,
  ) async {
    await WunderFlutterConfetti.startConfettiWithImageAsset(
      context,
      AppLocalImages.coin,
      params: ConfettiParams(
          particleCount: 25,
          spread: 40,
          angleLeft: 40,
          particleHeight: 30,
          particleWidth: 30,
          angleRight: 140,
          startVelocity: 70),
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
          fit: BoxFit.contain,
          placeholder: Icon(Icons.image, color: Colors.white),
          height: 37,
        ),
        SizedBox(
          width: 55,
          child: Transform.rotate(
            angle: math.pi / 2, // 90 degrees in radians
            child: CommonText.titleSmall(
              reward.label,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ),
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
