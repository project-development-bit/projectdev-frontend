import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verify_delete_account_result.dart';
import '../repositories/profile_repository.dart';

/// Use case for verifying account deletion with verification code
///
/// This completes the two-step account deletion process by verifying
/// the code sent to the user's email.
class VerifyDeleteAccountUsecase
    implements UseCase<VerifyDeleteAccountResult, VerifyDeleteAccountParams> {
  final ProfileRepository repository;

  VerifyDeleteAccountUsecase(this.repository);

  @override
  Future<Either<Failure, VerifyDeleteAccountResult>> call(
      VerifyDeleteAccountParams params) async {
    return await repository.verifyDeleteAccount(params.code);
  }
}

/// Parameters for verifying account deletion
class VerifyDeleteAccountParams {
  final String code;

  VerifyDeleteAccountParams({required this.code});
}
