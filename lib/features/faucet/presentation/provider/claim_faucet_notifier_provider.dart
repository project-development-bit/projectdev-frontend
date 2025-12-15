import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'claim_faucet_notifier.dart';
import 'claim_faucet_state.dart';
import 'package:cointiply_app/features/faucet/domain/usecases/claim_faucet_usecase.dart';

final claimFaucetNotifierProvider =
    StateNotifierProvider.autoDispose<ClaimFaucetNotifier, ClaimFaucetState>(
        (ref) {
  final usecase = ref.read(claimFaucetUseCaseProvider);
  return ClaimFaucetNotifier(usecase);
});
