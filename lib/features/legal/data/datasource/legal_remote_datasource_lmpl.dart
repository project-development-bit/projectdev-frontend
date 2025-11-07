import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/legal/data/datasource/legal_remote_data_source.dart';

class LegalRemoteDataSourceImpl implements LegalRemoteDataSource {
  final DioClient _dio;

  LegalRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> submitContactForm(
    String name,
    String category,
    String subject,
    String message,
    String? email,
    String? phone,
    String? turnstileToken,
  ) async {
    final response = await _dio.post('/contact', data: {
      'name': name,
      'category': category,
      'subject': subject,
      'message': message,
      'phone': phone,
      'email': email,
      'turnstileToken': turnstileToken,
    });

    return response.data;
  }
}
