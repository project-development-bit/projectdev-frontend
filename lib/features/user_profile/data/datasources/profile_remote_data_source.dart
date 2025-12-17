import 'package:gigafaucet/features/user_profile/data/models/country_model.dart';
import 'package:gigafaucet/features/localization/data/model/response/language_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/profile_detail_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/change_email_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/verify_email_change_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/change_password_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/delete_account_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/verify_delete_account_response_model.dart';
import 'package:gigafaucet/features/user_profile/data/models/response/set_security_pin_response_model.dart';
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

  /// Change user email (send verification code to new email)
  Future<ChangeEmailResponseModel> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String repeatNewEmail,
  });

  /// Verify email change using code sent to new email
  Future<VerifyEmailChangeResponseModel> verifyEmailChange({
    required String email,
    required String code,
  });

  /// Change user password
  Future<ChangePasswordResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  });

  /// Updates user profile
  Future<UserUpdateResponse> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  );

  /// Uploads profile picture
  Future<UploadProfileAvatarResponseModel> uploadProfilePicture(
      PlatformFile imageFile);

  /// Delete user account permanently (sends verification code)
  Future<DeleteAccountResponseModel> deleteAccount(String userId);

  /// Verify account deletion with code
  Future<VerifyDeleteAccountResponseModel> verifyDeleteAccount(String code);

  /// Set or update security PIN
  Future<SetSecurityPinResponseModel> setSecurityPin({
    required int securityPin,
    required bool enable,
  });
}
