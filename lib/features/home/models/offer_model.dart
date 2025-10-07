import 'package:flutter/foundation.dart';

/// Represents a gaming or task offer available to users
@immutable
class OfferModel {
  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.earning,
    required this.imageUrl,
    required this.type,
    this.duration,
    this.progress,
    this.isHot = false,
    this.rating,
  });

  final String id;
  final String title;
  final String description;
  final double earning;
  final String imageUrl;
  final OfferType type;
  final String? duration;
  final double? progress;
  final bool isHot;
  final double? rating;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          earning == other.earning &&
          imageUrl == other.imageUrl &&
          type == other.type &&
          duration == other.duration &&
          progress == other.progress &&
          isHot == other.isHot &&
          rating == other.rating;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      earning.hashCode ^
      imageUrl.hashCode ^
      type.hashCode ^
      duration.hashCode ^
      progress.hashCode ^
      isHot.hashCode ^
      rating.hashCode;

  @override
  String toString() {
    return 'OfferModel{id: $id, title: $title, earning: $earning, type: $type}';
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? description,
    double? earning,
    String? imageUrl,
    OfferType? type,
    String? duration,
    double? progress,
    bool? isHot,
    double? rating,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      earning: earning ?? this.earning,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      isHot: isHot ?? this.isHot,
      rating: rating ?? this.rating,
    );
  }
}

enum OfferType {
  game,
  survey,
  crypto,
  video,
  app,
}

extension OfferTypeExtension on OfferType {
  String get displayName {
    switch (this) {
      case OfferType.game:
        return 'Game';
      case OfferType.survey:
        return 'Survey';
      case OfferType.crypto:
        return 'Crypto';
      case OfferType.video:
        return 'Video';
      case OfferType.app:
        return 'App';
    }
  }
}