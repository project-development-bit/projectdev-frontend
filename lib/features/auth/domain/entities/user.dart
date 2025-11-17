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
    required this.showOnboarding,
    this.country,
    this.language,
    this.referralCode,
    required this.securityCode,
    this.referredBy,
    required this.isBanned,
    required this.isVerified,
    required this.riskScore,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
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

  // show_onboarding
  final bool showOnboarding;

  /// User's country (optional)
  final String? country;

  /// User's preferred language (optional)
  final String? language;

  /// User's referral code (optional)
  final String? referralCode;

  /// User's security code
  final String securityCode;

  /// ID of user who referred this user (optional)
  final int? referredBy;

  /// Whether user is banned (0 = not banned, 1 = banned)
  final int isBanned;

  /// Whether user is verified (0 = not verified, 1 = verified)
  final int isVerified;

  /// User's risk score
  final int riskScore;

  /// Last login timestamp (optional)
  final DateTime? lastLoginAt;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Helper getter to check if user is banned
  bool get isUserBanned => isBanned == 1;

  /// Helper getter to check if user is verified
  bool get isUserVerified => isVerified == 1;

  /// Create a copy of this User with updated values
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? refreshToken,
    UserRole? role,
    bool? showOnboarding,
    String? country,
    String? language,
    String? referralCode,
    String? securityCode,
    int? referredBy,
    int? isBanned,
    int? isVerified,
    int? riskScore,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      country: country ?? this.country,
      language: language ?? this.language,
      referralCode: referralCode ?? this.referralCode,
      securityCode: securityCode ?? this.securityCode,
      referredBy: referredBy ?? this.referredBy,
      isBanned: isBanned ?? this.isBanned,
      isVerified: isVerified ?? this.isVerified,
      riskScore: riskScore ?? this.riskScore,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        refreshToken,
        role,
        country,
        language,
        referralCode,
        securityCode,
        referredBy,
        isBanned,
        isVerified,
        riskScore,
        lastLoginAt,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, role: $role, isVerified: $isUserVerified, isBanned: $isUserBanned)';
}
