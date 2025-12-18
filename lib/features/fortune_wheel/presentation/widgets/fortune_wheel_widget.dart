import 'dart:async';

import 'package:cointiply_app/core/common/common_loading_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fortuneWheelProvider);
    if (state is FortuneWheelLoading) {
      return Center(child: CommonLoadingWidget.medium());
    } else if (state is FortuneWheelError) {
      return Center(
        child: CommonText.bodyMedium(
          state.message,
          color: Colors.red,
        ),
      );
    }

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
                        items: List.generate(10, (v) {
                          return FortuneItem(
                              child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(width: 65),
                              Image.asset(
                                AppLocalImages.ptcAdDiscount,
                                width: 30,
                                height: 30,
                              ),
                              Transform.rotate(
                                angle: -1.57,
                                child: CommonText.titleSmall(
                                  'Prize ${v + 1}',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ));
                        })),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        CustomUnderLineButtonWidget(
            title: context.translate("Spin"),
            fontSize: 14,
            height: 40,
            isViolet: true,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            onTap: () {
              setState(() {
                selected.add(2);
              });
            })
      ],
    );
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }
}
