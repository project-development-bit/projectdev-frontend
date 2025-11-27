import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/change_email_result.dart';
import '../repositories/profile_repository.dart';

class ChangeEmailUsecase implements UseCase<ChangeEmailResult, ChangeEmailParams> {
  final ProfileRepository repository;
  ChangeEmailUsecase(this.repository);

  @override
  Future<Either<Failure, ChangeEmailResult>> call(ChangeEmailParams params) async {
    return await repository.changeEmail(
      currentEmail: params.currentEmail,
      newEmail: params.newEmail,
      repeatNewEmail: params.repeatNewEmail,
    );
  }
}

class ChangeEmailParams {
  final String currentEmail;
  final String newEmail;
  final String repeatNewEmail;

  ChangeEmailParams({required this.currentEmail, required this.newEmail, required this.repeatNewEmail});
}
