import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';

enum GetPaymentHistoryStatus {
  initial,
  loading,
  data,
  error,
}

class PaymentHistoryState {
  final GetPaymentHistoryStatus status;
  final List<PaymentHistory> paymentHistory;
  final String? error;

  const PaymentHistoryState({
    this.status = GetPaymentHistoryStatus.initial,
    this.paymentHistory = const [],
    this.error,
  });

  PaymentHistoryState copyWith({
    GetPaymentHistoryStatus? status,
    List<PaymentHistory>? paymentHistory,
    String? error,
  }) {
    return PaymentHistoryState(
      status: status ?? this.status,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      error: error ?? this.error,
    );
  }
}
