import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:cointiply_app/features/faucet/domain/usecases/get_faucet_status_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'faucet_state.dart';

class GetFaucetNotifier extends StateNotifier<FaucetState> {
  final GetFaucetStatusUseCase _getFaucetStatusUseCase;

  GetFaucetNotifier(this._getFaucetStatusUseCase) : super(const FaucetState()) {
    fetchFaucetStatus();
  }

  Future<void> fetchFaucetStatus() async {
    state = state.copyWith(
      state: GetFaucetStatusState.loading,
      error: null,
    );

    final result = await _getFaucetStatusUseCase.call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          state: GetFaucetStatusState.error,
          error: failure.message,
        );
      },
      (ActualFaucetStatusModel response) {
        state = state.copyWith(
          state: GetFaucetStatusState.data,
          status: response,
        );
      },
    );
  }
}
