import 'package:cointiply_app/features/user_profile/data/models/country_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/language_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/profile_detail_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:file_picker/file_picker.dart';

/// Abstract class for profile remote data source
///
/// This defines the contract for fetching and managing user profile data
/// from remote APIs. Implementations will handle HTTP requests,
/// authentication, and error responses.
abstract class ProfileRemoteDataSource {
  /// Gets the complete user profile
  Future<ProfileDetailModel> getProfile();

  /// Gets list of available countries
  Future<List<CountryModel>> getCountries();

  /// Gets list of available languages
  Future<List<LanguageModel>> getLanguages();

  /// Updates user profile
  Future<UserUpdateResponse> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  );

  /// Uploads profile picture
  Future<UploadProfileAvatarResponseModel> uploadProfilePicture(
      PlatformFile imageFile);

}
