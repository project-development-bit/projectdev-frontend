// import 'package:equatable/equatable.dart';

// /// User Profile Entity
// ///
// /// Represents the user's profile information in the domain layer.
// /// This is a pure Dart class with no dependencies on external packages
// /// except for Equatable for value equality comparison.
// class UserProfile extends Equatable {
//   const UserProfile({
//     required this.id,
//     required this.email,
//     required this.username,
//     this.displayName,
//     this.profilePictureUrl,
//     this.bio,
//     this.location,
//     this.website,
//     this.contactNumber,
//     this.dateOfBirth,
//     this.gender,
//     required this.accountCreated,
//     this.lastLogin,
//     required this.accountStatus,
//     required this.verificationStatus,
//     required this.isEmailVerified,
//     required this.isPhoneVerified,
//     this.stats,
//   });

//   /// Unique identifier for the user
//   final String id;

//   /// User's email address
//   final String email;

//   /// Unique username
//   final String username;

//   /// Display name (can be different from username)
//   final String? displayName;

//   /// URL to the user's profile picture
//   final String? profilePictureUrl;

//   /// User's bio/description
//   final String? bio;

//   /// User's location
//   final String? location;

//   /// User's website URL
//   final String? website;

//   /// User's contact number
//   final String? contactNumber;

//   /// User's date of birth
//   final DateTime? dateOfBirth;

//   /// User's gender
//   final String? gender;

//   /// When the account was created
//   final DateTime accountCreated;

//   /// Last login timestamp
//   final DateTime? lastLogin;

//   /// Current account status
//   final AccountStatus accountStatus;

//   /// Current verification status
//   final VerificationStatus verificationStatus;

//   /// Whether email is verified
//   final bool isEmailVerified;

//   /// Whether phone number is verified
//   final bool isPhoneVerified;

//   /// User's profile statistics
//   final UserProfileStats? stats;

//   /// Creates a copy of this UserProfile with updated values
//   UserProfile copyWith({
//     String? id,
//     String? email,
//     String? username,
//     String? displayName,
//     String? profilePictureUrl,
//     String? bio,
//     String? location,
//     String? website,
//     String? contactNumber,
//     DateTime? dateOfBirth,
//     String? gender,
//     DateTime? accountCreated,
//     DateTime? lastLogin,
//     AccountStatus? accountStatus,
//     VerificationStatus? verificationStatus,
//     bool? isEmailVerified,
//     bool? isPhoneVerified,
//     UserProfileStats? stats,
//   }) {
//     return UserProfile(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       username: username ?? this.username,
//       displayName: displayName ?? this.displayName,
//       profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
//       bio: bio ?? this.bio,
//       location: location ?? this.location,
//       website: website ?? this.website,
//       contactNumber: contactNumber ?? this.contactNumber,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       gender: gender ?? this.gender,
//       accountCreated: accountCreated ?? this.accountCreated,
//       lastLogin: lastLogin ?? this.lastLogin,
//       accountStatus: accountStatus ?? this.accountStatus,
//       verificationStatus: verificationStatus ?? this.verificationStatus,
//       isEmailVerified: isEmailVerified ?? this.isEmailVerified,
//       isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
//       stats: stats ?? this.stats,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         email,
//         username,
//         displayName,
//         profilePictureUrl,
//         bio,
//         location,
//         website,
//         contactNumber,
//         dateOfBirth,
//         gender,
//         accountCreated,
//         lastLogin,
//         accountStatus,
//         verificationStatus,
//         isEmailVerified,
//         isPhoneVerified,
//         stats,
//       ];
// }

// /// Account status enumeration
// enum AccountStatus {
//   active,
//   inactive,
//   suspended,
//   banned,
// }

// /// Verification status enumeration
// enum VerificationStatus {
//   verified,
//   unverified,
//   pendingVerification,
//   rejected,
// }

// /// User profile statistics
// class UserProfileStats extends Equatable {
//   const UserProfileStats({
//     required this.totalEarnings,
//     required this.completedOffers,
//     required this.currentLevel,
//     required this.experiencePoints,
//     required this.referralsCount,
//     required this.achievementsCount,
//     required this.badgesEarned,
//     required this.streakDays,
//     required this.totalLogins,
//     required this.memberSince,
//   });

//   /// Total earnings in the platform's currency
//   final double totalEarnings;

//   /// Number of completed offers
//   final int completedOffers;

//   /// User's current level
//   final int currentLevel;

//   /// Total experience points
//   final int experiencePoints;

//   /// Number of successful referrals
//   final int referralsCount;

//   /// Number of achievements unlocked
//   final int achievementsCount;

//   /// Number of badges earned
//   final int badgesEarned;

//   /// Current login streak in days
//   final int streakDays;

//   /// Total number of logins
//   final int totalLogins;

//   /// Date when user became a member
//   final DateTime memberSince;

//   UserProfileStats copyWith({
//     double? totalEarnings,
//     int? completedOffers,
//     int? currentLevel,
//     int? experiencePoints,
//     int? referralsCount,
//     int? achievementsCount,
//     int? badgesEarned,
//     int? streakDays,
//     int? totalLogins,
//     DateTime? memberSince,
//   }) {
//     return UserProfileStats(
//       totalEarnings: totalEarnings ?? this.totalEarnings,
//       completedOffers: completedOffers ?? this.completedOffers,
//       currentLevel: currentLevel ?? this.currentLevel,
//       experiencePoints: experiencePoints ?? this.experiencePoints,
//       referralsCount: referralsCount ?? this.referralsCount,
//       achievementsCount: achievementsCount ?? this.achievementsCount,
//       badgesEarned: badgesEarned ?? this.badgesEarned,
//       streakDays: streakDays ?? this.streakDays,
//       totalLogins: totalLogins ?? this.totalLogins,
//       memberSince: memberSince ?? this.memberSince,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         totalEarnings,
//         completedOffers,
//         currentLevel,
//         experiencePoints,
//         referralsCount,
//         achievementsCount,
//         badgesEarned,
//         streakDays,
//         totalLogins,
//         memberSince,
//       ];
// }
