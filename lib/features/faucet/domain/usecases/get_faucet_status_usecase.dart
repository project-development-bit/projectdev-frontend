import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/faucet/data/model/actual_faucet_status_model.dart';
import 'package:cointiply_app/features/faucet/data/repository/faucet_repository_provider.dart';
import 'package:cointiply_app/features/faucet/domain/repository/faucet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFaucetStatusUseCaseProvider = Provider<GetFaucetStatusUseCase>((ref) {
  final repo = ref.read(faucetRepositoryProvider);
  return GetFaucetStatusUseCase(repo);
});

class GetFaucetStatusUseCase implements UseCase<ActualFaucetStatusModel, bool> {
  final FaucetRepository repository;

  GetFaucetStatusUseCase(this.repository);

  @override
  Future<Either<Failure, ActualFaucetStatusModel>> call(bool isPublic) {
    return repository.getFaucetStatus(isPublic: isPublic);
  }
}
