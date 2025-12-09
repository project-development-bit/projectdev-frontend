import 'dart:convert';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizationLocalDataSourceProvider =
    Provider<LocalizationLocalDataSource>((ref) {
  return LocalizationLocalDataSourceImpl();
});

abstract class LocalizationLocalDataSource {
  Future<void> cacheLocalization(String locale, LocalizationModel model);
  Future<LocalizationModel?> getCachedLocalization(String locale);
}

class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  const LocalizationLocalDataSourceImpl();

  @override
  Future<void> cacheLocalization(String locale, LocalizationModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString("localization_$locale", jsonString);
  }

  @override
  Future<LocalizationModel?> getCachedLocalization(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("localization_$locale");
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return LocalizationModel.fromJson(jsonMap);
  }
}
