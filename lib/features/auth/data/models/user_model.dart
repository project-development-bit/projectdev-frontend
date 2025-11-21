import '../../domain/entities/user.dart';
import '../../../../core/enum/user_role.dart';

/// User model for data layer
///
/// Extends the User entity with JSON serialization capabilities
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.refreshToken,
    required super.role,
    required super.securityCode,
    required super.twofaEnabled,
    required super.twofaSecret,
    required super.securityPinEnabled,
    required super.isBanned,
    required super.isVerified,
    required super.avatarUrl,
    required super.interestEnable,
    required super.riskScore,
    required super.showOnboarding,
    required super.notificationsEnabled,
    required super.showStatsEnabled,
    required super.anonymousInContests,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseId(json['id']),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      role: UserRole.tryFromString(json['role'] as String?) ??
          UserRole.normalUser,
      securityCode: json['security_code'] as String? ?? '',
      twofaEnabled: _parseBool(json['twofa_enabled']),
      twofaSecret: json['twofa_secret'] as String? ?? '',
      securityPinEnabled: _parseBool(json['security_pin_enabled']),
      isBanned: _parseBool(json['is_banned']),
      isVerified: _parseBool(json['is_verified']),
      avatarUrl: json['avatar_url'] as String? ?? '',
      interestEnable: _parseBool(json['interest_enable']),
      riskScore: _parseInt(json['risk_score']),
      showOnboarding: _parseBool(json['show_onboarding']),
      notificationsEnabled: _parseBool(json['notifications_enabled']),
      showStatsEnabled: _parseBool(json['show_stats_enabled']),
      anonymousInContests: _parseBool(json['anonymous_in_contests']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String? ?? '') ??
              DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String? ?? '') ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  /// Helper method to parse ID which might be int or string
  static int _parseId(dynamic id) {
    if (id == null) return 0;
    if (id is int) return id;
    if (id is String) {
      return int.tryParse(id) ?? 0;
    }
    return 0;
  }

  /// Helper method to parse boolean values which might be bool, int, or string
  static int _parseBool(dynamic value) {
    if (value == null) return 0;
    if (value is bool) return value ? 1 : 0;
    if (value is int) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true' || value == '1') return 1;
      if (value.toLowerCase() == 'false' || value == '0') return 0;
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// Helper method to parse integer values which might be int or string
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'refresh_token': refreshToken,
      'role': role.value,
      'security_code': securityCode,
      'twofa_enabled': twofaEnabled,
      'twofa_secret': twofaSecret,
      'security_pin_enabled': securityPinEnabled,
      'is_banned': isBanned,
      'is_verified': isVerified,
      'avatar_url': avatarUrl,
      'interest_enable': interestEnable,
      'risk_score': riskScore,
      'show_onboarding': showOnboarding,
      'notifications_enabled': notificationsEnabled,
      'show_stats_enabled': showStatsEnabled,
      'anonymous_in_contests': anonymousInContests,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      refreshToken: user.refreshToken,
      role: user.role,
      securityCode: user.securityCode,
      twofaEnabled: user.twofaEnabled,
      twofaSecret: user.twofaSecret,
      securityPinEnabled: user.securityPinEnabled,
      isBanned: user.isBanned,
      isVerified: user.isVerified,
      avatarUrl: user.avatarUrl,
      interestEnable: user.interestEnable,
      riskScore: user.riskScore,
      showOnboarding: user.showOnboarding,
      notificationsEnabled: user.notificationsEnabled,
      showStatsEnabled: user.showStatsEnabled,
      anonymousInContests: user.anonymousInContests,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Create UserModel from database JSON (SQLite) - simplified version for local storage
  factory UserModel.fromDatabaseJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      refreshToken: json['refresh_token'] as String? ?? '',
      role: UserRole.tryFromString(json['role'] as String?) ??
          UserRole.normalUser,
      securityCode: json['security_code'] as String? ?? '',
      twofaEnabled: json['twofa_enabled'] as int? ?? 0,
      twofaSecret: json['twofa_secret'] as String? ?? '',
      securityPinEnabled: json['security_pin_enabled'] as int? ?? 0,
      isBanned: json['is_banned'] as int? ?? 0,
      isVerified: json['is_verified'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String? ?? '',
      interestEnable: json['interest_enable'] as int? ?? 0,
      riskScore: json['risk_score'] as int? ?? 0,
      showOnboarding: json['show_onboarding'] as int? ?? 0,
      notificationsEnabled: json['notifications_enabled'] as int? ?? 0,
      showStatsEnabled: json['show_stats_enabled'] as int? ?? 0,
      anonymousInContests: json['anonymous_in_contests'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      refreshToken: refreshToken,
      role: role,
      securityCode: securityCode,
      twofaEnabled: twofaEnabled,
      twofaSecret: twofaSecret,
      securityPinEnabled: securityPinEnabled,
      isBanned: isBanned,
      isVerified: isVerified,
      avatarUrl: avatarUrl,
      interestEnable: interestEnable,
      riskScore: riskScore,
      showOnboarding: showOnboarding,
      notificationsEnabled: notificationsEnabled,
      showStatsEnabled: showStatsEnabled,
      anonymousInContests: anonymousInContests,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with updated values (returns UserModel)
  @override
  UserModel copyWith({
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
  }) {
    return UserModel(
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
    );
  }
}
