import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/auth/data/models/login_response_model.dart';
import 'package:gigafaucet/features/auth/data/models/request/facebook_login_request.dart';
import 'package:gigafaucet/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';

final facebookLoginUseCaseProvider = Provider<FacebookLoginUseCase>((ref) {
  return FacebookLoginUseCase(ref.watch(authRepositoryProvider));
});

// Facebook Login Use Case
class FacebookLoginUseCase
    implements UseCase<LoginResponseModel, FacebookLoginRequest> {
  final AuthRepository repository;

  FacebookLoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(
      FacebookLoginRequest request) async {
    return await repository.facebookLogin(request);
  }
}
