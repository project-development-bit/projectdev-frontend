import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/wallet/data/repositories/withdrawal_option_repository_provider.dart';
import 'package:cointiply_app/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/withdrawal_option_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWithdrawalOptionsUseCaseProvider =
    Provider<GetWithdrawalOptionsUseCase>((ref) {
  final repo = ref.read(withdrawalOptionRepositoryProvider);
  return GetWithdrawalOptionsUseCase(repo);
});

class GetWithdrawalOptionsUseCase
    implements UseCase<List<WithdrawalOption>, NoParams> {
  final WithdrawalOptionRepository repository;

  GetWithdrawalOptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WithdrawalOption>>> call(NoParams params) async {
    return await repository.getWithdrawalOptions();
  }
}
