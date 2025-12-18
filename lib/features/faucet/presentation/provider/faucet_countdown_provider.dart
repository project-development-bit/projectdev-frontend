import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/actual_faucet_status.dart';
import 'faucet_countdown_notifier.dart';
import 'faucet_countdown_state.dart';

final faucetCountdownProvider = StateNotifierProvider.autoDispose
    .family<FaucetCountdownNotifier, FaucetCountdownState, ActualFaucetStatus?>(
        (ref, status) {
  return FaucetCountdownNotifier(status);
});
