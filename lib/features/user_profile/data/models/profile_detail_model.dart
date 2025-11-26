import 'package:cointiply_app/features/user_profile/data/models/country_model.dart';

import '../../domain/entities/profile_detail.dart';

/// Profile Detail Model for data layer
///
/// Extends the ProfileDetail entity with JSON serialization capabilities
class ProfileDetailModel extends ProfileDetail {
  const ProfileDetailModel({
    required super.account,
    required super.security,
    required super.settings,
  });

  /// Create ProfileDetailModel from JSON response
  factory ProfileDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ProfileDetailModel(
      account: AccountInfoModel.fromJson(data['account'] as Map<String, dynamic>),
      security: SecuritySettingsModel.fromJson(data['security'] as Map<String, dynamic>),
      settings: UserSettingsModel.fromJson(data['settings'] as Map<String, dynamic>),
    );
  }

  /// Convert to entity
  ProfileDetail toEntity() {
    return ProfileDetail(
      account: account,
      security: security,
      settings: settings,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'account': (account as AccountInfoModel).toJson(),
        'security': (security as SecuritySettingsModel).toJson(),
        'settings': (settings as UserSettingsModel).toJson(),
      },
    };
  }
}

/// Account Information Model
class AccountInfoModel extends AccountInfo {
  const AccountInfoModel({
    required super.username,
    required super.email,
    required super.avatarUrl,
    super.country,
    super.offerToken,
    required super.createdAt,
  });

  /// Create AccountInfoModel from JSON
  factory AccountInfoModel.fromJson(Map<String, dynamic> json) {
    return AccountInfoModel(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      country: CountryModel.fromJson(json['country']),
      offerToken: json['offer_token'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'country': country,
      'offer_token': offerToken,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Security Settings Model
class SecuritySettingsModel extends SecuritySettings {
  const SecuritySettingsModel({
    required super.twofaEnabled,
    required super.securityPinEnabled,
  });

  /// Create SecuritySettingsModel from JSON
  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return SecuritySettingsModel(
      twofaEnabled: _parseBool(json['twofa_enabled']),
      securityPinEnabled: _parseBool(json['security_pin_enabled']),
    );
  }

  /// Helper method to parse boolean values
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'twofa_enabled': twofaEnabled,
      'security_pin_enabled': securityPinEnabled,
    };
  }
}

/// User Settings Model
class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.language,
    required super.notificationsEnabled,
    required super.showStatsEnabled,
    required super.anonymousInContests,
  });

  /// Create UserSettingsModel from JSON
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: _parseBool(json['notifications_enabled']),
      showStatsEnabled: _parseBool(json['show_stats_enabled']),
      anonymousInContests: _parseBool(json['anonymous_in_contests']),
    );
  }

  /// Helper method to parse boolean values
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'show_stats_enabled': showStatsEnabled,
      'anonymous_in_contests': anonymousInContests,
    };
  }
}
