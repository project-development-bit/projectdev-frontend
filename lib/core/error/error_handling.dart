import 'package:dio/dio.dart';

class ErrorHandling {
  // Handle DioException for Network Errors
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Bad request. Please check your input and try again.';
        case 403:
          return 'Forbidden. You don\'t have permission to access this resource.';
        case 404:
          return 'Resource not found. The requested data does not exist.';
        case 500:
          return 'Server error. Please try again later.';
        case 429:
          return 'Too many contact form submissions. Please try again after 15 minutes.';
        default:
          return 'Network error. Please check your connection and try again.';
      }
    }
    return 'An unexpected error occurred: $error';
  }
}
