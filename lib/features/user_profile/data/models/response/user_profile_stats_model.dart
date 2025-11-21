// import 'package:json_annotation/json_annotation.dart';
// import '../../../domain/entities/user_profile.dart';

// part 'user_profile_stats_model.g.dart';

// /// Data model for User Profile Statistics
// ///
// /// This model extends the domain entity and adds JSON serialization
// /// capabilities for API communication and local storage.
// @JsonSerializable()
// class UserProfileStatsModel extends UserProfileStats {
//   const UserProfileStatsModel({
//     required super.totalEarnings,
//     required super.completedOffers,
//     required super.currentLevel,
//     required super.experiencePoints,
//     required super.referralsCount,
//     required super.achievementsCount,
//     required super.badgesEarned,
//     required super.streakDays,
//     required super.totalLogins,
//     required super.memberSince,
//   });

//   /// Creates a [UserProfileStatsModel] from JSON
//   factory UserProfileStatsModel.fromJson(Map<String, dynamic> json) =>
//       _$UserProfileStatsModelFromJson(json);

//   /// Converts this [UserProfileStatsModel] to JSON
//   Map<String, dynamic> toJson() => _$UserProfileStatsModelToJson(this);

//   /// Creates a [UserProfileStatsModel] from domain entity
//   factory UserProfileStatsModel.fromEntity(UserProfileStats entity) {
//     return UserProfileStatsModel(
//       totalEarnings: entity.totalEarnings,
//       completedOffers: entity.completedOffers,
//       currentLevel: entity.currentLevel,
//       experiencePoints: entity.experiencePoints,
//       referralsCount: entity.referralsCount,
//       achievementsCount: entity.achievementsCount,
//       badgesEarned: entity.badgesEarned,
//       streakDays: entity.streakDays,
//       totalLogins: entity.totalLogins,
//       memberSince: entity.memberSince,
//     );
//   }

//   /// Converts this model to domain entity
//   UserProfileStats toEntity() {
//     return UserProfileStats(
//       totalEarnings: totalEarnings,
//       completedOffers: completedOffers,
//       currentLevel: currentLevel,
//       experiencePoints: experiencePoints,
//       referralsCount: referralsCount,
//       achievementsCount: achievementsCount,
//       badgesEarned: badgesEarned,
//       streakDays: streakDays,
//       totalLogins: totalLogins,
//       memberSince: memberSince,
//     );
//   }
// }
