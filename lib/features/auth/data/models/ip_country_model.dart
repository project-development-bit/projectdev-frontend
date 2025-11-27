import '../../domain/entities/ip_country.dart';

class IpCountryModel extends IpCountry {
  const IpCountryModel({
    super.code,
    super.name,
  });

  factory IpCountryModel.fromJson(Map<String, dynamic> json) {
    return IpCountryModel(
      code: json['country_code'] as String? ?? "",
      name: json['country_name'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_code': code,
      'country_name': name,
    };
  }

  @override
  List<Object?> get props => [code, name];
}
