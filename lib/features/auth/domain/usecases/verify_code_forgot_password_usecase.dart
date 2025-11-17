import 'package:cointiply_app/features/auth/data/models/verify_code_forgot_password_response.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/verify_code_request.dart';
import '../../data/models/verify_code_response.dart';

/// Verify code for forgot password use case
///
/// This use case handles the business logic for email verification,
/// including API communication and token storage.
class VerifyCodeForgotPasswordUsecase
    implements UseCase<VerifyCodeForForgotPasswordResponse, VerifyCodeRequest> {
  /// Authentication repository for API calls
  final AuthRepository repository;

  /// Creates an instance of [VerifyCodeForgotPasswordUsecase]
  const VerifyCodeForgotPasswordUsecase(this.repository);

  /// Execute the verify code operation
  ///
  /// Takes a [VerifyCodeRequest] with email and code,
  /// returns either a [Failure] or [VerifyCodeResponse]
  @override
  Future<Either<Failure, VerifyCodeForForgotPasswordResponse>> call(
      VerifyCodeRequest params) async {
    return await repository.verifyCodeForForgotPassword(params);
  }
}
