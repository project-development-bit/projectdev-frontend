import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:cointiply_app/features/localization/data/datasource/remote/localization_remote_data_source.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/localization_repository.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationRemoteDataSource remote;
  final LocalizationLocalDataSource local;

  LocalizationRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, LocalizationEntity>> getLocalization(String? locale,
      {bool refresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString("selected_language_code") ?? 'en';
      // 1️⃣ Try local cache first
      final cached = await local.getCachedLocalization(locale ?? languageCode);
      if (cached != null) {
        return Right(cached);
      }

      // 2️⃣ Fetch remote
      final LocalizationModel model =
          await remote.getLocalization(locale ?? languageCode);

      // 3️⃣ Cache it
      await local.cacheLocalization(locale ?? languageCode, model);

      return Right(model);
    } on DioException catch (e) {
      // ErrorModel? errorModel;

      // if (e.response?.data != null) {
      //   errorModel = ErrorModel.fromJson(e.response!.data);
      // }

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
