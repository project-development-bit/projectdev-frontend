import 'package:cointiply_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_profile_stats_model.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_state_notifier.dart';

/// Test data factory for creating user profile test objects
class ProfileTestData {
  /// Creates a test user profile with default values
  static UserProfile createTestProfile({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? profilePictureUrl,
    UserProfileStats? stats,
  }) {
    return UserProfile(
      id: id ?? 'test-user-123',
      email: email ?? 'test@example.com',
      username: username ?? 'testuser',
      displayName: displayName ?? 'Test User',
      profilePictureUrl: profilePictureUrl,
      bio: 'Test bio for user',
      location: 'Test City',
      website: 'https://test.com',
      contactNumber: '+1234567890',
      dateOfBirth: DateTime(1990, 1, 1),
      gender: 'Other',
      accountCreated: DateTime(2022, 1, 1),
      lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
      accountStatus: AccountStatus.active,
      verificationStatus: VerificationStatus.verified,
      isEmailVerified: true,
      isPhoneVerified: true,
      stats: stats ?? createTestStats(),
    );
  }

  /// Creates test user profile stats
  static UserProfileStats createTestStats({
    double? totalEarnings,
    int? completedOffers,
    int? currentLevel,
    int? experiencePoints,
    int? referralsCount,
    int? achievementsCount,
  }) {
    return UserProfileStatsModel(
      totalEarnings: totalEarnings ?? 1247.85,
      completedOffers: completedOffers ?? 156,
      currentLevel: currentLevel ?? 5,
      experiencePoints: experiencePoints ?? 12450,
      referralsCount: referralsCount ?? 12,
      achievementsCount: achievementsCount ?? 8,
      badgesEarned: 15,
      streakDays: 7,
      totalLogins: 234,
      memberSince: DateTime(2022, 3, 10),
    );
  }

  /// Creates test profile state for different scenarios
  static ProfileState createLoadingState() {
    return ProfileState(
      profile: null,
      isLoading: true,
      error: null,
    );
  }

  static ProfileState createErrorState([String? error]) {
    return ProfileState(
      profile: null,
      isLoading: false,
      error: error ?? 'Test error message',
    );
  }

  static ProfileState createSuccessState([UserProfile? profile]) {
    return ProfileState(
      profile: profile ?? createTestProfile(),
      isLoading: false,
      error: null,
    );
  }

  static ProfileState createEmptyState() {
    return ProfileState(
      profile: null,
      isLoading: false,
      error: null,
    );
  }

  /// Creates a new user profile with minimal data
  static UserProfile createNewUserProfile() {
    return createTestProfile(
      id: 'new-user-123',
      email: 'newuser@example.com',
      username: 'newuser',
      displayName: 'New User',
      profilePictureUrl: null,
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
  }

  /// Creates a premium user profile with high stats
  static UserProfile createPremiumUserProfile() {
    return createTestProfile(
      id: 'premium-user-123',
      email: 'premium@example.com',
      username: 'premiumuser',
      displayName: 'Premium User',
      profilePictureUrl: 'https://example.com/premium-avatar.jpg',
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
  }
}
