import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/resend_code_request.dart';
import '../../data/models/resend_code_response.dart';

/// Resend verification code use case
///
/// Handles resending verification code to user's email
class ResendCodeUseCase
    implements UseCase<ResendCodeResponse, ResendCodeRequest> {
  final AuthRepository repository;

  ResendCodeUseCase(this.repository);

  @override
  Future<Either<Failure, ResendCodeResponse>> call(
      ResendCodeRequest params) async {
    return await repository.resendCode(params);
  }
}
