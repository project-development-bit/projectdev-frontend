import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/check_2fa_status_response.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repo_impl.dart';

/// Provider for the Check 2FA Status use case
final check2FAStatusUseCaseProvider = Provider<Check2FAStatusUseCase>(
  (ref) => Check2FAStatusUseCase(ref.watch(authRepositoryProvider)),
);

/// Use case for checking 2FA status
///
/// This use case checks if 2FA is enabled for the authenticated user
/// by calling the GET /2fa/status endpoint.
class Check2FAStatusUseCase implements UseCase<Check2FAStatusResponse, NoParams> {
  /// Authentication repository
  final AuthRepository repository;

  /// Creates an instance of [Check2FAStatusUseCase]
  Check2FAStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Check2FAStatusResponse>> call(NoParams params) async {
    return await repository.check2FAStatus();
  }
}
