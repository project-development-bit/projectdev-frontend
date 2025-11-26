import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateUserProfileUsecase
    implements UseCase<UserUpdateResponse, UpdateUserProfileParams> {
  const UpdateUserProfileUsecase(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UserUpdateResponse>> call(
      UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.profile);
  }
}

/// Parameters for updating user profile
class UpdateUserProfileParams extends Equatable {
  const UpdateUserProfileParams({required this.profile});

  final UserUpdateRequest profile;

  @override
  List<Object> get props => [profile];
}
