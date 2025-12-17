import 'package:equatable/equatable.dart';

/// Language Entity
///
/// Represents a language in the domain layer.
/// This is a pure Dart class with no dependencies on external packages
/// except for Equatable for value equality comparison.
class Language extends Equatable {
  const Language({
    required this.code,
    required this.name,
    required this.flag,
    required this.isDefault,
    required this.countryCode,
  });

  /// Language code (e.g., "EN", "FR", "MM")
  final String code;

  /// Language name (e.g., "English", "French", "Myanmar")
  final String name;

  /// URL to the language flag image
  final String flag;

  /// Whether this is the default language
  final bool isDefault;

  final String countryCode;

  factory Language.empty() {
    return Language(
      code: '',
      name: '',
      flag: '',
      isDefault: false,
      countryCode: '',
    );
  }

  @override
  List<Object> get props => [code, name, flag, isDefault, countryCode];

  @override
  String toString() =>
      'Language(code: $code, name: $name, flag: $flag, isDefault: $isDefault, countryCode: $countryCode)';
}
