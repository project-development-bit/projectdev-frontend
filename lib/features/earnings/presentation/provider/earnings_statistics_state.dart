import 'package:cointiply_app/features/earnings/domain/entity/statistics_response.dart';

enum EarningsStatisticsStatus {
  initial,
  loading,
  data,
  error,
}

class EarningsStatisticsState {
  final StatisticsResponse? data;
  final EarningsStatisticsStatus status;
  final String? error;

  const EarningsStatisticsState({
    this.data,
    this.status = EarningsStatisticsStatus.initial,
    this.error,
  });

  EarningsStatisticsState copyWith({
    StatisticsResponse? data,
    EarningsStatisticsStatus? status,
    String? error,
  }) {
    return EarningsStatisticsState(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
