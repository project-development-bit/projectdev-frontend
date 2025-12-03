import 'package:cointiply_app/features/user_profile/domain/entities/verify_delete_account_result.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for verifying account deletion with code
class VerifyDeleteAccountUsecase
    implements UseCase<VerifyDeleteAccountResult, VerifyDeleteAccountParams> {
  const VerifyDeleteAccountUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, VerifyDeleteAccountResult>> call(
      VerifyDeleteAccountParams params) async {
    return await repository.verifyDeleteAccount(params.code);
  }
}

/// Parameters for verifying account deletion
class VerifyDeleteAccountParams extends Equatable {
  const VerifyDeleteAccountParams({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => [code];
}
