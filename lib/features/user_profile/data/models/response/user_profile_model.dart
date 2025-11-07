import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/user_profile.dart';
import 'user_profile_stats_model.dart';

part 'user_profile_model.g.dart';

/// Data model for User Profile
///
/// This model extends the domain entity and adds JSON serialization
/// capabilities for API communication and local storage.
@JsonSerializable()
class UserProfileModel extends UserProfile {
  @JsonKey(fromJson: _statsFromJson, toJson: _statsToJson)
  @override
  final UserProfileStats? stats;

  const UserProfileModel({
    required super.id,
    required super.email,
    required super.username,
    super.displayName,
    super.profilePictureUrl,
    super.bio,
    super.location,
    super.website,
    super.contactNumber,
    super.dateOfBirth,
    super.gender,
    required super.accountCreated,
    super.lastLogin,
    required super.accountStatus,
    required super.verificationStatus,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    this.stats,
  }) : super(stats: stats);

  /// Creates a [UserProfileModel] from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts this [UserProfileModel] to JSON
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// Helper method to convert stats from JSON
  static UserProfileStatsModel? _statsFromJson(Map<String, dynamic>? json) {
    return json != null ? UserProfileStatsModel.fromJson(json) : null;
  }

  /// Helper method to convert stats to JSON
  static Map<String, dynamic>? _statsToJson(UserProfileStats? stats) {
    return stats != null
        ? UserProfileStatsModel.fromEntity(stats).toJson()
        : null;
  }

  /// Creates a [UserProfileModel] from a [UserProfile] entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      email: profile.email,
      username: profile.username,
      displayName: profile.displayName,
      profilePictureUrl: profile.profilePictureUrl,
      bio: profile.bio,
      location: profile.location,
      website: profile.website,
      contactNumber: profile.contactNumber,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      accountCreated: profile.accountCreated,
      lastLogin: profile.lastLogin,
      accountStatus: profile.accountStatus,
      verificationStatus: profile.verificationStatus,
      isEmailVerified: profile.isEmailVerified,
      isPhoneVerified: profile.isPhoneVerified,
      stats: profile.stats != null
          ? UserProfileStatsModel.fromEntity(profile.stats!)
          : null,
    );
  }

  /// Converts this [UserProfileModel] to a [UserProfile] entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      username: username,
      displayName: displayName,
      profilePictureUrl: profilePictureUrl,
      bio: bio,
      location: location,
      website: website,
      contactNumber: contactNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      accountCreated: accountCreated,
      lastLogin: lastLogin,
      accountStatus: accountStatus,
      verificationStatus: verificationStatus,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      stats: stats,
    );
  }
}
