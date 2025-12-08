import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/wallet/data/repositories/balance_repository_provider.dart';
import 'package:cointiply_app/features/wallet/domain/entity/balance.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/balance_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserBalanceUseCaseProvider = Provider<GetUserBalanceUseCase>((ref) {
  final repo = ref.read(balanceRepositoryProvider);
  return GetUserBalanceUseCase(repo);
});

class GetUserBalanceUseCase implements UseCase<BalanceResponse, NoParams> {
  final BalanceRepository repository;

  GetUserBalanceUseCase(this.repository);

  @override
  Future<Either<Failure, BalanceResponse>> call(NoParams params) async {
    return repository.getUserBalance();
  }
}
