import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/wallet/domain/entity/balance.dart';
import 'package:gigafaucet/features/wallet/domain/usecases/get_user_balance_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'balance_state.dart';

class GetBalanceNotifier extends StateNotifier<BalanceState> {
  final GetUserBalanceUseCase _getUserBalanceUseCase;

  GetBalanceNotifier(this._getUserBalanceUseCase) : super(const BalanceState());

  Future<void> fetchUserBalance() async {
    state = state.copyWith(
      status: GetBalanceStatus.loading,
      error: null,
    );

    final result = await _getUserBalanceUseCase.call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetBalanceStatus.error,
          error: failure.message,
        );
      },
      (BalanceResponse response) {
        state = state.copyWith(
          status: GetBalanceStatus.data,
          balance: response,
        );
      },
    );
  }
}
