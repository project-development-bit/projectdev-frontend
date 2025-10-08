import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

/// Implementation of [ProfileRepository]
/// 
/// This class implements the profile repository interface and coordinates
/// between remote and local data sources. It handles caching, error handling,
/// and data transformation between domain entities and data models.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  
  // TODO: Get current user ID from authentication provider
  final String _currentUserId = '1'; // Temporary - should come from auth

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      // Try to get cached profile first
      final cachedProfile = await localDataSource.getCachedUserProfile(_currentUserId);
      
      // Check if cache is valid (less than 5 minutes old)
      if (cachedProfile != null) {
        final cacheTimestamp = await localDataSource.getCacheTimestamp(_currentUserId);
        if (cacheTimestamp != null && 
            DateTime.now().difference(cacheTimestamp).inMinutes < 5) {
          return Right(cachedProfile);
        }
      }

      // Fetch from remote
      final remoteProfile = await remoteDataSource.getUserProfile(_currentUserId);
      
      // Cache the fresh data
      await localDataSource.cacheUserProfile(remoteProfile);
      
      return Right(remoteProfile);
    } catch (e) {
      // If remote fails and we have cached data, return cached data
      final cachedProfile = await localDataSource.getCachedUserProfile(_currentUserId);
      if (cachedProfile != null) {
        return Right(cachedProfile);
      }
      
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile) async {
    try {
      final updatedProfile = await remoteDataSource.updateUserProfile(
        _currentUserId,
        _profileToMap(profile),
      );
      
      // Update cache with new data
      await localDataSource.cacheUserProfile(updatedProfile);
      
      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageUrl = await remoteDataSource.uploadProfilePicture(
        _currentUserId,
        imageFile,
      );
      
      // Update cached profile with new image URL if it exists
      final cachedProfile = await localDataSource.getCachedUserProfile(_currentUserId);
      if (cachedProfile != null) {
        final updatedProfile = UserProfileModel.fromEntity(
          cachedProfile.copyWith(profilePictureUrl: imageUrl),
        );
        await localDataSource.cacheUserProfile(updatedProfile);
      }
      
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProfilePicture() async {
    try {
      // Update profile with null profile picture URL
      final result = await getUserProfile();
      return result.fold(
        (failure) => Left(failure),
        (profile) async {
          final updatedProfile = profile.copyWith(profilePictureUrl: null);
          final updateResult = await updateUserProfile(updatedProfile);
          return updateResult.fold(
            (failure) => Left(failure),
            (_) => const Right(unit),
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileStats>> getProfileStats() async {
    try {
      // Get full profile to extract stats
      final profileResult = await getUserProfile();
      
      return profileResult.fold(
        (failure) => Left(failure),
        (profile) {
          if (profile.stats != null) {
            return Right(profile.stats!);
          } else {
            return Left(ServerFailure(message: 'Profile statistics not available'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.updatePassword(_currentUserId, currentPassword, newPassword);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      await remoteDataSource.updateEmail(_currentUserId, newEmail);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(String verificationCode) async {
    try {
      await remoteDataSource.verifyEmail(_currentUserId, verificationCode);
      
      // Update cached profile verification status
      final cachedProfile = await localDataSource.getCachedUserProfile(_currentUserId);
      if (cachedProfile != null) {
        final updatedProfile = UserProfileModel.fromEntity(
          cachedProfile.copyWith(isEmailVerified: true),
        );
        await localDataSource.cacheUserProfile(updatedProfile);
      }
      
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyPhoneNumber({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    try {
      await remoteDataSource.verifyPhone(_currentUserId, verificationCode);
      
      // Update cached profile verification status
      final cachedProfile = await localDataSource.getCachedUserProfile(_currentUserId);
      if (cachedProfile != null) {
        final updatedProfile = UserProfileModel.fromEntity(
          cachedProfile.copyWith(isPhoneVerified: true),
        );
        await localDataSource.cacheUserProfile(updatedProfile);
      }
      
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String password) async {
    try {
      await remoteDataSource.deleteAccount(_currentUserId, password);
      
      // Clear all cached data
      await localDataSource.clearCache();
      
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Helper method to convert UserProfile entity to Map for API calls
  Map<String, dynamic> _profileToMap(UserProfile profile) {
    return {
      'display_name': profile.displayName,
      'bio': profile.bio,
      'location': profile.location,
      'website': profile.website,
      'contact_number': profile.contactNumber,
      'date_of_birth': profile.dateOfBirth?.toIso8601String(),
      'gender': profile.gender,
    };
  }
}