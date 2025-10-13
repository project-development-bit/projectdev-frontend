import 'dart:io';
import '../models/user_profile_model.dart';

/// Abstract class for profile remote data source
/// 
/// This defines the contract for fetching and managing user profile data
/// from remote APIs. Implementations will handle HTTP requests,
/// authentication, and error responses.
abstract class ProfileRemoteDataSource {
  /// Gets user profile by ID
  Future<UserProfileModel> getUserProfile(String userId);

  /// Updates user profile
  Future<UserProfileModel> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  );

  /// Uploads profile picture
  Future<String> uploadProfilePicture(String userId, File imageFile);

  /// Updates user password
  Future<void> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  );

  /// Updates user email
  Future<void> updateEmail(String userId, String newEmail);

  /// Verifies email with code
  Future<void> verifyEmail(String userId, String verificationCode);

  /// Verifies phone with code
  Future<void> verifyPhone(String userId, String verificationCode);

  /// Sends verification email
  Future<void> sendVerificationEmail(String userId);

  /// Sends verification SMS
  Future<void> sendVerificationSMS(String userId);

  /// Deactivates user account
  Future<void> deactivateAccount(String userId, String password);

  /// Deletes user account permanently
  Future<void> deleteAccount(String userId, String password);
}