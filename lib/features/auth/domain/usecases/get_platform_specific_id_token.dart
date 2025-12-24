import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';

final getGooglePlatformIdTokenUseCaseProvider =
    Provider<GetPlatformSpecificIdTokenUseCase>(
  (ref) => GetPlatformSpecificIdTokenUseCase(ref.watch(authRepositoryProvider)),
);

class GetPlatformSpecificIdTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetPlatformSpecificIdTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getGooglePlatformSpecificIdToken();
  }
}
