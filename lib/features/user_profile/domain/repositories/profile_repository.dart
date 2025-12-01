import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/country.dart';
import '../entities/language.dart';
import '../entities/profile_detail.dart';
import '../entities/change_email_result.dart';
import '../entities/verify_email_change_result.dart';
import '../entities/change_password_result.dart';
import '../entities/delete_account_result.dart';

/// Abstract repository interface for profile operations
///
/// This interface defines the contract for profile data operations.
/// It uses the repository pattern to abstract data sources and
/// implements clean architecture principles.
abstract class ProfileRepository {
  /// Get the user's complete profile
  ///
  /// Returns [ProfileDetail] on success or [Failure] on error
  Future<Either<Failure, ProfileDetail>> getProfile();

  /// Get list of available countries
  ///
  /// Returns list of [Country] on success or [Failure] on error
  Future<Either<Failure, List<Country>>> getCountries();

  /// Get list of available languages
  ///
  /// Returns list of [Language] on success or [Failure] on error
  Future<Either<Failure, List<Language>>> getLanguages();

  /// Update the user's profile
  ///
  /// [profile] - Updated profile data
  /// Returns updated [UserUpdateResponse] on success or [Failure] on error
  Future<Either<Failure, UserUpdateResponse>> updateUserProfile(
      UserUpdateRequest profile);

  /// Upload a new profile picture
  ///
  /// [imagePath] - Local path to the image file
  /// Returns the new image URL on success or [Failure] on error
  Future<Either<Failure, UploadProfileAvatarResponseModel>>
      uploadProfilePicture(PlatformFile file);

  /// Change user email - sends verification to new email
  Future<Either<Failure, ChangeEmailResult>> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String repeatNewEmail,
  });

  /// Verify the email change with code sent to the new email
  Future<Either<Failure, VerifyEmailChangeResult>> verifyEmailChange({
    required String email,
    required String code,
  });

  /// Change user password
  Future<Either<Failure, ChangePasswordResult>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  });

  /// Delete user account permanently
  ///
  /// [userId] - The ID of the user to delete
  /// Returns [DeleteAccountResult] on success or [Failure] on error
  Future<Either<Failure, DeleteAccountResult>> deleteAccount(String userId);
}
