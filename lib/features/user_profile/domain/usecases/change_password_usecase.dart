import 'package:gigafaucet/features/user_profile/domain/entities/change_password_result.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for changing user password
class ChangePasswordUsecase
    implements UseCase<ChangePasswordResult, ChangePasswordParams> {
  const ChangePasswordUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, ChangePasswordResult>> call(
      ChangePasswordParams params) async {
    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      repeatNewPassword: params.repeatNewPassword,
    );
  }
}

/// Parameters for changing password
class ChangePasswordParams extends Equatable {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.repeatNewPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String repeatNewPassword;

  @override
  List<Object> get props => [currentPassword, newPassword, repeatNewPassword];
}
