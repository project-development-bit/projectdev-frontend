import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/wallet/domain/usecases/get_payment_history_usecase.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentHistoryNotifier extends StateNotifier<PaymentHistoryState> {
  final GetPaymentHistoryUseCase _getPaymentHistoryUseCase;

  PaymentHistoryNotifier(this._getPaymentHistoryUseCase)
      : super(const PaymentHistoryState());
  Future<void> fetchPaymentHistory() async {
    state = state.copyWith(
      status: GetPaymentHistoryStatus.loading,
      error: null,
    );

    final result = await _getPaymentHistoryUseCase.call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetPaymentHistoryStatus.error,
          error: failure.message,
        );
      },
      (paymentHistory) {
        print('Fetched ${paymentHistory.length} payment history items');
        state = state.copyWith(
          status: GetPaymentHistoryStatus.data,
          paymentHistory: paymentHistory,
        );
      },
    );
  }
}
