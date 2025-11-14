import 'package:cointiply_app/features/home/presentation/providers/tutorial_provider.dart';
import 'package:cointiply_app/features/home/presentation/widgets/dialog/tutorial_dialog_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class TutorialOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const TutorialOverlay({super.key, required this.child});

  @override
  ConsumerState<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends ConsumerState<TutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    final tutorialShown = ref.watch(tutorialProvider);

    if (tutorialShown) return widget.child;
    return Material(
      color: Theme.of(context).colorScheme.scrim,
      child: Stack(
        children: [
          // App content (blurred/disabled)
          Positioned.fill(
            child: AbsorbPointer(
              child: Opacity(
                opacity: 0.1,
                child: widget.child,
              ),
            ),
          ),
          Center(
            child: CointiplyTutorialDialog(
              onComplete: () {
                ref.read(tutorialProvider.notifier).markAsShown();
              },
            ),
          ),
        ],
      ),
    );
  }
}
