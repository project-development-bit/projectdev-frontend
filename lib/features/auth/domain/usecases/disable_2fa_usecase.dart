import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/disable_2fa_request.dart';
import '../../data/models/disable_2fa_response.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repo_impl.dart';

/// Provider for the Disable 2FA use case
final disable2FAUseCaseProvider = Provider<Disable2FAUseCase>(
  (ref) => Disable2FAUseCase(ref.watch(authRepositoryProvider)),
);

/// Use case for disabling 2FA
///
/// This use case disables Two-Factor Authentication for the authenticated user
/// by calling the POST /2fa/disable endpoint.
class Disable2FAUseCase implements UseCase<Disable2FAResponse, Disable2FARequest> {
  /// Authentication repository
  final AuthRepository repository;

  /// Creates an instance of [Disable2FAUseCase]
  Disable2FAUseCase(this.repository);

  @override
  Future<Either<Failure, Disable2FAResponse>> call(Disable2FARequest params) async {
    return await repository.disable2FA(params);
  }
}
