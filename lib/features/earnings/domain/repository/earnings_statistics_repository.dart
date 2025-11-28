import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/earnings/data/datasources/remote/earnings_statistics_remote_data_source.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_statistics_request.dart';
import 'package:cointiply_app/features/earnings/data/repository/earnings_statistics_repository_impl.dart';
import 'package:cointiply_app/features/earnings/domain/entity/statistics_response.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final earningsStatisticsRepositoryProvider =
    Provider<EarningsStatisticsRepository>(
  (ref) => EarningsStatisticsRepositoryImpl(
    ref.watch(earningsStatisticsRemoteDataSourceProvider),
  ),
);

abstract class EarningsStatisticsRepository {
  Future<Either<Failure, StatisticsResponse>> getStatistics(
    EarningsStatisticsRequest request,
  );
}
