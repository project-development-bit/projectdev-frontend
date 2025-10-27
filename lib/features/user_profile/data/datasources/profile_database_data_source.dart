import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

/// Database data source for profile operations
///
/// This class handles getting user profile data from the local SQLite database
/// by integrating with the authentication system and database service.
abstract class ProfileDatabaseDataSource {
  /// Get current user profile from database
  Future<Either<Failure, UserProfileModel>> getCurrentUserProfile();

  /// Update user profile in database
  Future<Either<Failure, UserProfileModel>> updateUserProfile(
      UserProfileModel profile);
}

/// Implementation of [ProfileDatabaseDataSource]
class ProfileDatabaseDataSourceImpl implements ProfileDatabaseDataSource {
  final SecureStorageService secureStorage;

  ProfileDatabaseDataSourceImpl({required this.secureStorage});

  @override
  Future<Either<Failure, UserProfileModel>> getCurrentUserProfile() async {
    try {
      // Get current user ID from secure storage (from login)
      final currentUserId = await secureStorage.getUserId();

      if (currentUserId == null) {
        return Left(DatabaseFailure(message: 'No authenticated user found'));
      }

      // Convert string ID to int for database query
      final userIdInt = int.tryParse(currentUserId);
      if (userIdInt == null) {
        return Left(DatabaseFailure(message: 'Invalid user ID format'));
      }

      // Get user from database by ID
      final userModel = await DatabaseService.getUserById(userIdInt);

      if (userModel == null) {
        return Left(DatabaseFailure(message: 'User not found in database'));
      }

      // Convert UserModel to UserProfileModel
      final profileModel = _convertUserModelToProfile(userModel);

      return Right(profileModel);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateUserProfile(
      UserProfileModel profile) async {
    try {
      // Get current user ID from secure storage
      final currentUserId = await secureStorage.getUserId();

      if (currentUserId == null) {
        return Left(DatabaseFailure(message: 'No authenticated user found'));
      }

      // For now, we'll just return the same profile since the database
      // only stores basic user info (name, email, role)
      // In a real app, you'd extend the database schema to store more profile fields

      return Right(profile);
    } catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to update user profile: $e'));
    }
  }

  /// Convert UserModel from database to UserProfileModel
  UserProfileModel _convertUserModelToProfile(UserModel user) {
    return UserProfileModel(
      id: user.id.toString(), // Convert int to string
      email: user.email,
      username: user.name, // Use name as username
      displayName: user.name,
      profilePictureUrl: null, // Not stored in current database schema
      bio: null, // Not stored in current database schema
      location: null, // Not stored in current database schema
      website: null, // Not stored in current database schema
      contactNumber: null, // Not stored in current database schema
      dateOfBirth: null, // Not stored in current database schema
      gender: null, // Not stored in current database schema
      accountCreated: DateTime
          .now(), // Default to current time (could be enhanced with actual creation date)
      lastLogin: null, // Could be added to database schema
      accountStatus: AccountStatus.active, // Default status
      verificationStatus: VerificationStatus.verified, // Default status
      isEmailVerified: true, // Assume verified for logged in users
      isPhoneVerified: false, // Not implemented yet
      stats: null, // Not stored in current database schema
    );
  }
}
