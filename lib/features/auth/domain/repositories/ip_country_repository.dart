import 'package:gigafaucet/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/ip_country.dart';

abstract class IpCountryRepository {
  Future<Either<Failure, IpCountry>> detectCountry();
}
