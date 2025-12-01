import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entity/statistics_response.dart';
import '../../domain/repository/earnings_statistics_repository.dart';
import '../../data/model/request/earnings_statistics_request.dart';

final getEarningsStatisticsUseCaseProvider =
    Provider.autoDispose<GetEarningsStatisticsUseCase>(
  (ref) => GetEarningsStatisticsUseCase(
    ref.watch(earningsStatisticsRepositoryProvider),
  ),
);

class GetEarningsStatisticsUseCase
    implements UseCase<StatisticsResponse, EarningsStatisticsRequest> {
  final EarningsStatisticsRepository repository;

  GetEarningsStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, StatisticsResponse>> call(
      EarningsStatisticsRequest params) async {
    return await repository.getStatistics(params);
  }
}
