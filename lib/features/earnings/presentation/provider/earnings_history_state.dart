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
  final int totalPages;
  final bool isLoadingMore;

  const EarningsHistoryState({
    this.data,
    this.status = EarningsHistoryStatus.initial,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
  });

  EarningsHistoryState copyWith({
    EarningsHistoryResponse? data,
    EarningsHistoryStatus? status,
    String? error,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return EarningsHistoryState(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get canLoadMore => page < totalPages;
}
