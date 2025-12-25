import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:gigafaucet/features/earnings/domain/usecases/get_earnings_statistics_use_case.dart';
import 'package:gigafaucet/features/earnings/presentation/provider/earnings_statistics_state.dart';
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

final earningsStatisticsNotifierProvider = StateNotifierProvider.autoDispose<
    GetEarningsStatisticsNotifier, EarningsStatisticsState>((ref) {
  final usecase = ref.watch(getEarningsStatisticsUseCaseProvider);
  return GetEarningsStatisticsNotifier(usecase);
});
