import 'package:equatable/equatable.dart';

/// Request model for updating user information
class UserUpdateRequest extends Equatable {
  final String id;
  final String? name;
  final String? password;
  final String? confirmPassword;
  final String? email;
  final String? role;
  final String? country;
  final int? countryId;
  final String? language;
  final String? profilePictureUrl;
  final int? showOnboarding;
  final bool? notificationsEnabled;
  final bool? showStatsEnabled;
  final bool? anonymousInContests;
  final bool? securityPinEnabled;
  final bool? interestEnable;

  const UserUpdateRequest({
    required this.id,
    this.name,
    this.password,
    this.confirmPassword,
    this.email,
    this.role,
    this.country,
    this.countryId,
    this.language,
    this.profilePictureUrl,
    this.showOnboarding,
    this.notificationsEnabled,
    this.showStatsEnabled,
    this.anonymousInContests,
    this.securityPinEnabled,
    this.interestEnable,
  });

  /// Convert JSON → Model
  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequest(
        id: json['id'] as String,
        name: json['name'] as String?,
        password: json['password'] as String?,
        confirmPassword: json['confirm_password'] as String?,
        showOnboarding: json['show_onboarding'] as int?,
        email: json['email'] as String?,
        role: json['role'] as String?,
        country: json['country'] as String?,
        countryId: json['country_id'] as int?,
        language: json['language'] as String?,
        profilePictureUrl: json['profile_picture_url'] as String?,
        notificationsEnabled: json['notifications_enabled'] as bool?,
        showStatsEnabled: json['show_stats_enabled'] as bool?,
        anonymousInContests: json['anonymous_in_contests'] as bool?,
        securityPinEnabled: json['security_pin_enabled'] as bool?,
        interestEnable: json['interest_enable'] as bool?);
  }

  /// Convert Model → JSON (for API request)
  Map<String, dynamic> toJson() => {
        if (name != null) "name": name,
        if (password != null) "password": password,
        if (confirmPassword != null) "confirm_password": confirmPassword,
        if (email != null) "email": email,
        if (role != null) "role": role,
        if (showOnboarding != null) "show_onboarding": showOnboarding,
        if (country != null) "country": country,
        if (countryId != null) "country_id": countryId,
        if (language != null) "language": language,
        if (notificationsEnabled != null)
          "notifications_enabled": (notificationsEnabled ?? false) ? 1 : 0,
        if (showStatsEnabled != null)
          "show_stats_enabled": (showStatsEnabled ?? false) ? 1 : 0,
        if (anonymousInContests != null)
          "anonymous_in_contests": (anonymousInContests ?? false) ? 1 : 0,
        if (securityPinEnabled != null)
          "security_pin_enabled": securityPinEnabled,
        if (interestEnable != null) "interest_enable": interestEnable,
      };

  /// Create a copy with modified fields
  UserUpdateRequest copyWith({
    String? id,
    String? name,
    String? password,
    String? confirmPassword,
    String? email,
    String? role,
    int? showOnboarding,
    String? country,
    int? countryId,
    String? language,
    bool? notificationsEnabled,
    bool? showStatsEnabled,
    bool? anonymousInContests,
    bool? securityPinEnabled,
    bool? interestEnable,
  }) {
    return UserUpdateRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      role: role ?? this.role,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      country: country ?? this.country,
      countryId: countryId ?? this.countryId,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showStatsEnabled: showStatsEnabled ?? this.showStatsEnabled,
      anonymousInContests: anonymousInContests ?? this.anonymousInContests,
      securityPinEnabled: securityPinEnabled ?? this.securityPinEnabled,
      interestEnable: interestEnable ?? this.interestEnable,
    );
  }

  @override
  List<Object?> get props => [
        name,
        password,
        confirmPassword,
        email,
        role,
        showOnboarding,
        country,
        countryId,
        language,
        notificationsEnabled,
        showStatsEnabled,
        anonymousInContests,
        securityPinEnabled,
        interestEnable,
      ];
}
