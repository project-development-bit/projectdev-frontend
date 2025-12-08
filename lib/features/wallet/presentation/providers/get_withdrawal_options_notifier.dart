import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:cointiply_app/features/wallet/domain/usecases/get_withdrawal_options_usecase.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/withdrawal_option_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWithdrawalOptionNotifier extends StateNotifier<WithdrawalOptionState> {
  final GetWithdrawalOptionsUseCase _getWithdrawalOptionsUseCase;

  GetWithdrawalOptionNotifier(this._getWithdrawalOptionsUseCase)
      : super(const WithdrawalOptionState());

  Future<void> fetchWithdrawalOptions() async {
    state =
        state.copyWith(status: GetWithdrawalOptionStatus.loading, error: null);

    final result = await _getWithdrawalOptionsUseCase.call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
            status: GetWithdrawalOptionStatus.error, error: failure.message);
      },
      (List<WithdrawalOption> options) {
        state = state.copyWith(
            status: GetWithdrawalOptionStatus.data, withdrawalOptions: options);
      },
    );
  }
}
