import 'package:gigafaucet/features/auth/presentation/widgets/internal_verification_overlay.dart';
import 'package:gigafaucet/features/home/presentation/providers/tutorial_provider.dart';
import 'package:gigafaucet/features/home/presentation/widgets/dialog/tutorial_dialog_widget.dart';
import 'package:gigafaucet/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';

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
    final authState = ref.watch(authProvider);

    final isVerified = ref.watch(internalVerificationProvider);
    final currentUserState = ref.watch(currentUserProvider);
    debugPrint(
        'Tutorial Overlay - shown: $tutorialShown | !auth: ${!authState.isAuthenticated} showOnboarding : ${currentUserState.user != null ? !currentUserState.user!.shouldShowOnboarding : 'N/A'} isVerified: ${!isVerified} overAll: ${tutorialShown || !authState.isAuthenticated || (currentUserState.user != null && !currentUserState.user!.shouldShowOnboarding) || !isVerified}');
    if (tutorialShown ||
        currentUserState.isLoading || // ✅ added here
        !authState.isAuthenticated ||
        (currentUserState.user != null &&
            !currentUserState.user!.shouldShowOnboarding) ||
        !isVerified) {
      return widget.child;
    }

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
            child: FirstTimeTutorialDialog(
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
