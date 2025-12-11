class GetLocalizationRequest {
  final String? languageCode;
  final String? userId;
  final String? languageVersion;
  final bool forceRefresh;

  GetLocalizationRequest({
    this.languageCode,
    this.userId,
    this.languageVersion,
    this.forceRefresh = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      if (userId != null) 'user_id': userId,
      if (languageVersion != null) 'language_version': languageVersion,
    };
  }

  GetLocalizationRequest copyWith({
    String? languageCode,
    String? userId,
    String? languageVersion,
  }) {
    return GetLocalizationRequest(
      languageCode: languageCode ?? this.languageCode,
      userId: userId ?? this.userId,
      languageVersion: languageVersion ?? this.languageVersion,
    );
  }
}
