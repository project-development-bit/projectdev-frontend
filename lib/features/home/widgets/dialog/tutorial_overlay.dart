import 'package:cointiply_app/features/home/providers/tutorial_provider.dart';
import 'package:cointiply_app/features/home/widgets/dialog/tutorial_dialog_widget.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 🧠 Recheck before showing
      final alreadyShown = ref.read(tutorialProvider);
      if (!alreadyShown) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CointiplyTutorialDialog(
          onComplete: () {
            ref.read(tutorialProvider.notifier).markAsShown();
          },
        ),
      );
    });

    return widget.child;
  }
}
