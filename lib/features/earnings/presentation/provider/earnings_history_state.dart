import 'package:cointiply_app/features/earnings/domain/entity/earnings_history_response.dart';

enum EarningsHistoryStatus {
  initial,
  loading,
  data,
  error,
  loadingMore,
}

class EarningsHistoryState {
  final EarningsHistoryResponse? data;
  final EarningsHistoryStatus status;
  final String? error;
  final int page;
  final int limit;
  final int days;
  final bool isLoadingMore;

  const EarningsHistoryState({
    this.data,
    this.status = EarningsHistoryStatus.initial,
    this.error,
    this.page = 1,
    this.limit = 10,
    this.days = 30,
    this.isLoadingMore = false,
  });

  EarningsHistoryState copyWith({
    EarningsHistoryResponse? data,
    EarningsHistoryStatus? status,
    String? error,
    bool? isLoadingMore,
    int? days,
    int? page,
    int? limit,
  }) {
    return EarningsHistoryState(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error ?? this.error,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      days: days ?? this.days,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  bool get canLoadMore => page < (data?.data?.pagination.totalPages ?? 0);
}
