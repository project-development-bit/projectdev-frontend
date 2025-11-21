import 'package:equatable/equatable.dart';

/// Profile Detail Entity
///
/// Represents the complete user profile information from the profile API
class ProfileDetail extends Equatable {
  const ProfileDetail({
    required this.account,
    required this.security,
    required this.settings,
  });

  /// Account information
  final AccountInfo account;

  /// Security settings
  final SecuritySettings security;

  /// User settings/preferences
  final UserSettings settings;

  @override
  List<Object?> get props => [account, security, settings];
}

/// Account Information Entity
class AccountInfo extends Equatable {
  const AccountInfo({
    required this.username,
    required this.email,
    required this.avatarUrl,
    this.country,
    this.offerToken,
    required this.createdAt,
  });

  /// User's username
  final String username;

  /// User's email address
  final String email;

  /// URL to the user's avatar/profile picture
  final String avatarUrl;

  /// User's country (nullable)
  final String? country;

  /// Offer token (nullable)
  final String? offerToken;

  /// Account creation timestamp
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        username,
        email,
        avatarUrl,
        country,
        offerToken,
        createdAt,
      ];
}

/// Security Settings Entity
class SecuritySettings extends Equatable {
  const SecuritySettings({
    required this.twofaEnabled,
    required this.securityPinEnabled,
  });

  /// Whether 2FA is enabled
  final bool twofaEnabled;

  /// Whether security PIN is enabled
  final bool securityPinEnabled;

  @override
  List<Object> get props => [twofaEnabled, securityPinEnabled];
}

/// User Settings Entity
class UserSettings extends Equatable {
  const UserSettings({
    required this.language,
    required this.notificationsEnabled,
    required this.showStatsEnabled,
    required this.anonymousInContests,
  });

  /// User's preferred language
  final String language;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// Whether to show stats
  final bool showStatsEnabled;

  /// Whether user is anonymous in contests
  final bool anonymousInContests;

  @override
  List<Object> get props => [
        language,
        notificationsEnabled,
        showStatsEnabled,
        anonymousInContests,
      ];
}
