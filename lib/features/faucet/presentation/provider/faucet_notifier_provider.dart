import 'package:cointiply_app/features/faucet/domain/usecases/get_faucet_status_usecase.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/get_faucet_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'faucet_state.dart';

final getFaucetNotifierProvider =
    StateNotifierProvider.autoDispose<GetFaucetNotifier, FaucetState>((ref) {
  final usecase = ref.read(getFaucetStatusUseCaseProvider);
  return GetFaucetNotifier(usecase);
});
