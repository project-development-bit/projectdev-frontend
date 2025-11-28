import '../../domain/entities/language.dart';

/// Language Model for data layer
///
/// Extends the Language entity with JSON serialization capabilities
class LanguageModel extends Language {
  const LanguageModel({
    required super.code,
    required super.name,
    required super.flag,
    required super.isDefault,
  });

  /// Create LanguageModel from JSON response
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      isDefault: json['default'] as bool? ?? false,
    );
  }

  /// Convert to entity
  Language toEntity() {
    return Language(
      code: code,
      name: name,
      flag: flag,
      isDefault: isDefault,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'flag': flag,
      'default': isDefault,
    };
  }
}
