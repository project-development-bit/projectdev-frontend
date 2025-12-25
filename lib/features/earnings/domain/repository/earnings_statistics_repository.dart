import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/earnings/data/datasources/remote/earnings_remote_data_source.dart';
import 'package:gigafaucet/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:gigafaucet/features/earnings/data/repository/earnings_statistics_repository_impl.dart';
import 'package:gigafaucet/features/earnings/domain/entity/statistics_response.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final earningsStatisticsRepositoryProvider =
    Provider<EarningsStatisticsRepository>(
  (ref) => EarningsStatisticsRepositoryImpl(
    ref.watch(earningsRemoteDataSourceProvider),
  ),
);

abstract class EarningsStatisticsRepository {
  Future<Either<Failure, StatisticsResponse>> getStatistics(
    EarningsStatisticsRequest request,
  );
}
