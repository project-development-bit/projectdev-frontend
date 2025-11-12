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
    required super.showOnboarding,
    super.country,
    super.language,
    super.referralCode,
    required super.securityCode,
    super.referredBy,
    required super.isBanned,
    required super.isVerified,
    required super.riskScore,
    super.lastLoginAt,
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
      //show_onboarding is 1 and 0 in the API response
      showOnboarding: _parseBool(json['show_onboarding']) == 0,
      country: json['country'] as String?,
      language: json['language'] as String?,
      referralCode: json['referral_code'] as String?,
      securityCode: json['security_code'] as String? ?? '',
      referredBy: json['referred_by'] as int?,
      isBanned: _parseBool(json['is_banned']),
      isVerified: _parseBool(json['is_verified']),
      riskScore: _parseInt(json['risk_score']),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String? ?? '')
          : null,
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
      'country': country,
      'language': language,
      'referral_code': referralCode,
      'security_code': securityCode,
      'referred_by': referredBy,
      'is_banned': isBanned,
      'is_verified': isVerified,
      'risk_score': riskScore,
      'last_login_at': lastLoginAt?.toIso8601String(),
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
      showOnboarding: user.showOnboarding,
      country: user.country,
      language: user.language,
      referralCode: user.referralCode,
      securityCode: user.securityCode,
      referredBy: user.referredBy,
      isBanned: user.isBanned,
      isVerified: user.isVerified,
      riskScore: user.riskScore,
      lastLoginAt: user.lastLoginAt,
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
      showOnboarding: _parseBool(json['show_onboarding']) == 1,
      country: json['country'] as String?,
      language: json['language'] as String?,
      referralCode: json['referral_code'] as String?,
      securityCode: json['security_code'] as String? ?? '',
      referredBy: json['referred_by'] as int?,
      isBanned: json['is_banned'] as int? ?? 0,
      isVerified: json['is_verified'] as int? ?? 0,
      riskScore: json['risk_score'] as int? ?? 0,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
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
      showOnboarding: showOnboarding,
      country: country,
      language: language,
      referralCode: referralCode,
      securityCode: securityCode,
      referredBy: referredBy,
      isBanned: isBanned,
      isVerified: isVerified,
      riskScore: riskScore,
      lastLoginAt: lastLoginAt,
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
    return UserModel(
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
}
