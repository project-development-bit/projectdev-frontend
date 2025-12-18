import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_register_request.dart';
import 'package:gigafaucet/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';

final googleSignUpUseCaseProvider = Provider<GoogleSignUpUseCase>((ref) {
  return GoogleSignUpUseCase(ref.watch(authRepositoryProvider));
});

class GoogleSignUpUseCase implements UseCase<void, GoogleRegisterRequest> {
  final AuthRepository repository;

  GoogleSignUpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(GoogleRegisterRequest request) async {
    return await repository.googleRegister(request);
  }
}
