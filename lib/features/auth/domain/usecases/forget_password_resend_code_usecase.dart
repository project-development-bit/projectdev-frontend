import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/resend_code_request.dart';
import '../../data/models/resend_code_response.dart';

/// Forget password resend code use case
///
/// Handles resending verification code to user's email
class ForgetPasswordResendCodeUsecase
    implements UseCase<ResendCodeResponse, ResendCodeRequest> {
  final AuthRepository repository;

  ForgetPasswordResendCodeUsecase(this.repository);

  @override
  Future<Either<Failure, ResendCodeResponse>> call(
      ResendCodeRequest params) async {
    return await repository.resendCodeForForgotPassword(params);
  }
}
