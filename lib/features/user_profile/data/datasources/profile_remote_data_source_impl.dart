import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/core/utils/utils.dart';
import 'package:cointiply_app/features/user_profile/data/models/country_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/profile_detail_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'profile_remote_data_source.dart';

/// Implementation of [ProfileRemoteDataSource] using Dio HTTP client
///
/// This class handles all remote API calls related to user profile management,
/// including fetching, updating, and file upload operations.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dio;

  ProfileRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient;

  @override
  Future<ProfileDetailModel> getProfile() async {
    try {
      debugPrint('📱 Fetching user profile...');

      final response = await _dio.get('/users/profile');

      debugPrint('✅ Profile fetched successfully: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return ProfileDetailModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Profile fetch DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error fetching profile: $e');
      throw Exception('Unexpected error fetching profile: $e');
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      debugPrint('🌍 Fetching countries list...');

      final response = await _dio.get('/countries');

      debugPrint('✅ Countries fetched successfully: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        final data = response.data as Map<String, dynamic>;
        final countriesList = data['data'] as List<dynamic>;

        return countriesList
            .map((country) =>
                CountryModel.fromJson(country as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch countries: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Countries fetch DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error fetching countries: $e');
      throw Exception('Unexpected error fetching countries: $e');
    }
  }

  @override
  Future<UserUpdateResponse> updateUserProfile(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _dio.patch(
        '/users/id/$userId',
        data: profileData,
      );
      if (response.statusCode == 200) {
        return UserUpdateResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to update user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error updating user profile: $e');
    }
  }

  @override
  Future<UploadProfileAvatarResponseModel> uploadProfilePicture(
      PlatformFile file) async {
    try {
      // Compress image and get bytes (works on both web and mobile)
      final bytes = await compressImageToBytes(file, quality: 5);

      if (bytes.isEmpty) {
        throw ServerFailure(message: 'File bytes are empty');
      }

      final formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: DioMediaType(
            'image',
            file.extension?.toLowerCase() ?? 'jpeg',
          ),
        ),
      });

      final response = await _dio.post(
        'users/profile/avatar',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return UploadProfileAvatarResponseModel.fromJson(response.data);
      } else {
        throw ServerFailure(message: response.data["message"]);
      }
    } on DioException catch (e) {
      throw ServerFailure(
          message: e.response?.data['message'] ?? 'Unexpected error');
    } catch (e) {
      throw ServerFailure(message: 'Unknown error occurred: $e');
    }
  }


  /// Handles Dio exceptions and converts them to appropriate error messages
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
            'Connection timeout. Please check your internet connection.');
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Server response timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? 'Unknown error occurred';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception(
            'Connection error. Please check your internet connection.');
      default:
        return Exception('Network error: ${e.message}');
    }
  }

}
