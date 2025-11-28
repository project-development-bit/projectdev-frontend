import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_history_request.dart';
import 'package:cointiply_app/features/earnings/domain/entity/earnings_history_item.dart';
import 'package:cointiply_app/features/earnings/domain/usecases/get_earnings_history_use_case.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_history_state.dart';
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
          totalPages: response.data?.pagination.totalPages,
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
      days: days ?? 7,
    );
    if (state.isLoadingMore) return;
    if (state.page >= state.totalPages) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.page + 1;
    final updatedRequest = request.copyWith(page: nextPage);

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
          totalPages: response.data?.pagination.totalPages,
          isLoadingMore: false,
        );
      },
    );
  }
}

final earningsHistoryNotifierProvider =
    StateNotifierProvider<GetEarningsHistoryNotifier, EarningsHistoryState>(
        (ref) {
  final usecase = ref.watch(getEarningsHistoryUseCaseProvider);
  return GetEarningsHistoryNotifier(usecase);
});
