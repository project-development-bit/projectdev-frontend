
import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

/// Implementation of [ProfileRepository]
///
/// This class implements the profile repository interface and coordinates
/// between remote, local, and database data sources. It prioritizes database
/// data for current user profile and handles caching and error handling.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  // final ProfileLocalDataSource localDataSource;
  // final ProfileDatabaseDataSource databaseDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    // required this.databaseDataSource,
  });

  @override
  Future<Either<Failure, UserUpdateResponse>> updateUserProfile(
    UserUpdateRequest profile,
  ) async {
    try {
      debugPrint('Updating user profile: ${profile.toJson()}');
      // Convert request → model
      // UserProfileModel? cachedModel =
      //     await localDataSource.getCachedUserProfile(profile.id);
      // final profileModel = cachedModel?.copyWith(
      //   username: profile.name,
      //   email: profile.email,
      // );
      debugPrint('Profile model to update: 1');

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
      // debugPrint('Profile model to update: 3 $updatedProfile');
      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadProfileAvatarResponseModel>> uploadProfilePicture(
      PlatformFile file) async {
    try {
      final imageUrl = await remoteDataSource.uploadProfilePicture(file);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}
