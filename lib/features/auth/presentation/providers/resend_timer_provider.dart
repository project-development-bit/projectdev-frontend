import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =============================================================================
// RESEND TIMER STATE
// =============================================================================

/// State for resend timer functionality
class ResendTimerState {
  final int countdown;
  final bool canResend;
  final bool isActive;

  const ResendTimerState({
    required this.countdown,
    required this.canResend,
    required this.isActive,
  });

  factory ResendTimerState.initial() {
    return const ResendTimerState(
      countdown: 30,
      canResend: false,
      isActive: false,
    );
  }

  ResendTimerState copyWith({
    int? countdown,
    bool? canResend,
    bool? isActive,
  }) {
    return ResendTimerState(
      countdown: countdown ?? this.countdown,
      canResend: canResend ?? this.canResend,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'ResendTimerState(countdown: $countdown, canResend: $canResend, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResendTimerState &&
        other.countdown == countdown &&
        other.canResend == canResend &&
        other.isActive == isActive;
  }

  @override
  int get hashCode =>
      countdown.hashCode ^ canResend.hashCode ^ isActive.hashCode;
}

// =============================================================================
// RESEND TIMER NOTIFIER
// =============================================================================

/// StateNotifier for managing resend timer functionality
class ResendTimerNotifier extends StateNotifier<ResendTimerState> {
  ResendTimerNotifier() : super(ResendTimerState.initial());

  Timer? _timer;

  /// Start the resend timer
  void startTimer() {
    // Cancel any existing timer
    _timer?.cancel();

    // Reset state to initial countdown
    state = state.copyWith(
      countdown: 30,
      canResend: false,
      isActive: true,
    );

    // Start periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        state = state.copyWith(
          canResend: true,
          isActive: false,
        );
        timer.cancel();
      }
    });
  }

  /// Stop the timer
  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isActive: false);
  }

  /// Reset timer to initial state
  void resetTimer() {
    _timer?.cancel();
    state = ResendTimerState.initial();
  }

  /// Enable resend immediately (for testing or special cases)
  void enableResend() {
    _timer?.cancel();
    state = state.copyWith(
      countdown: 0,
      canResend: true,
      isActive: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Provider for resend timer state notifier
final resendTimerProvider =
    StateNotifierProvider<ResendTimerNotifier, ResendTimerState>(
  (ref) => ResendTimerNotifier(),
);

/// Provider for checking if resend is allowed
final canResendProvider = Provider<bool>((ref) {
  final timerState = ref.watch(resendTimerProvider);
  return timerState.canResend;
});

/// Provider for current countdown value
final countdownProvider = Provider<int>((ref) {
  final timerState = ref.watch(resendTimerProvider);
  return timerState.countdown;
});

/// Provider for checking if timer is active
final isTimerActiveProvider = Provider<bool>((ref) {
  final timerState = ref.watch(resendTimerProvider);
  return timerState.isActive;
});
