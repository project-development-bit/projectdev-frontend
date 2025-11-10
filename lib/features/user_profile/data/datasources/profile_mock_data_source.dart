import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import '../../domain/entities/user_profile.dart';
import '../models/response/user_profile_model.dart';
import '../models/response/user_profile_stats_model.dart';
import 'profile_remote_data_source.dart';

/// Mock implementation of [ProfileRemoteDataSource] for development and testing
///
/// This class provides realistic mock data that simulates the Cointiply.com profile
/// structure, including user information, statistics, and verification status.
class ProfileMockDataSource implements ProfileRemoteDataSource {
  /// Mock delay to simulate network requests
  static const Duration _mockDelay = Duration(milliseconds: 800);

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    await Future.delayed(_mockDelay);

    // Return comprehensive mock profile data similar to Cointiply
    return UserProfileModel(
      id: userId,
      email: 'john.doe@example.com',
      username: 'johndoe2024',
      displayName: 'John Doe',
      profilePictureUrl: 'https://i.pravatar.cc/150?img=3',
      bio:
          'Crypto enthusiast and digital nomad. Earning Bitcoin through various platforms since 2020. Love exploring new opportunities in the crypto space! 🚀',
      location: 'San Francisco, CA',
      website: 'https://johndoe.dev',
      contactNumber: '+1 (555) 123-4567',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: 'Male',
      accountCreated: DateTime(2022, 3, 10),
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      accountStatus: AccountStatus.active,
      verificationStatus: VerificationStatus.verified,
      isEmailVerified: true,
      isPhoneVerified: true,
      stats: UserProfileStatsModel(
        totalEarnings: 1247.85,
        completedOffers: 156,
        currentLevel: 5,
        experiencePoints: 12450,
        referralsCount: 12,
        achievementsCount: 8,
        badgesEarned: 15,
        streakDays: 7,
        totalLogins: 234,
        memberSince: DateTime(2022, 3, 10),
      ),
    );
  }

  @override
  Future<UserUpdateResponse> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    await Future.delayed(_mockDelay);

    // Simulate updating the profile with new data
    await getUserProfile(userId);

    return UserUpdateResponse(
      success: true,
      message: 'Profile updated successfully',
    );
  }

  @override
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    await Future.delayed(_mockDelay);

    // Simulate uploading and return a mock URL
    const mockImageUrls = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=2',
      'https://i.pravatar.cc/150?img=3',
      'https://i.pravatar.cc/150?img=4',
      'https://i.pravatar.cc/150?img=5',
    ];

    // Return a random mock image URL
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % mockImageUrls.length;
    return mockImageUrls[randomIndex];
  }

  @override
  Future<void> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    await Future.delayed(_mockDelay);

    // Simulate password validation
    if (currentPassword != 'currentPassword123') {
      throw Exception('Current password is incorrect');
    }

    if (newPassword.length < 8) {
      throw Exception('New password must be at least 8 characters long');
    }

    // Simulate successful password update
  }

  @override
  Future<void> updateEmail(String userId, String newEmail) async {
    await Future.delayed(_mockDelay);

    // Simulate email validation
    if (!newEmail.contains('@') || !newEmail.contains('.')) {
      throw Exception('Invalid email format');
    }

    // Simulate successful email update (will require verification)
  }

  @override
  Future<void> verifyEmail(String userId, String verificationCode) async {
    await Future.delayed(_mockDelay);

    // Simulate verification code validation
    if (verificationCode != '123456') {
      throw Exception('Invalid verification code');
    }

    // Simulate successful email verification
  }

  @override
  Future<void> verifyPhone(String userId, String verificationCode) async {
    await Future.delayed(_mockDelay);

    // Simulate verification code validation
    if (verificationCode != '654321') {
      throw Exception('Invalid verification code');
    }

    // Simulate successful phone verification
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    await Future.delayed(_mockDelay);

    // Simulate sending verification email
    debugPrint('Mock: Verification email sent to user $userId');
  }

  @override
  Future<void> sendVerificationSMS(String userId) async {
    await Future.delayed(_mockDelay);

    // Simulate sending verification SMS
    debugPrint('Mock: Verification SMS sent to user $userId');
  }

  @override
  Future<void> deactivateAccount(String userId, String password) async {
    await Future.delayed(_mockDelay);

    // Simulate password validation
    if (password != 'userPassword123') {
      throw Exception('Incorrect password');
    }

    // Simulate successful account deactivation
    debugPrint('Mock: Account $userId deactivated successfully');
  }

  @override
  Future<void> deleteAccount(String userId, String password) async {
    await Future.delayed(_mockDelay);

    // Simulate password validation
    if (password != 'userPassword123') {
      throw Exception('Incorrect password');
    }

    // Simulate successful account deletion
    debugPrint('Mock: Account $userId deleted permanently');
  }
}

/// Additional mock data for different user scenarios
class ProfileMockDataProvider {
  /// Mock data for a new user with minimal information
  static UserProfileModel get newUserProfile => UserProfileModel(
        id: '2',
        email: 'newuser@example.com',
        username: 'newuser2024',
        displayName: 'New User',
        profilePictureUrl: null,
        bio: null,
        location: null,
        website: null,
        contactNumber: null,
        dateOfBirth: null,
        gender: null,
        accountCreated: DateTime.now().subtract(const Duration(days: 1)),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
        accountStatus: AccountStatus.active,
        verificationStatus: VerificationStatus.unverified,
        isEmailVerified: false,
        isPhoneVerified: false,
        stats: UserProfileStatsModel(
          totalEarnings: 0.0,
          completedOffers: 0,
          currentLevel: 1,
          experiencePoints: 0,
          referralsCount: 0,
          achievementsCount: 0,
          badgesEarned: 0,
          streakDays: 0,
          totalLogins: 5,
          memberSince: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

  /// Mock data for a premium user with high earnings
  static UserProfileModel get premiumUserProfile => UserProfileModel(
        id: '3',
        email: 'premium.user@example.com',
        username: 'cryptomaster',
        displayName: 'Crypto Master',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=8',
        bio:
            '🎯 Top earner | 💎 Diamond member | 🚀 2M+ satoshis earned | 🏆 Community leader',
        location: 'London, UK',
        website: 'https://cryptomaster.pro',
        contactNumber: '+44 20 7123 4567',
        dateOfBirth: DateTime(1985, 12, 8),
        gender: 'Male',
        accountCreated: DateTime(2018, 6, 15),
        lastLogin: DateTime.now().subtract(const Duration(minutes: 5)),
        accountStatus: AccountStatus.active,
        verificationStatus: VerificationStatus.verified,
        isEmailVerified: true,
        isPhoneVerified: true,
        stats: UserProfileStatsModel(
          totalEarnings: 15847.92,
          completedOffers: 2847,
          currentLevel: 15,
          experiencePoints: 58920,
          referralsCount: 45,
          achievementsCount: 27,
          badgesEarned: 35,
          streakDays: 45,
          totalLogins: 1890,
          memberSince: DateTime(2018, 6, 15),
        ),
      );

  /// Mock data for a user with some issues
  static UserProfileModel get problematicUserProfile => UserProfileModel(
        id: '4',
        email: 'problem.user@example.com',
        username: 'problemuser',
        displayName: 'Problem User',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=6',
        bio: 'Having some account issues, please help!',
        location: 'Toronto, Canada',
        website: null,
        contactNumber: '+1 (416) 555-0123',
        dateOfBirth: DateTime(1992, 8, 22),
        gender: 'Female',
        accountCreated: DateTime(2023, 1, 20),
        lastLogin: DateTime.now().subtract(const Duration(days: 3)),
        accountStatus: AccountStatus.suspended,
        verificationStatus: VerificationStatus.pendingVerification,
        isEmailVerified: true,
        isPhoneVerified: false,
        stats: UserProfileStatsModel(
          totalEarnings: 89.45,
          completedOffers: 23,
          currentLevel: 2,
          experiencePoints: 245,
          referralsCount: 2,
          achievementsCount: 2,
          badgesEarned: 3,
          streakDays: 0,
          totalLogins: 67,
          memberSince: DateTime(2023, 1, 20),
        ),
      );
}
