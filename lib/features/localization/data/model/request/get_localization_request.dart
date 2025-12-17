class GetLocalizationRequest {
  final String? languageCode;
  final String? countryCode;
  final String? userId;
  final String? languageVersion;
  final bool forceRefresh;

  GetLocalizationRequest({
    this.languageCode,
    this.countryCode,
    this.userId,
    this.languageVersion,
    this.forceRefresh = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'country_code': countryCode,
      if (userId != null) 'user_id': userId,
      if (languageVersion != null) 'language_version': languageVersion,
    };
  }

  GetLocalizationRequest copyWith({
    String? languageCode,
    String? countryCode,
    String? userId,
    String? languageVersion,
  }) {
    return GetLocalizationRequest(
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      userId: userId ?? this.userId,
      languageVersion: languageVersion ?? this.languageVersion,
    );
  }
}
