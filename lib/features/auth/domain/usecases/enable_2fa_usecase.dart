import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/enable_2fa_request.dart';
import '../../data/models/enable_2fa_response.dart';
import '../repositories/auth_repository.dart';

/// Use case for enabling Two-Factor Authentication
///
/// This use case handles the business logic for enabling 2FA after setup.
/// It verifies the token from the authenticator app along with the secret
/// to confirm the user has successfully configured their authenticator app.
class Enable2FAUseCase implements UseCase<Enable2FAResponse, Enable2FAParams> {
  final AuthRepository repository;

  Enable2FAUseCase(this.repository);

  @override
  Future<Either<Failure, Enable2FAResponse>> call(Enable2FAParams params) async {
    return await repository.enable2FA(params.request);
  }
}

/// Parameters for the Enable2FA use case
class Enable2FAParams {
  final Enable2FARequest request;

  Enable2FAParams({required this.request});
}
