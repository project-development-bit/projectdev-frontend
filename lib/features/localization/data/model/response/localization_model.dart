import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';

class LocalizationModel extends LocalizationEntity {
  const LocalizationModel({required super.translations});

  factory LocalizationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, String> mapped = json.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return LocalizationModel(translations: mapped);
  }

  Map<String, dynamic> toJson() => translations;
}
