import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:cointiply_app/features/localization/data/datasource/remote/localization_remote_data_source.dart';
import 'package:cointiply_app/features/localization/data/model/request/get_localization_request.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../domain/repositories/localization_repository.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationRemoteDataSource remote;
  final LocalizationLocalDataSource local;

  LocalizationRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, LocalizationEntity>> getLocalization(
      GetLocalizationRequest request) async {
    try {
      final String? locale = request.languageCode;
      final languageCode = await local.getSelectedLanguageCode() ?? 'en';
      // 1️⃣ Try local cache first
      final cached = await local.getCachedLocalization(locale ?? languageCode);
      final localVersion =
          await local.getLocalizationVersion(languageCode) ?? '';
      await local.setLocalizationVersion(
          languageCode,
          (request.languageVersion?.isEmpty ?? false)
              ? localVersion
              : request.languageVersion ?? '');
      if (cached != null &&
          (!request.forceRefresh || localVersion == request.languageVersion)) {
        debugPrint(
            '📦 Language version Returning cached localization for $languageCode (localVersion: $localVersion)');
        return Right(cached);
      }
      debugPrint(
          '🌐 Language version Fetching remote localization for $languageCode (requested version: ${request.languageVersion}, local version: $localVersion)');
      // 2️⃣ Fetch remote
      final LocalizationModel model =
          await remote.getLocalization(locale ?? languageCode);

      // 3️⃣ Cache it
      await local.cacheLocalization(locale ?? languageCode, model);
      return Right(model);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.response?.statusCode,
          // errorModel: errorModel,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(
          message: e.toString(), statusCode: null, errorModel: null));
    }
  }
}
