import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateUserProfile
    implements UseCase<UserProfile, UpdateUserProfileParams> {
  const UpdateUserProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UserProfile>> call(
      UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.profile);
  }
}

/// Parameters for updating user profile
class UpdateUserProfileParams extends Equatable {
  const UpdateUserProfileParams({required this.profile});

  final UserProfile profile;

  @override
  List<Object> get props => [profile];
}
