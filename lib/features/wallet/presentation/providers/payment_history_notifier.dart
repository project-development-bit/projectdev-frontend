import 'package:gigafaucet/features/wallet/data/models/request/payment_history_request.dart';
import 'package:gigafaucet/features/wallet/domain/usecases/get_payment_history_usecase.dart';
import 'package:gigafaucet/features/wallet/presentation/providers/payment_history_state.dart';
import 'package:flutter/widgets.dart';
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
    final result = await _getPaymentHistoryUseCase.call(PaymentHistoryRequest(
      page: state.page,
      limit: state.limit,
      status: state.filterStatus == "all"
          ? null
          : state.filterStatus?.toLowerCase(),
      filterCurrency: state.filterCurrency == "all"
          ? null
          : state.filterCurrency?.toLowerCase(),
      // type: state.filterType,
    ));

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetPaymentHistoryStatus.error,
          error: failure.message,
        );
      },
      (paymentHistory) {
        debugPrint('Fetched ${paymentHistory.payments} payment history items');
        state = state.copyWith(
          status: GetPaymentHistoryStatus.data,
          paymentHistory: paymentHistory.payments,
          error: null,
          pagination: paymentHistory.pagination,
        );
      },
    );
  }

  void changePage(int newPage) {
    state = state.copyWith(page: newPage);
    fetchPaymentHistory();
  }

  void changeLimit(int newLimit) {
    state = state.copyWith(limit: newLimit, page: 1);
    fetchPaymentHistory();
  }

  void changeStatus(String type) {
    state = state.copyWith(
      filterType: type,
      page: 1,
    );
    fetchPaymentHistory();
  }

  void changeFilterCurrency(String currency) {
    print("Changing filter currency to $currency");
    state = state.copyWith(
      filterCurrency: currency,
      page: 1,
    );
    fetchPaymentHistory();
  }

  void refresh() {
    fetchPaymentHistory();
  }
}
