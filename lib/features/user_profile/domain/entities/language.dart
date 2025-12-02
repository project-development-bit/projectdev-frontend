import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
  });

  /// Language code (e.g., "EN", "FR", "MM")
  final String code;

  /// Language name (e.g., "English", "French", "Myanmar")
  final String name;

  /// URL to the language flag image
  final String flag;

  /// Whether this is the default language
  final bool isDefault;

  String get displayFlag {
    return getDisplayFlag(code);
  }

  factory Language.empty() {
    return Language(
      code: '',
      name: '',
      flag: '',
      isDefault: false,
    );
  }

  String getDisplayFlag(String langCode) {
    final formattedCode =
        langCode.toLowerCase() == 'en' ? 'us' : langCode.toLowerCase();
    // return "https://flagsapi.com/$formattedCode/flat/64.png";
    return 'https://flagcdn.com/w80/$formattedCode.png';
  }

  String getDisplayName(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'mm':
        return 'Myanmar';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object> get props => [code, name, flag, isDefault];

  @override
  String toString() =>
      'Language(code: $code, name: $name, flag: $flag, isDefault: $isDefault)';
}
