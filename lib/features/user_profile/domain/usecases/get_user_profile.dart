import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting user profile
class GetUserProfile implements UseCaseNoParams<UserProfile> {
  const GetUserProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getUserProfile();
  }
}