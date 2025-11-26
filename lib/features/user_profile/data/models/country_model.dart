import '../../domain/entities/country.dart';

/// Country Model for data layer
///
/// Extends the Country entity with JSON serialization capabilities
class CountryModel extends Country {
  const CountryModel({
    required super.code,
    required super.name,
    required super.flag,
    required super.id,
  });

  /// Create CountryModel from JSON response
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    String flagUrl = json['flag'] as String? ?? '';
    
    // Convert flagsapi.com URLs to CORS-friendly flagcdn.com URLs for web
    // flagcdn.com supports CORS while flagsapi.com does not
    if (flagUrl.contains('flagsapi.com')) {
      // Extract country code from flagsapi.com URL
      // Example: https://flagsapi.com/AU/flat/64.png -> https://flagcdn.com/w80/au.png
      final codeMatch = RegExp(r'flagsapi\.com/([A-Z]{2})/').firstMatch(flagUrl);
      if (codeMatch != null) {
        final countryCode = codeMatch.group(1)!.toLowerCase();
        flagUrl = 'https://flagcdn.com/w80/$countryCode.png';
      }
    }
    
    return CountryModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      flag: flagUrl,
      id: json['id'] as int? ?? 0,
    );
  }

  /// Convert to entity
  Country toEntity() {
    return Country(
      code: code,
      name: name,
      flag: flag,
      id: id,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'flag': flag,
      'id': id,
    };
  }

  @override
  String toString() =>
      'CountryModel(code: $code, name: $name, flag: $flag, id: $id)';
}
