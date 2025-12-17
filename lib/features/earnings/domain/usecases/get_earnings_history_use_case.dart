import 'package:gigafaucet/features/earnings/domain/entity/earnings_history_response.dart';
import 'package:gigafaucet/features/earnings/domain/repository/earnings_history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/model/request/earnings_history_request.dart';

final getEarningsHistoryUseCaseProvider = Provider<GetEarningsHistoryUseCase>(
  (ref) =>
      GetEarningsHistoryUseCase(ref.watch(earningsHistoryRepositoryProvider)),
);

class GetEarningsHistoryUseCase
    implements UseCase<EarningsHistoryResponse, EarningsHistoryRequestModel> {
  final EarningsHistoryRepository repository;

  GetEarningsHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, EarningsHistoryResponse>> call(
      EarningsHistoryRequestModel params) async {
    return await repository.getEarningsHistory(params);
  }
}
