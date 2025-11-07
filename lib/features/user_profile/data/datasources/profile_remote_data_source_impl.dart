import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/user_profile/data/models/response/user_update_respons.dart';
import 'package:universal_io/io.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../models/response/user_profile_model.dart';
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
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/profile');

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error getting user profile: $e');
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
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      String mimeType = _getMimeType(fileName);

      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '/users/$userId/profile/picture',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data']['profile_picture_url'];
      } else {
        throw Exception(
            'Failed to upload profile picture: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error uploading profile picture: $e');
    }
  }

  @override
  Future<void> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dio.put(
        '/users/$userId/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update password: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error updating password: $e');
    }
  }

  @override
  Future<void> updateEmail(String userId, String newEmail) async {
    try {
      final response = await _dio.put(
        '/users/$userId/email',
        data: {'new_email': newEmail},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error updating email: $e');
    }
  }

  @override
  Future<void> verifyEmail(String userId, String verificationCode) async {
    try {
      final response = await _dio.post(
        '/users/$userId/email/verify',
        data: {'verification_code': verificationCode},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to verify email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error verifying email: $e');
    }
  }

  @override
  Future<void> verifyPhone(String userId, String verificationCode) async {
    try {
      final response = await _dio.post(
        '/users/$userId/phone/verify',
        data: {'verification_code': verificationCode},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to verify phone: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error verifying phone: $e');
    }
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    try {
      final response = await _dio.post(
        '/users/$userId/email/send-verification',
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send verification email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error sending verification email: $e');
    }
  }

  @override
  Future<void> sendVerificationSMS(String userId) async {
    try {
      final response = await _dio.post(
        '/users/$userId/phone/send-verification',
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send verification SMS: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error sending verification SMS: $e');
    }
  }

  @override
  Future<void> deactivateAccount(String userId, String password) async {
    try {
      final response = await _dio.post(
        '/users/$userId/deactivate',
        data: {'password': password},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to deactivate account: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error deactivating account: $e');
    }
  }

  @override
  Future<void> deleteAccount(String userId, String password) async {
    try {
      final response = await _dio.delete(
        '/users/$userId',
        data: {'password': password},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error deleting account: $e');
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

  /// Gets MIME type for file extension
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
