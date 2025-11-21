import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_detail.dart';

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

}
