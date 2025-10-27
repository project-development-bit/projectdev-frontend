import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting user profile statistics
class GetProfileStats implements UseCaseNoParams<UserProfileStats> {
  const GetProfileStats(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, UserProfileStats>> call() async {
    return await repository.getProfileStats();
  }
}
