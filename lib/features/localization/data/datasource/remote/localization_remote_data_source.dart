import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class LocalizationRemoteDataSource {
  Future<LocalizationModel> getLocalization(String locale);
}

class LocalizationRemoteDataSourceImpl implements LocalizationRemoteDataSource {
  final DioClient dioClient;

  const LocalizationRemoteDataSourceImpl(this.dioClient);

  @override
  Future<LocalizationModel> getLocalization(String locale) async {
    final url =
        "https://gigafaucet-images-s3.s3.ap-southeast-2.amazonaws.com/$locale.json";

    try {
      debugPrint('🌐 Fetching localization for: $locale');
      debugPrint('📤 Request URL: $url');
      debugPrint('📤 Base URL: ${dioClient.client.options.baseUrl}');

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      debugPrint('📥 Localization response received');
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Data: ${response.data}');

      return LocalizationModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ Localization DioException: ${e.message}');
      debugPrint('❌ URL: ${e.requestOptions.uri}');
      debugPrint('❌ Status: ${e.response?.statusCode}');
      debugPrint('❌ Data: ${e.response?.data}');

      final serverMessage = _extractServerErrorMessage(e.response?.data) ??
          _getFallbackMessage(e);
      print("❌ Extracted server message: $serverMessage");
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: serverMessage,
      );
    } catch (e) {
      debugPrint('❌ Unexpected localization error: $e');
      throw Exception('Unexpected localization error: $e');
    }
  }

  /// Extract server error from API response
  String? _extractServerErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String?;
    }
    return null;
  }

  /// Provide fallback message by status
  String _getFallbackMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized access";
      case 403:
        return "Unsupported locale";
      case 404:
        return "Localization file not found";
      case 422:
        return "Invalid locale format";
      case 500:
        return "Server error";
      default:
        return e.message ?? "Failed to load localization";
    }
  }
}
