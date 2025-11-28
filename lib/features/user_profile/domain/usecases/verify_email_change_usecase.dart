import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verify_email_change_result.dart';
import '../repositories/profile_repository.dart';

class VerifyEmailChangeUsecase implements UseCase<VerifyEmailChangeResult, VerifyEmailChangeParams> {
  final ProfileRepository repository;
  VerifyEmailChangeUsecase(this.repository);

  @override
  Future<Either<Failure, VerifyEmailChangeResult>> call(VerifyEmailChangeParams params) async {
    return await repository.verifyEmailChange(email: params.email, code: params.code);
  }
}

class VerifyEmailChangeParams {
  final String email;
  final String code;

  VerifyEmailChangeParams({required this.email, required this.code});
}
