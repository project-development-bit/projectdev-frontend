import 'package:gigafaucet/features/auth/domain/entities/ip_country.dart';

enum GetIpCountryStatus {
  initial,
  loading,
  success,
  error,
}

class IpCountryState {
  final GetIpCountryStatus status;
  final IpCountry? country;
  final String? error;

  const IpCountryState({
    this.status = GetIpCountryStatus.initial,
    this.country,
    this.error,
  });

  IpCountryState copyWith({
    GetIpCountryStatus? status,
    IpCountry? country,
    String? error,
  }) {
    return IpCountryState(
      status: status ?? this.status,
      country: country ?? this.country,
      error: error,
    );
  }
}
