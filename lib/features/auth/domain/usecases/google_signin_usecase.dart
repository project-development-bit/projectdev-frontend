import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/data/models/login_response_model.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_login_request.dart';
import 'package:gigafaucet/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  return GoogleSignInUseCase(ref.watch(authRepositoryProvider));
});

class GoogleSignInUseCase
    implements UseCase<LoginResponseModel, GoogleLoginRequest> {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(
      GoogleLoginRequest request) async {
    return await repository.googleSignIn(request);
  }
}
