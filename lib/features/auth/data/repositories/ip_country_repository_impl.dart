import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/auth/data/datasources/remote/ip_country_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ip_country.dart';
import '../../domain/repositories/ip_country_repository.dart';

/// Provider for IpCountryRepository
final ipCountryRepositoryProvider = Provider<IpCountryRepository>((ref) {
  return IpCountryRepositoryImpl(
    ref.watch(ipCountryRemoteDataSourceProvider),
  );
});

class IpCountryRepositoryImpl implements IpCountryRepository {
  final IpCountryRemoteDataSource remoteDataSource;

  const IpCountryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, IpCountry>> detectCountry() async {
    try {
      final model = await remoteDataSource.detectCountry();
      return Right(model);
    } on DioException catch (e) {
      ErrorModel? errorModel;

      if (e.response?.data != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data);
        } catch (_) {
          // Ignore parsing errors
        }
      }

      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to detect country',
          statusCode: e.response?.statusCode,
          errorModel: errorModel,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
