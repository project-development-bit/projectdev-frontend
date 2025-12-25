import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/earnings/data/model/request/earnings_history_request.dart';
import 'package:gigafaucet/features/earnings/domain/entity/earnings_history_item.dart';
import 'package:gigafaucet/features/earnings/domain/usecases/get_earnings_history_use_case.dart';
import 'package:gigafaucet/features/earnings/presentation/provider/earnings_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetEarningsHistoryNotifier extends StateNotifier<EarningsHistoryState> {
  final GetEarningsHistoryUseCase _useCase;

  GetEarningsHistoryNotifier(this._useCase)
      : super(const EarningsHistoryState());

  Future<void> fetchEarningsHistory(EarningsHistoryRequestModel request) async {
    state = state.copyWith(
      status: EarningsHistoryStatus.loading,
      error: null,
      page: 1,
    );

    final result = await _useCase.call(request);

    result.fold(
      (Failure failure) {
        state = state.copyWith(
          status: EarningsHistoryStatus.error,
          error: failure.message ?? 'Something went wrong',
        );
      },
      (response) {
        state = state.copyWith(
          status: EarningsHistoryStatus.data,
          data: response,
          error: null,
          page: response.data?.pagination.page,
        );
      },
    );
  }

  Future<void> loadMore({
    int? days,
  }) async {
    final request = EarningsHistoryRequestModel(
      page: state.page,
      limit: 20,
      days: days ?? 30,
    );
    if (state.isLoadingMore) return;
    if (state.page >= (state.data?.data?.pagination.totalPages ?? 0)) return;

    state = state.copyWith(isLoadingMore: true, days: request.days);

    final nextPage = state.page + 1;
    final updatedRequest = request.copyWith(
      page: nextPage,
    );

    final result = await _useCase.call(updatedRequest);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (response) {
        final currentList = state.data?.data?.earnings ?? [];
        final List<EarningsHistoryItem> newList = [
          ...currentList,
          ...response.data?.earnings ?? []
        ];

        final updatedResponse =
            response.copyWith(data: response.data?.copyWith(earnings: newList));

        state = state.copyWith(
          data: updatedResponse,
          page: nextPage,
          isLoadingMore: false,
        );
      },
    );
  }

  Future<void> changePage(int newPage) async {
    if (newPage == state.page) return;

    final request = EarningsHistoryRequestModel(
      page: newPage,
      limit: state.limit,
      days: state.days,
    );

    state = state.copyWith(
      status: EarningsHistoryStatus.loading,
      error: null,
    );

    final result = await _useCase.call(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: EarningsHistoryStatus.error,
          error: failure.message,
        );
      },
      (response) {
        state = state.copyWith(
          status: EarningsHistoryStatus.data,
          data: response,
          page: newPage,
        );
      },
    );
  }

  Future<void> changeLimit(int newLimit) async {
    // Reset to page 1 whenever changing limit
    final request = EarningsHistoryRequestModel(
      page: 1,
      limit: newLimit,
      days: state.days,
    );

    state = state.copyWith(
      status: EarningsHistoryStatus.loading,
      error: null,
      limit: newLimit,
      page: 1,
    );

    final result = await _useCase.call(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: EarningsHistoryStatus.error,
          error: failure.message,
        );
      },
      (response) {
        state = state.copyWith(
          status: EarningsHistoryStatus.data,
          data: response,
        );
      },
    );
  }
}

final earningsHistoryNotifierProvider = StateNotifierProvider.autoDispose<
    GetEarningsHistoryNotifier, EarningsHistoryState>((ref) {
  final usecase = ref.watch(getEarningsHistoryUseCaseProvider);
  return GetEarningsHistoryNotifier(usecase);
});
