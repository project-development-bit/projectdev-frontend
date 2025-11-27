import 'package:cointiply_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/ip_country.dart';
import '../repositories/ip_country_repository.dart';
import '../../data/repositories/ip_country_repository_impl.dart';

class GetIpCountryUseCase {
  final IpCountryRepository repository;

  const GetIpCountryUseCase(this.repository);

  Future<Either<Failure, IpCountry>> call() {
    return repository.detectCountry();
  }
}

final getIpCountryUseCaseProvider = Provider<GetIpCountryUseCase>((ref) {
  return GetIpCountryUseCase(
    ref.watch(ipCountryRepositoryProvider),
  );
});
