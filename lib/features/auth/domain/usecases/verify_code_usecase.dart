import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/verify_code_request.dart';
import '../../data/models/verify_code_response.dart';

/// Use case for verifying email with verification code
///
/// This use case handles the business logic for email verification,
/// including API communication and token storage.
class VerifyCodeUseCase
    implements UseCase<VerifyCodeResponse, VerifyCodeRequest> {
  /// Authentication repository for API calls
  final AuthRepository repository;

  /// Creates an instance of [VerifyCodeUseCase]
  const VerifyCodeUseCase(this.repository);

  /// Execute the verify code operation
  ///
  /// Takes a [VerifyCodeRequest] with email and code,
  /// returns either a [Failure] or [VerifyCodeResponse]
  @override
  Future<Either<Failure, VerifyCodeResponse>> call(
      VerifyCodeRequest params) async {
    return await repository.verifyCode(params);
  }
}
