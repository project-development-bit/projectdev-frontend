import 'package:gigafaucet/features/user_profile/domain/entities/delete_account_result.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for deleting user account
class DeleteAccountUsecase
    implements UseCase<DeleteAccountResult, DeleteAccountParams> {
  const DeleteAccountUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, DeleteAccountResult>> call(
      DeleteAccountParams params) async {
    return await repository.deleteAccount(params.userId);
  }
}

/// Parameters for deleting account
class DeleteAccountParams extends Equatable {
  const DeleteAccountParams({
    required this.userId,
  });

  final String userId;

  @override
  List<Object> get props => [userId];
}
