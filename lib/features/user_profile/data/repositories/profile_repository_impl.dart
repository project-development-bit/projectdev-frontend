import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:dartz/dartz.dart';
import 'package:universal_io/io.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../datasources/profile_database_data_source.dart';
import '../models/response/user_profile_model.dart';

/// Implementation of [ProfileRepository]
///
/// This class implements the profile repository interface and coordinates
/// between remote, local, and database data sources. It prioritizes database
/// data for current user profile and handles caching and error handling.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final ProfileDatabaseDataSource databaseDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.databaseDataSource,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      // First, try to get profile from database (current user)
      final databaseResult = await databaseDataSource.getCurrentUserProfile();

      return databaseResult.fold(
        (failure) async {
          // If database fails, try cached data
          final cachedProfile =
              await localDataSource.getCachedUserProfile('current');

          if (cachedProfile != null) {
            final cacheTimestamp =
                await localDataSource.getCacheTimestamp('current');
            if (cacheTimestamp != null &&
                DateTime.now().difference(cacheTimestamp).inMinutes < 5) {
              return Right(cachedProfile);
            }
          }

          // If cache is old or missing, try remote (fallback)
          try {
            final remoteProfile =
                await remoteDataSource.getUserProfile('current');
            await localDataSource.cacheUserProfile(remoteProfile);
            return Right(remoteProfile);
          } catch (e) {
            // If everything fails but we have any cached data, return it
            if (cachedProfile != null) {
              return Right(cachedProfile);
            }
            return Left(
                ServerFailure(message: 'Failed to get user profile: $e'));
          }
        },
        (profile) async {
          // Cache the database result for offline use
          await localDataSource.cacheUserProfile(profile);
          return Right(profile);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserUpdateResponse>> updateUserProfile(
    UserUpdateRequest profile,
  ) async {
    try {
      print('Updating user profile: ${profile.toJson()}');
      // Convert request → model
      // UserProfileModel? cachedModel =
      //     await localDataSource.getCachedUserProfile(profile.id);
      // final profileModel = cachedModel?.copyWith(
      //   username: profile.name,
      //   email: profile.email,
      // );
      print('Profile model to update: 1');

      // Try to update via database first
      // final databaseResult = await databaseDataSource
      //     .updateUserProfile(UserProfileModel.fromEntity(profileModel!));
      // print('Profile model to update: 2');
      // return await databaseResult.fold(
      //   (failure) async {
      //     print('Database update failed: ${failure.message}');
      //     // If local DB update fails, try remote
      //     try {

      //       print('Updated profile from remote: ${updatedProfile.toJson()}');

      //       // Cache the new data
      //       await localDataSource.cacheUserProfile(updatedProfile);
      //       return Right(updatedProfile);
      //     } catch (e) {
      //       return Left(ServerFailure(message: e.toString()));
      //     }
      //   },
      //   (updatedProfile) async {
      //     print('Updated profile from database: ${updatedProfile.toJson()}');
      //     // Cache the successfully updated profile
      //     await localDataSource.cacheUserProfile(updatedProfile);
      //     return Right(updatedProfile);
      //   },
      // );
      final updatedProfile = await remoteDataSource.updateUserProfile(
        profile.id,
        profile.toJson(),
      );
      print('Profile model to update: 3 $updatedProfile');
      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String imagePath) async {
    try {
      // Create File object using universal_io which works on both mobile and web
      final imageFile = File(imagePath);

      // Check if file exists (this works for both platforms)
      if (!await imageFile.exists()) {
        return Left(ServerFailure(message: 'Image file not found: $imagePath'));
      }

      final imageUrl = await remoteDataSource.uploadProfilePicture(
        'current',
        imageFile,
      );

      // Update cached profile with new image URL if it exists
      final cachedProfile =
          await localDataSource.getCachedUserProfile('current');
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
          final updateResult = await updateUserProfile(UserUpdateRequest(
            id: profile.id,
            profilePictureUrl: null,
          ));
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
            return Left(
                ServerFailure(message: 'Profile statistics not available'));
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
      await remoteDataSource.updatePassword(
          'current', currentPassword, newPassword);
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
      await remoteDataSource.updateEmail('current', newEmail);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(String verificationCode) async {
    try {
      await remoteDataSource.verifyEmail('current', verificationCode);

      // Update cached profile to mark email as verified
      final cachedProfile =
          await localDataSource.getCachedUserProfile('current');
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
      await remoteDataSource.verifyPhone('current', verificationCode);

      // Update cached profile verification status
      final cachedProfile =
          await localDataSource.getCachedUserProfile('current');
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
      await remoteDataSource.deleteAccount('current', password);

      // Clear all cached data
      await localDataSource.clearCache();

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Helper method to convert UserProfile entity to Map for API calls
  // Map<String, dynamic> _profileToMap(UserProfile profile) {
  //   return {
  //     'display_name': profile.displayName,
  //     'bio': profile.bio,
  //     'location': profile.location,
  //     'website': profile.website,
  //     'contact_number': profile.contactNumber,
  //     'date_of_birth': profile.dateOfBirth?.toIso8601String(),
  //     'gender': profile.gender,
  //   };
  // }
}
