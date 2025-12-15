import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/verify_login_2fa_request.dart';
import '../../data/models/verify_login_2fa_response.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repo_impl.dart';

/// Provider for the Verify Login 2FA use case
final verifyLogin2FAUseCaseProvider = Provider<VerifyLogin2FAUseCase>(
  (ref) => VerifyLogin2FAUseCase(ref.watch(authRepositoryProvider)),
);

/// Use case for verifying 2FA code during login
///
/// This use case verifies the 4-digit code from authenticator app
/// when a user with 2FA enabled attempts to login.
class VerifyLogin2FAUseCase implements UseCase<VerifyLogin2FAResponse, VerifyLogin2FARequest> {
  /// Authentication repository
  final AuthRepository repository;

  /// Creates an instance of [VerifyLogin2FAUseCase]
  VerifyLogin2FAUseCase(this.repository);

  @override
  Future<Either<Failure, VerifyLogin2FAResponse>> call(VerifyLogin2FARequest params) async {
    return await repository.verifyLogin2FA(params);
  }
}
