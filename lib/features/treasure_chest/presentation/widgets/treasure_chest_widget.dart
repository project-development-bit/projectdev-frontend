import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/treasure_chest/domain/entities/treasure_chest_open_response.dart';
import 'package:gigafaucet/features/treasure_chest/presentation/providers/treasure_chest_opening_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import '../providers/treasure_chest_provider.dart';

/// Treasure chest widget for displaying treasure chest status
class TreasureChestWidget extends ConsumerStatefulWidget {
  const TreasureChestWidget({super.key});

  @override
  ConsumerState<TreasureChestWidget> createState() =>
      _TreasureChestWidgetState();
}

class _TreasureChestWidgetState extends ConsumerState<TreasureChestWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late AnimationController _rewardAnimationController;
  late AnimationController _entranceAnimationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _rewardFadeAnimation;
  late Animation<Offset> _rewardSlideAnimation;
  late Animation<Offset> _entranceSlideAnimation;
  late Animation<double> _entranceScaleAnimation;
  late ConfettiController _confettiController;
  AudioPlayer? _successAudioPlayer;
  AudioPlayer? _hoverAudioPlayer;
  AudioPlayer? _entranceAudioPlayer;
  AudioPlayer? _rejectionAudioPlayer;
  AudioPlayer? _boxOpeningAudioPlayer;

  bool _isHovering = false;
  bool _isPlayingFullAnimation = false;
  String? _rewardImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    // Start at 0 (static, first frame)
    _animationController.value = 0;

    // Rotation controller for idle wiggle
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _rotationAnimation = Tween<double>(
      begin: -0.05, // -5 degrees
      end: 0.05, // +5 degrees
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Reward animation controller
    _rewardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _rewardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rewardAnimationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    _rewardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5), // Move up
    ).animate(CurvedAnimation(
      parent: _rewardAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Entrance animation controller
    _entranceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _entranceSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceAnimationController,
      curve: Curves.bounceOut,
    ));

    _entranceScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceAnimationController,
      curve: Curves.easeOut,
    ));

    // Start entrance animation
    _entranceAnimationController.forward();

    // Play entrance drop sound
    _playEntranceSound();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuth = ref.read(isAuthenticatedObservableProvider);
      if (!isAuth) {
        return;
      }
      // Fetch treasure chest status on init
      ref.read(treasureChestProvider.notifier).fetchTreasureChestStatus(
        onSuccess: () {
          debugPrint('🎁 Treasure chest status loaded successfully');
          // Start idle animation only if chest is available
          final state = ref.read(treasureChestProvider);
          if (state is TreasureChestLoaded) {
            _startIdleAnimation();
            // } else {
            //   debugPrint('🎁 No idle animation - chest not available');
          }
        },
        onError: (message) {
          debugPrint('🎁 Error loading status: $message');
          if (mounted) {
            context.showSnackBar(
              message: message,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              duration: Duration(seconds: 3),
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    _rewardAnimationController.dispose();
    _entranceAnimationController.dispose();
    _confettiController.dispose();
    _successAudioPlayer?.dispose();
    _hoverAudioPlayer?.dispose();
    _entranceAudioPlayer?.dispose();
    super.dispose();
  }

  void _startIdleAnimation() {
    // Don't start if full animation is playing
    if (_isPlayingFullAnimation) return;

    // Check if chest is available before starting animation
    final state = ref.read(treasureChestProvider);
    if (state is! TreasureChestLoaded) {
      debugPrint('🎁 Idle animation blocked - chest not available');
      return;
    }

    // Rotation wiggle runs for 3 seconds, pauses 1 second, then repeats infinitely
    _animationController.value = 0; // Keep Lottie at first frame during idle

    // Start rotation animation for 3 seconds
    _rotationController.repeat(reverse: true);

    // After 3 seconds, stop and wait 1 second
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isHovering && !_isPlayingFullAnimation) {
        _rotationController.stop();
        _rotationController.value = 0.5; // Reset to center

        // Wait 1 second, then restart
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_isHovering && !_isPlayingFullAnimation) {
            _startIdleAnimation(); // Restart the cycle
          }
        });
      }
    });
  }

  void _startHoverAnimation() {
    // Check if chest is available before allowing hover animation
    final state = ref.read(treasureChestProvider);
    if (state is! TreasureChestLoaded) {
      return;
    }

    if (!_isHovering &&
        _animationController.status != AnimationStatus.forward) {
      _isHovering = true;
      // Stop rotation wiggle
      _rotationController.stop();
      _rotationController.value = 0.5; // Reset to center
      // Start Lottie hover animation
      _animationController.stop();
      _animationController.duration = const Duration(milliseconds: 700);
      _animationController.repeat(
        min: 0.0,
        max: 0.14, // Loop first 1 second (20% of the 5-second total animation)
        reverse: true,
      );

      // Play hover sound on loop
      _playHoverSound();
    }
  }

  void _stopHoverAnimation({bool isStopSound = true}) {
    if (_isHovering) {
      _isHovering = false;

      // Stop hover sound
      if (isStopSound) {
        _stopHoverSound();
      }

      // Stop animation and return to idle wiggle state
      _animationController.stop();
      _animationController
          .animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      )
          .then((_) {
        if (!_isHovering && !_isPlayingFullAnimation && mounted) {
          _startIdleAnimation();
        }
      });
    }
  }

  void _resetAnimation() {
    // Smoothly animate back to first frame, then start idle animation
    _isPlayingFullAnimation = false;
    setState(() {
      _rewardImage = null;
    });
    _animationController
        .animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    )
        .then((_) {
      if (!_isHovering && mounted) {
        _startIdleAnimation();
      }
    });
  }

  String _getRewardImage(String rewardType) {
    switch (rewardType.toLowerCase()) {
      case 'coins':
        return AppLocalImages.treasureChestCoinReward;
      case 'extra_spin':
      case 'bonus_spin':
        return AppLocalImages.treasureChestBonusSpinReward;
      case 'offer_boost':
        return AppLocalImages.treasureChestOffetBoost;
      case 'ptc_discount':
        return AppLocalImages.treasureChestPTCDiscount;
      case 'cash':
      case 'money':
        return AppLocalImages.treasureChestMoneyReward;
      default:
        return AppLocalImages.treasureChestCoinReward;
    }
  }

  void _showRewardAnimation(String rewardType, String rewardLabel) {
    _stopHoverSound();
    _playSuccessSound();
    setState(() {
      _rewardImage = _getRewardImage(rewardType);
    });

    // Start confetti
    // _confettiController.play();

    // Start reward animation
    _rewardAnimationController.forward(from: 0.0).then((_) {
      // Keep reward visible for a moment
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          // _rewardAnimationController.reverse().then((_) {
          setState(() {
            _rewardImage = null;
            _isPlayingFullAnimation = false;
          });
          // });
        }
      });
    });
  }

  void _onTap() {
    // if (_isPlayingFullAnimation) return;
    // successAnimationRun("Success");
    // Future.delayed(
    //     const Duration(seconds: 2),
    //     () => _showRewardAnimation(
    //           "coins",
    //           "1000 Coins",
    //         ));

    // return;

    final isAuth = ref.read(isAuthenticatedObservableProvider);
    if (!isAuth) {
      context.showErrorSnackBar(
        message: context.l10n?.translate('please_login_to_continue') ??
            'Please log in to continue.',
      );
      return;
    }

    // Check if chest is available before opening
    final state = ref.read(treasureChestProvider);

    if (state is! TreasureChestLoaded) {
      debugPrint('🎁 Chest status not loaded yet');
      context.showErrorSnackBar(
        message: context.l10n?.translate('loading_treasure_chest') ??
            'Please wait while chest status is loading...',
      );
      return;
    }

    // Check if status allows opening
    if (state.status.status != 'available') {
      _playFullLottieAnimation();

      debugPrint('🎁 Cannot open chest - status: ${state.status.status}');

      // Show appropriate message based on status
      String message = context.l10n?.translate('no_chest_available') ??
          'No chests available to open';

      if (state.status.cooldown.active) {
        final cooldownMsg = context.l10n?.translate(
                'treasure_chest_cooldown_message',
                args: [state.status.cooldown.remainingHours.toString()]) ??
            'You must wait ${state.status.cooldown.remainingHours.toString()} hours before opening another chest.';
        message = cooldownMsg;
      } else if (state.status.chests.total == 0) {
        message = context.l10n?.translate('no_chest_available') ??
            'No chests available to open';
      }
      // Play rejection sound
      Future.delayed(const Duration(seconds: 3), () {
        _playRejectionSound();
        if (mounted) {
          context.showErrorSnackBar(message: message);
        }
      });

      //

      return;
    }
    // return;

    debugPrint('🎁 Opening chest - status: ${state.status.status}');

    // Call API to open treasure chest using the opening notifier
    ref.read(treasureChestOpeningProvider.notifier).openTreasureChest(
      onSuccess: (response) async {
        _successHandler(response);
        // Show success message
      },
      onError: (message) {
        debugPrint('🎁 Error opening chest: $message');

        // Play rejection sound
        _playRejectionSound();

        // Show error message
        if (mounted) {
          context.showSnackBar(
            message: message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            duration: Duration(seconds: 3),
          );
        }

        // Reset animation state on error
        _isPlayingFullAnimation = false;
        _resetAnimation();
        return;
      },
    );
  }

  void _successHandler(TreasureChestOpenResponse response) {
    _playFullLottieAnimation();

    // Show reward animation after chest opens
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.showSnackBar(
          message: response.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
      _showRewardAnimation(
        response.reward.type,
        response.reward.label,
      );
    });

    ref
        .read(treasureChestProvider.notifier)
        .fetchTreasureChestStatus(isLoading: false);
    ref.read(currentUserProvider.notifier).getCurrentUser(isLoading: false);
    // Show success message
  }

  void _playFullLottieAnimation() async {
    _stopHoverAnimation(isStopSound: true);
    _isHovering = false;
    _isPlayingFullAnimation = true;

    // Play success sound effect

    // Stop all animations
    _rotationController.stop();
    _rotationController.value = 0.5; // Reset to center
    _animationController.stop();

    /// Play box opening sound
    _playBoxOpeningSound();

    // Play full Lottie animation
    _animationController.duration = const Duration(seconds: 5);
    _animationController.forward(from: 0.0).then((_) {
      // After animation completes, chest stays at final frame
      // Wait 5 seconds, then call reset animation
      if (mounted) {
        Future.delayed(const Duration(seconds: 7), () {
          if (mounted && !_isHovering) {
            _resetAnimation();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(treasureChestProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppLocalImages.treasureChestTitle,
          width: 200,
        ),
        SlideTransition(
          position: _entranceSlideAnimation,
          child: ScaleTransition(
            scale: _entranceScaleAnimation,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 400,
                  height: 400,
                  padding: const EdgeInsets.all(16.0),
                  child: MouseRegion(
                    onHover: (e) => _onMouseHover(e.localPosition),
                    onExit: (_) => _stopHoverAnimation(),
                    child: GestureDetector(
                      onTap: _onTap,
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: child,
                          );
                        },
                        child: Lottie.asset(
                          AppLocalImages.lottieTreasureChest,
                          controller: _animationController,
                          width: 400,
                          height: 400,
                        ),
                      ),
                    ),
                  ),
                ),
                // Reward animation
                if (_rewardImage != null)
                  AnimatedBuilder(
                    animation: _rewardAnimationController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _rewardSlideAnimation,
                        child: FadeTransition(
                          opacity: _rewardFadeAnimation,
                          child: Image.asset(
                            _rewardImage!,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          ),
                        ),
                      );
                    },
                  ),
                // Confetti
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2, // Downward
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 30,
                    gravity: 0.3,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                      Colors.yellow,
                      Colors.red,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onMouseHover(Offset e) {
    // Check if cursor is within the hover box - coordinates adjusted for the treasure chest body
    // X: 110-330 covers the chest width (excluding most shadow)
    // Y: 140-340 covers from top of lid to bottom of chest (excluding bottom shadow)
    final bool isInsideBox =
        e.dx >= 110 && e.dx <= 330 && e.dy >= 140 && e.dy <= 340;

    if (isInsideBox && _isPlayingFullAnimation == false) {
      // Start hover animation if cursor is inside box and not already hovering
      _startHoverAnimation();
    } else {
      // Stop hover animation if cursor moves outside box
      _stopHoverAnimation();
    }
  }

  // Sound effect helper methods
  Future<void> _playEntranceSound() async {
    try {
      _entranceAudioPlayer?.dispose();
      _entranceAudioPlayer = AudioPlayer();
      await _entranceAudioPlayer!
          .play(AssetSource('sound/intro_box_drop_sound.mp3'));
    } catch (e) {
      debugPrint('🎵 Error playing entrance sound: $e');
    }
  }

  Future<void> _playHoverSound() async {
    try {
      _hoverAudioPlayer?.dispose();
      _hoverAudioPlayer = AudioPlayer();
      await _hoverAudioPlayer!.play(
        AssetSource('sound/box_shaking_sound.mp3'),
        mode: PlayerMode.lowLatency,
      );
      // Set to loop
      await _hoverAudioPlayer!.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint('🎵 Error playing hover sound: $e');
    }
  }

  Future<void> _stopHoverSound() async {
    try {
      await _hoverAudioPlayer?.stop();
      await _hoverAudioPlayer?.dispose();
      _hoverAudioPlayer = null;
    } catch (e) {
      debugPrint('🎵 Error stopping hover sound: $e');
    }
  }

  Future<void> _playSuccessSound() async {
    try {
      _successAudioPlayer?.dispose();
      _successAudioPlayer = AudioPlayer();
      await _successAudioPlayer!.play(AssetSource('sound/box_award_sound.mp3'));
    } catch (e) {
      debugPrint('🎵 Error playing success sound: $e');
    }
  }

  Future<void> _playRejectionSound() async {
    try {
      _successAudioPlayer?.dispose();
      _successAudioPlayer = AudioPlayer();
      await _successAudioPlayer!
          .play(AssetSource('sound/box_reject_sound.mp3'));
    } catch (e) {
      debugPrint('🎵 Error playing rejection sound: $e');
    }
  }

  Future<void> _playBoxOpeningSound() async {
    try {
      _boxOpeningAudioPlayer?.dispose();
      _boxOpeningAudioPlayer = AudioPlayer();
      await _boxOpeningAudioPlayer!
          .play(AssetSource('sound/box_opening_sound.mp3'));
    } catch (e) {
      debugPrint('🎵 Error playing box opening sound: $e');
    }
  }
}

/// Show treasure chest as a dialog
void showTreasureChestDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black87,
    builder: (context) => const TreasureChestWidget(),
  );
}
