import 'package:equatable/equatable.dart';

/// Country Entity
///
/// Represents a country in the domain layer.
/// This is a pure Dart class with no dependencies on external packages
/// except for Equatable for value equality comparison.
class Country extends Equatable {
  const Country({
    required this.code,
    required this.name,
    required this.flag,
  });

  /// Country code (e.g., "US", "AU", "MM")
  final String code;

  /// Country name (e.g., "United States", "Australia")
  final String name;

  /// URL to the country flag image
  final String flag;

  @override
  List<Object> get props => [code, name, flag];

  @override
  String toString() => 'Country(code: $code, name: $name , flag: $flag)';
}
