import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/country.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/language.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/profile_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../../domain/entities/change_email_result.dart';
import '../../domain/entities/verify_email_change_result.dart';
import '../../domain/entities/change_password_result.dart';
import '../../domain/entities/delete_account_result.dart';
import '../../domain/entities/verify_delete_account_result.dart';
import '../../domain/entities/set_security_pin_result.dart';

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
  Future<Either<Failure, ProfileDetail>> getProfile() async {
    try {
      debugPrint('🔄 Repository: Fetching profile...');
      final profileModel = await remoteDataSource.getProfile();
      
      debugPrint('✅ Repository: Profile fetched successfully');
      return Right(profileModel.toEntity());
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message ?? 'Failed to fetch profile',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyEmailChangeResult>> verifyEmailChange({
    required String email,
    required String code,
  }) async {
    try {
      debugPrint('🔄 Repository: Verifying email change...');
      final responseModel =
          await remoteDataSource.verifyEmailChange(email: email, code: code);

      final data = responseModel.data;

      final result = VerifyEmailChangeResult(
        message: responseModel.message,
        oldEmail: data?.oldEmail ?? '',
        newEmail: data?.newEmail ?? '',
      );

      return Right(result);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to verify email change',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    try {
      debugPrint('🔄 Repository: Fetching countries...');
      final countryModels = await remoteDataSource.getCountries();

      final countries = countryModels.map((model) => model.toEntity()).toList();
      debugPrint(
          '✅ Repository: ${countries.length} countries fetched successfully');
      return Right(countries);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message ?? 'Failed to fetch countries',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Language>>> getLanguages() async {
    try {
      debugPrint('🔄 Repository: Fetching languages...');
      final languageModels = await remoteDataSource.getLanguages();

      final languages =
          languageModels.map((model) => model.toEntity()).toList();
      debugPrint(
          '✅ Repository: ${languages.length} languages fetched successfully');
      return Right(languages);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.message ?? 'Failed to fetch languages',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

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
      if (e is Failure) {
        return Left(e);
      }
      
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChangeEmailResult>> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String repeatNewEmail,
  }) async {
    try {
      debugPrint('🔄 Repository: Changing email...');
      final responseModel = await remoteDataSource.changeEmail(
        currentEmail: currentEmail,
        newEmail: newEmail,
        repeatNewEmail: repeatNewEmail,
      );

      final data = responseModel.data;
      final result = ChangeEmailResult(
        message: responseModel.message,
        currentEmail: data?.currentEmail ?? '',
        newEmail: data?.newEmail ?? '',
        verificationCode: data?.verificationCode,
      );

      return Right(result);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to change email',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChangePasswordResult>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  }) async {
    try {
      debugPrint('🔄 Repository: Changing password...');
      final responseModel = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        repeatNewPassword: repeatNewPassword,
      );

      final result = ChangePasswordResult(
        success: responseModel.success,
        message: responseModel.message,
      );

      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to change password',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeleteAccountResult>> deleteAccount(
      String userId) async {
    try {
      debugPrint('🔄 Repository: Requesting account deletion...');
      final responseModel = await remoteDataSource.deleteAccount(userId);

      final result = DeleteAccountResult(
        success: responseModel.success,
        message: responseModel.message,
        email: responseModel.email,
        verificationCode: responseModel.verificationCode,
      );

      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to request account deletion',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyDeleteAccountResult>> verifyDeleteAccount(
      String code) async {
    try {
      debugPrint('🔄 Repository: Verifying account deletion...');
      final responseModel = await remoteDataSource.verifyDeleteAccount(code);

      final result = VerifyDeleteAccountResult(
        success: responseModel.success,
        message: responseModel.message,
        deletedUserId: responseModel.deletedUserId,
        deletedEmail: responseModel.deletedEmail,
      );

      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to verify account deletion',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SetSecurityPinResult>> setSecurityPin({
    required int securityPin,
    required bool enable,
  }) async {
    try {
      debugPrint('🔄 Repository: Setting security PIN (enable: $enable)...');
      final responseModel = await remoteDataSource.setSecurityPin(
        securityPin: securityPin,
        enable: enable,
      );

      final result = SetSecurityPinResult(
        success: responseModel.success,
        message: responseModel.message,
        securityPinEnabled: responseModel.securityPinEnabled,
      );

      return Right(result);
    } on ServerFailure catch (e) {
      debugPrint('❌ Repository: ServerFailure - ${e.message}');
      return Left(e);
    } on DioException catch (e) {
      debugPrint('❌ Repository: DioException - ${e.message}');
      ErrorModel? errorModel;
      if (e.response?.data != null) {
        errorModel = ErrorModel.fromJson(e.response!.data);
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ??
            e.message ??
            'Failed to set security PIN',
        statusCode: e.response?.statusCode,
        errorModel: errorModel,
      ));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected error - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
