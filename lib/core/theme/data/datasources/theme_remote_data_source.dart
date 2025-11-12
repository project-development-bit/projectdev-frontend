import 'package:dio/dio.dart';
import '../../../network/base_dio_client.dart';
import '../models/theme_config_model.dart';

abstract class ThemeRemoteDataSource {
  /// Fetch theme configuration from server
  /// Throws [DioException] for network errors
  Future<ThemeConfigModel> getThemeConfig();
}

class ThemeRemoteDataSourceImpl implements ThemeRemoteDataSource {
  final DioClient dioClient;

  ThemeRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<ThemeConfigModel> getThemeConfig() async {
    try {
      final response = await dioClient.get('/api/theme');

      if (response.statusCode == 200 && response.data != null) {
        return ThemeConfigModel.fromJson(response.data as Map<String, dynamic>);
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
        requestOptions: RequestOptions(path: '/api/theme'),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
