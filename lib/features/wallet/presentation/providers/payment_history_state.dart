import 'package:gigafaucet/core/common/model/pagination_model.dart';
import 'package:gigafaucet/features/wallet/domain/entity/payment_history.dart';

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
  final int page;
  final int limit;
  final PaginationModel? pagination;

  final String? filterStatus;
  final String? filterCurrency;
  const PaymentHistoryState({
    this.status = GetPaymentHistoryStatus.initial,
    this.paymentHistory = const [],
    this.error,
    this.page = 1,
    this.limit = 10,
    this.filterStatus,
    this.filterCurrency,
    this.pagination,
  });

  PaymentHistoryState copyWith({
    GetPaymentHistoryStatus? status,
    List<PaymentHistory>? paymentHistory,
    String? error,
    int? page,
    int? limit,
    String? filterType,
    String? filterCurrency,
    PaginationModel? pagination,
  }) {
    return PaymentHistoryState(
        status: status ?? this.status,
        paymentHistory: paymentHistory ?? this.paymentHistory,
        error: error ?? this.error,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        filterStatus: filterType ?? this.filterStatus,
        filterCurrency: filterCurrency ?? this.filterCurrency,
        pagination: pagination ?? this.pagination);
  }
}
