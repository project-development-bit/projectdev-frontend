import 'package:equatable/equatable.dart';

class LocalizationEntity extends Equatable {
  final Map<String, String> translations;

  const LocalizationEntity({required this.translations});

  String get(String key) => translations[key] ?? key;

  @override
  List<Object?> get props => [translations];
}
