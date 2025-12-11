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

  String getLocateCode(String locale) {
    if ("english" == locale ||
        locale == "en" ||
        locale == "us" ||
        locale == "united states" ||
        locale == "united states of america") {
      return "en";
    } else if (locale == "mm" ||
        locale == "my " ||
        locale == "myanmar" ||
        locale == "burmese") {
      return "my";
    } else if (locale.length >= 2) {
      return locale.substring(0, 2).toLowerCase();
    }
    return 'en';
  }

  @override
  Future<LocalizationModel> getLocalization(String locale) async {
    var countryCode = getLocateCode(locale.toLowerCase());
    final url =
        "https://gigafaucet-images-s3.s3.ap-southeast-2.amazonaws.com/$countryCode.json";

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
        return "Sorry, we don’t support this language yet. Please choose another one.";
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
