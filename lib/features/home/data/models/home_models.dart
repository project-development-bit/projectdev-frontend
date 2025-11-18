import 'package:flutter/foundation.dart';

/// Represents an offer wall/partner network
@immutable
class OfferWallModel {
  const OfferWallModel({
    required this.id,
    required this.name,
    required this.code,
    required this.offerCount,
    required this.averagePayout,
    required this.rating,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String code;
  final int offerCount;
  final double averagePayout;
  final double rating;
  final String logoUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferWallModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          offerCount == other.offerCount &&
          averagePayout == other.averagePayout &&
          rating == other.rating &&
          logoUrl == other.logoUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      offerCount.hashCode ^
      averagePayout.hashCode ^
      rating.hashCode ^
      logoUrl.hashCode;

  @override
  String toString() {
    return 'OfferWallModel{id: $id, name: $name, offerCount: $offerCount, rating: $rating}';
  }
}

/// Represents user testimonial
@immutable
class TestimonialModel {
  const TestimonialModel({
    required this.id,
    required this.username,
    required this.level,
    required this.badge,
    required this.message,
    required this.timeAgo,
    required this.earning,
  });

  final String id;
  final String username;
  final int level;
  final String badge;
  final String message;
  final String timeAgo;
  final double earning;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestimonialModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          level == other.level &&
          badge == other.badge &&
          message == other.message &&
          timeAgo == other.timeAgo &&
          earning == other.earning;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      level.hashCode ^
      badge.hashCode ^
      message.hashCode ^
      timeAgo.hashCode ^
      earning.hashCode;

  @override
  String toString() {
    return 'TestimonialModel{id: $id, username: $username, earning: $earning}';
  }
}

/// Represents platform statistics
@immutable
class PlatformStatsModel {
  const PlatformStatsModel({
    required this.fastestPayoutTime,
    required this.averageEarnings,
    required this.countriesCount,
    required this.totalUsers,
  });

  final String fastestPayoutTime;
  final double averageEarnings;
  final int countriesCount;
  final int totalUsers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformStatsModel &&
          runtimeType == other.runtimeType &&
          fastestPayoutTime == other.fastestPayoutTime &&
          averageEarnings == other.averageEarnings &&
          countriesCount == other.countriesCount &&
          totalUsers == other.totalUsers;

  @override
  int get hashCode =>
      fastestPayoutTime.hashCode ^
      averageEarnings.hashCode ^
      countriesCount.hashCode ^
      totalUsers.hashCode;

  @override
  String toString() {
    return 'PlatformStatsModel{fastestPayout: $fastestPayoutTime, avgEarnings: $averageEarnings}';
  }
}
