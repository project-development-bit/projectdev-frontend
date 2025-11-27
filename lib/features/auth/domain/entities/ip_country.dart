import 'package:equatable/equatable.dart';

class IpCountry extends Equatable {
  final String? code;
  final String? name;

  const IpCountry({
    this.code,
    this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
