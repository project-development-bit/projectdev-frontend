import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../../../../core/error/failures.dart';

/// Abstract repository interface for profile operations
///
/// This interface defines the contract for profile data operations.
/// It uses the repository pattern to abstract data sources and
/// implements clean architecture principles.
abstract class ProfileRepository {
  /// Get the current user's profile
  ///
  /// Returns [UserProfile] on success or [Failure] on error
  Future<Either<Failure, UserProfile>> getUserProfile();

  /// Update the user's profile
  ///
  /// [profile] - Updated profile data
  /// Returns updated [UserProfile] on success or [Failure] on error
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);

  /// Upload a new profile picture
  ///
  /// [imagePath] - Local path to the image file
  /// Returns the new image URL on success or [Failure] on error
  Future<Either<Failure, String>> uploadProfilePicture(String imagePath);

  /// Delete the user's profile picture
  ///
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> deleteProfilePicture();

  /// Update user's password
  ///
  /// [currentPassword] - Current password for verification
  /// [newPassword] - New password to set
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user's email address
  ///
  /// [newEmail] - New email address
  /// [password] - Current password for verification
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> updateEmail({
    required String newEmail,
    required String password,
  });

  /// Verify user's email address
  ///
  /// [verificationCode] - Code sent to email for verification
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> verifyEmail(String verificationCode);

  /// Verify user's phone number
  ///
  /// [phoneNumber] - Phone number to verify
  /// [verificationCode] - Code sent via SMS for verification
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> verifyPhoneNumber({
    required String phoneNumber,
    required String verificationCode,
  });

  /// Delete user account
  ///
  /// [password] - Current password for verification
  /// Returns [Unit] on success or [Failure] on error
  Future<Either<Failure, Unit>> deleteAccount(String password);

  /// Get user's profile statistics
  ///
  /// Returns [UserProfileStats] on success or [Failure] on error
  Future<Either<Failure, UserProfileStats>> getProfileStats();
}
