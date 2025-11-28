import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:cointiply_app/features/earnings/domain/entity/statistics_response.dart';
import 'package:cointiply_app/features/earnings/domain/usecases/get_earnings_statistics_use_case.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_statistics_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetEarningsStatisticsNotifier
    extends StateNotifier<EarningsStatisticsState> {
  final GetEarningsStatisticsUseCase _useCase;

  GetEarningsStatisticsNotifier(this._useCase)
      : super(const EarningsStatisticsState());

  Future<void> fetchStatistics(EarningsStatisticsRequest request) async {
    state = state.copyWith(
      status: EarningsStatisticsStatus.loading,
      error: null,
    );
    final result = await _useCase.call(request);
    result.fold(
      (Failure failure) {
        state = state.copyWith(
          status: EarningsStatisticsStatus.error,
          error: failure.message ?? 'Something went wrong',
        );
      },
      (response) {
        state = state.copyWith(
          status: EarningsStatisticsStatus.data,
          data: response,
          error: null,
        );
      },
    );
  }
}

final earningsStatisticsNotifierProvider = StateNotifierProvider<
    GetEarningsStatisticsNotifier, EarningsStatisticsState>((ref) {
  final usecase = ref.watch(getEarningsStatisticsUseCaseProvider);
  return GetEarningsStatisticsNotifier(usecase);
});
// is loading
final earningsStatisticsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(earningsStatisticsNotifierProvider);
  return state.status == EarningsStatisticsStatus.loading;
});
// has error
final earningsStatisticsErrorProvider = Provider.autoDispose<String?>((ref) {
  final state = ref.watch(earningsStatisticsNotifierProvider);
  if (state.status == EarningsStatisticsStatus.error) {
    return state.error;
  }
  return null;
});
// data
final earningsStatisticsDataProvider =
    Provider.autoDispose<StatisticsResponse?>((ref) {
  final state = ref.watch(earningsStatisticsNotifierProvider);
  if (state.status == EarningsStatisticsStatus.data) {
    return state.data;
  }
  return null;
});
