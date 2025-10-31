import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/terms_privacy_entity.dart';

part 'terms_privacy_model.g.dart';

@JsonSerializable()
class TermsPrivacyModel {
  final TermsModel terms;
  final PrivacyModel privacy;

  const TermsPrivacyModel({
    required this.terms,
    required this.privacy,
  });

  factory TermsPrivacyModel.fromJson(Map<String, dynamic> json) =>
      _$TermsPrivacyModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermsPrivacyModelToJson(this);

  /// Convert model to entity
  TermsPrivacyEntity toEntity() {
    return TermsPrivacyEntity(
      termsUrl: terms.url,
      termsVersion: terms.version,
      privacyUrl: privacy.url,
      privacyVersion: privacy.version,
    );
  }
}

@JsonSerializable()
class TermsModel {
  final String version;
  final String url;

  const TermsModel({
    required this.version,
    required this.url,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) =>
      _$TermsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermsModelToJson(this);
}

@JsonSerializable()
class PrivacyModel {
  final String version;
  final String url;

  const PrivacyModel({
    required this.version,
    required this.url,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyModelToJson(this);
}