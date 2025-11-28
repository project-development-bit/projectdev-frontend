import 'package:cointiply_app/features/earnings/data/datasources/remote/earnings_history_remote_data_source.dart';
import 'package:cointiply_app/features/earnings/data/repository/earnings_history_repository_impl.dart';
import 'package:cointiply_app/features/earnings/domain/entity/earnings_history_response.dart';
import 'package:dartz/dartz.dart';
import 'package:cointiply_app/core/error/failures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/request/earnings_history_request.dart';

final earningsHistoryRepositoryProvider = Provider<EarningsHistoryRepository>(
  (
    ref,
  ) =>
      EarningsHistoryRepositoryImpl(
    ref.watch(earningsHistoryRemoteDataSourceProvider),
  ),
);

abstract class EarningsHistoryRepository {
  Future<Either<Failure, EarningsHistoryResponse>> getEarningsHistory(
    EarningsHistoryRequestModel request,
  );
}
