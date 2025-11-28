import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_detail.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting user profile information
///
/// This use case retrieves the complete user profile including:
/// - Account information (username, email, avatar, etc.)
/// - Security settings (2FA status, security PIN status)
/// - User preferences (language, notifications, stats visibility, etc.)
///
/// This follows the clean architecture pattern where use cases
/// coordinate business logic and interact with repositories.
class GetProfileUseCase implements UseCaseNoParams<ProfileDetail> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileDetail>> call() async {
    return await repository.getProfile();
  }
}
