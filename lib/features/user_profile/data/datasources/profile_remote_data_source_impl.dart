import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/core/utils/utils.dart';
import 'package:cointiply_app/features/user_profile/data/models/country_model.dart';
import 'package:cointiply_app/features/localization/data/model/response/language_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/profile_detail_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/upload_profile_avatar_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/change_email_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/verify_email_change_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/change_password_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/delete_account_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/verify_delete_account_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/set_security_pin_response_model.dart';
import 'package:cointiply_app/features/user_profile/data/models/request/set_security_pin_request_model.dart';
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
        return ProfileDetailModel.fromJson(
            response.data as Map<String, dynamic>);
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
  Future<List<LanguageModel>> getLanguages() async {
    try {
      debugPrint('🌐 Fetching languages list...');

      final response = await _dio.get('/languages');

      debugPrint('✅ Languages fetched successfully: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        final data = response.data as Map<String, dynamic>;
        final languagesList = data['languages'] as List<dynamic>;

        return languagesList
            .map((language) =>
                LanguageModel.fromJson(language as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch languages: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Languages fetch DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error fetching languages: $e');
      throw Exception('Unexpected error fetching languages: $e');
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
  Future<ChangeEmailResponseModel> changeEmail({
    required String currentEmail,
    required String newEmail,
    required String repeatNewEmail,
  }) async {
    try {
      debugPrint('✉️ Changing user email...');

      final body = {
        'current_email': currentEmail,
        'new_email': newEmail,
        'repeat_new_email': repeatNewEmail,
      };

      final response = await _dio.patch('/users/email', data: body);

      debugPrint('✅ Change email response: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return ChangeEmailResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        // If server returned an error status code, try to extract message
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(message: message ?? 'Failed to change email');
      }
    } on DioException catch (e) {
      debugPrint('❌ Change email DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      // Map to ServerFailure so repository can pick it up
      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(message: message ?? 'Unexpected error');
    } catch (e) {
      debugPrint('❌ Unexpected error changing email: $e');
      throw ServerFailure(message: 'Unexpected error changing email: $e');
    }
  }

  @override
  Future<VerifyEmailChangeResponseModel> verifyEmailChange({
    required String email,
    required String code,
  }) async {
    try {
      debugPrint('🔎 Verifying email change for $email with code $code');

      final response = await _dio.post('/users/verify-email-change', data: {
        'email': email,
        'security_code': code,
      });

      debugPrint('✅ Verify email change response: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return VerifyEmailChangeResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(
            message: message ?? 'Failed to verify email change');
      }
    } on DioException catch (e) {
      debugPrint('❌ Verify email change DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(message: message ?? 'Unexpected error');
    } catch (e) {
      debugPrint('❌ Unexpected error verifying email change: $e');
      throw ServerFailure(
          message: 'Unexpected error verifying email change: $e');
    }
  }

  @override
  Future<ChangePasswordResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatNewPassword,
  }) async {
    try {
      debugPrint('🔒 Changing user password...');

      final body = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'repeat_new_password': repeatNewPassword,
      };

      final response = await _dio.patch('/users/password', data: body);

      debugPrint('✅ Change password response: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return ChangePasswordResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        // If server returned an error status code, try to extract message
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(message: message ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      debugPrint('❌ Change password DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      // Handle validation errors
      if (e.response?.data != null && e.response?.data is Map) {
        final responseData = e.response!.data as Map<String, dynamic>;

        // Check for validation errors in the code.errors array
        if (responseData['code'] != null &&
            responseData['code'] is Map &&
            responseData['code']['errors'] != null) {
          final errors = responseData['code']['errors'] as List<dynamic>;

          // Combine all error messages into one text
          final errorMessages = errors
              .map((error) => error['msg'] as String?)
              .where((msg) => msg != null)
              .join('. ');

          throw ServerFailure(
            message: errorMessages.isNotEmpty
                ? errorMessages
                : responseData['message'] ?? 'Failed to change password',
          );
        }

        // Fallback to general message
        final message = responseData['message'];
        throw ServerFailure(message: message ?? 'Failed to change password');
      }

      // Generic error
      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(message: message ?? 'Unexpected error');
    } catch (e) {
      debugPrint('❌ Unexpected error changing password: $e');
      throw ServerFailure(message: 'Unexpected error changing password: $e');
    }
  }

  @override
  Future<UploadProfileAvatarResponseModel> uploadProfilePicture(
      PlatformFile file) async {
    try {
      // Compress image and get bytes (works on both web and mobile)
      final bytes = await compressImageToBytes(file, quality: 50);

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

  @override
  Future<DeleteAccountResponseModel> deleteAccount(String userId) async {
    try {
      debugPrint('🗑️ Requesting account deletion for user: $userId');

      final response = await _dio.delete('/users/id/$userId');

      debugPrint('✅ Delete account request sent: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return DeleteAccountResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(
            message: message ?? 'Failed to request account deletion');
      }
    } on DioException catch (e) {
      debugPrint('❌ Delete account DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(
          message: message ?? 'Failed to request account deletion');
    } catch (e) {
      debugPrint('❌ Unexpected error requesting account deletion: $e');
      throw ServerFailure(
          message: 'Unexpected error requesting account deletion: $e');
    }
  }

  @override
  Future<VerifyDeleteAccountResponseModel> verifyDeleteAccount(
      String code) async {
    try {
      debugPrint('🔎 Verifying account deletion with code: $code');

      final response = await _dio.post('/users/verify-delete-account', data: {
        'verification_code': code,
      });

      debugPrint('✅ Account deletion verified: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return VerifyDeleteAccountResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(
            message: message ?? 'Failed to verify account deletion');
      }
    } on DioException catch (e) {
      debugPrint('❌ Verify delete account DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(
          message: message ?? 'Failed to verify account deletion');
    } catch (e) {
      debugPrint('❌ Unexpected error verifying account deletion: $e');
      throw ServerFailure(
          message: 'Unexpected error verifying account deletion: $e');
    }
  }

  @override
  Future<SetSecurityPinResponseModel> setSecurityPin({
    required int securityPin,
    required bool enable,
  }) async {
    try {
      debugPrint('🔐 Setting security PIN (enable: $enable)');

      final requestModel = SetSecurityPinRequestModel(
        securityPin: securityPin,
        enable: enable,
      );

      final response = await _dio.post(
        '/users/security-pin',
        data: requestModel.toJson(),
      );

      debugPrint('✅ Security PIN set successfully: ${response.statusCode}');

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return SetSecurityPinResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final message = response.data is Map ? response.data['message'] : null;
        throw ServerFailure(message: message ?? 'Failed to set security PIN');
      }
    } on DioException catch (e) {
      debugPrint('❌ Set security PIN DioException: ${e.message}');
      debugPrint('❌ Response status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');

      final message = e.response?.data?['message'] ?? e.message;
      throw ServerFailure(message: message ?? 'Failed to set security PIN');
    } catch (e) {
      debugPrint('❌ Unexpected error setting security PIN: $e');
      throw ServerFailure(message: 'Unexpected error setting security PIN: $e');
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
