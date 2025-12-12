import 'package:cointiply_app/features/user_profile/data/enum/user_level.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enum/user_role.dart';

/// User entity for authentication
///
/// Represents the authenticated user's complete information from whoami API
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.refreshToken,
    required this.role,
    required this.securityCode,
    required this.twofaEnabled,
    required this.twofaSecret,
    required this.securityPinEnabled,
    required this.isBanned,
    required this.isVerified,
    required this.avatarUrl,
    required this.interestEnable,
    required this.riskScore,
    required this.showOnboarding,
    required this.notificationsEnabled,
    required this.showStatsEnabled,
    required this.anonymousInContests,
    required this.createdAt,
    required this.updatedAt,
    required this.currentStatus,
    required this.countryID,
    required this.countryName,
    required this.coinBalance,
  });

  /// Unique user identifier
  final int id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// Refresh token for authentication
  final String refreshToken;

  /// User's role in the system
  final UserRole role;

  /// User's security code
  final String securityCode;

  /// Whether 2FA is enabled (0 = disabled, 1 = enabled)
  final int twofaEnabled;

  /// User's 2FA secret key
  final String twofaSecret;

  /// Whether security PIN is enabled (0 = disabled, 1 = enabled)
  final int securityPinEnabled;

  /// Whether user is banned (0 = not banned, 1 = banned)
  final int isBanned;

  /// Whether user is verified (0 = not verified, 1 = verified)
  final int isVerified;

  /// User's avatar URL
  final String avatarUrl;

  /// Whether interest is enabled (0 = disabled, 1 = enabled)
  final int interestEnable;

  /// User's risk score
  final int riskScore;

  /// Whether to show onboarding (0 = hide, 1 = show)
  final int showOnboarding;

  /// Whether notifications are enabled (0 = disabled, 1 = enabled)
  final int notificationsEnabled;

  /// Whether to show stats (0 = hide, 1 = show)
  final int showStatsEnabled;

  /// Whether user is anonymous in contests (0 = not anonymous, 1 = anonymous)
  final int anonymousInContests;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Current user level
  final UserLevel currentStatus;

  /// Country ID
  final int countryID;

  /// Country Name
  final String countryName;

  final double coinBalance;

  /// Helper getter to check if user is banned
  bool get isUserBanned => isBanned == 1;

  /// Helper getter to check if user is verified
  bool get isUserVerified => isVerified == 1;

  /// Helper getter to check if 2FA is enabled
  bool get is2FAEnabled => twofaEnabled == 1;

  /// Helper getter to check if security PIN is enabled
  bool get isSecurityPinEnabled => securityPinEnabled == 1;

  /// Helper getter to check if interest is enabled
  bool get isInterestEnabled => interestEnable == 1;

  /// Helper getter to check if onboarding should be shown
  bool get shouldShowOnboarding => showOnboarding == 1;

  /// Helper getter to check if notifications are enabled
  bool get areNotificationsEnabled => notificationsEnabled == 1;

  /// Helper getter to check if stats should be shown
  bool get shouldShowStats => showStatsEnabled == 1;

  /// Helper getter to check if user is anonymous in contests
  bool get isAnonymousInContests => anonymousInContests == 1;

  /// Create a copy of this User with updated values
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? refreshToken,
    UserRole? role,
    String? securityCode,
    int? twofaEnabled,
    String? twofaSecret,
    int? securityPinEnabled,
    int? isBanned,
    int? isVerified,
    String? avatarUrl,
    int? interestEnable,
    int? riskScore,
    int? showOnboarding,
    int? notificationsEnabled,
    int? showStatsEnabled,
    int? anonymousInContests,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserLevel? currentStatus,
    int? countryID,
    String? countryName,
    double? coinBalance,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      securityCode: securityCode ?? this.securityCode,
      twofaEnabled: twofaEnabled ?? this.twofaEnabled,
      twofaSecret: twofaSecret ?? this.twofaSecret,
      securityPinEnabled: securityPinEnabled ?? this.securityPinEnabled,
      isBanned: isBanned ?? this.isBanned,
      isVerified: isVerified ?? this.isVerified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interestEnable: interestEnable ?? this.interestEnable,
      riskScore: riskScore ?? this.riskScore,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showStatsEnabled: showStatsEnabled ?? this.showStatsEnabled,
      anonymousInContests: anonymousInContests ?? this.anonymousInContests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentStatus: currentStatus ?? this.currentStatus,
      countryID: countryID ?? this.countryID,
      countryName: countryName ?? this.countryName,
      coinBalance: coinBalance ?? this.coinBalance,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        refreshToken,
        role,
        securityCode,
        twofaEnabled,
        twofaSecret,
        securityPinEnabled,
        isBanned,
        isVerified,
        avatarUrl,
        interestEnable,
        riskScore,
        showOnboarding,
        notificationsEnabled,
        showStatsEnabled,
        anonymousInContests,
        createdAt,
        updatedAt,
        currentStatus,
        countryID,
        countryName,
        coinBalance,
      ];

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, role: $role, isVerified: $isUserVerified, isBanned: $isUserBanned)';
}
