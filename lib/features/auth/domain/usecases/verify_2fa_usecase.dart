import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/verify_2fa_request.dart';
import '../../data/models/verify_2fa_response.dart';
import '../../data/repositories/auth_repo_impl.dart';

/// Use case for verifying 2FA code
class Verify2FAUseCase implements UseCase<Verify2FAResponse, Verify2FARequest> {
  final AuthRepository repository;

  Verify2FAUseCase(this.repository);

  @override
  Future<Either<Failure, Verify2FAResponse>> call(
      Verify2FARequest params) async {
    return await repository.verify2FA(params);
  }
}

/// Provider for the verify 2FA use case
final verify2FAUseCaseProvider = Provider<Verify2FAUseCase>((ref) {
  return Verify2FAUseCase(ref.watch(authRepositoryProvider));
});
