import 'package:dio/dio.dart';
import '../../../network/base_dio_client.dart';
import '../models/app_settings_model.dart';

abstract class AppSettingsRemoteDataSource {
  /// Fetch app settings configuration from server
  /// Throws [DioException] for network errors
  Future<AppSettingsResponse> getAppSettings();
}

class AppSettingsRemoteDataSourceImpl implements AppSettingsRemoteDataSource {
  static const String _appSettingsEndpoint = 'app_settings';
  
  final DioClient dioClient;

  AppSettingsRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<AppSettingsResponse> getAppSettings() async {
    try {
      final response = await dioClient.get(_appSettingsEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        return AppSettingsResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Invalid response from server',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: _appSettingsEndpoint),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
