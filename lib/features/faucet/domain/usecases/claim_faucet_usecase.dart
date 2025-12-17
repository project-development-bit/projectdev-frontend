import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/faucet/data/repository/faucet_repository_provider.dart';
import 'package:cointiply_app/features/faucet/data/request/claim_faucet_request_model.dart';
import 'package:cointiply_app/features/faucet/domain/repository/faucet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final claimFaucetUseCaseProvider = Provider<ClaimFaucetUseCase>((ref) {
  final repo = ref.read(faucetRepositoryProvider);
  return ClaimFaucetUseCase(repo);
});

class ClaimFaucetUseCase implements UseCase<Unit, ClaimFaucetRequestModel> {
  final FaucetRepository repository;

  ClaimFaucetUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    ClaimFaucetRequestModel params,
  ) {
    return repository.claimFaucet(params);
  }
}
