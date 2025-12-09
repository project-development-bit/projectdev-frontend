import 'dart:convert';
import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizationLocalDataSourceProvider =
    Provider<LocalizationLocalDataSource>((ref) {
  final sharedPreferences = ref.read(sharedPreferencesProviderForAppSettings);

  return LocalizationLocalDataSourceImpl(sharedPreferences);
});

abstract class LocalizationLocalDataSource {
  Future<void> cacheLocalization(String locale, LocalizationModel model);
  Future<LocalizationModel?> getCachedLocalization(String locale);

  Future<String?> getSelectedLanguageCode();
  Future<void> setSelectedLanguageCode(String languageCode);

  Future<String?> getLocalizationVersion(String languageCode);
  Future<void> setLocalizationVersion(String languageCode, String version);
}

class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  final SharedPreferences sharedPreferences;

  const LocalizationLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheLocalization(String locale, LocalizationModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await sharedPreferences.setString("localization_$locale", jsonString);
  }

  @override
  Future<LocalizationModel?> getCachedLocalization(String locale) async {
    final jsonString = sharedPreferences.getString("localization_$locale");
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return LocalizationModel.fromJson(jsonMap);
  }

  @override
  Future<String?> getSelectedLanguageCode() async {
    return sharedPreferences.getString("selected_language_code");
  }

  @override
  Future<void> setSelectedLanguageCode(String languageCode) async {
    await sharedPreferences.setString("selected_language_code", languageCode);
  }

  @override
  Future<String?> getLocalizationVersion(String languageCode) async {
    return sharedPreferences.getString("localization_version_$languageCode");
  }

  @override
  Future<void> setLocalizationVersion(
      String languageCode, String version) async {
    await sharedPreferences.setString(
        "localization_version_$languageCode", version);
  }
}
