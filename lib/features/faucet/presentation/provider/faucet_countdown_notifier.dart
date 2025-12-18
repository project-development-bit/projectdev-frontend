import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/actual_faucet_status.dart';
import 'faucet_countdown_state.dart';

class FaucetCountdownNotifier extends StateNotifier<FaucetCountdownState> {
  Timer? _timer;

  FaucetCountdownNotifier(ActualFaucetStatus? status)
      : super(_calculate(status)) {
    _start(status);
  }

  static FaucetCountdownState _calculate(
    ActualFaucetStatus? status,
  ) {
    if (status == null) {
      return FaucetCountdownState.zero();
    }

    final diff = status.nextFaucetAt.difference(DateTime.now());

    if (diff.isNegative || diff.inSeconds <= 0) {
      return FaucetCountdownState.zero();
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);

    return FaucetCountdownState(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isExpired: false,
    );
  }

  void _start(ActualFaucetStatus? status) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final next = _calculate(status);
        state = next;

        if (next.isExpired) {
          _timer?.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
