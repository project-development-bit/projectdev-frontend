import 'package:gigafaucet/core/network/base_dio_client.dart';
import 'package:gigafaucet/features/legal/data/datasource/legal_remote_data_source.dart';
import 'package:gigafaucet/features/legal/data/models/request/contact_us_request.dart';

class LegalRemoteDataSourceImpl implements LegalRemoteDataSource {
  final DioClient _dio;

  LegalRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> submitContactForm(
      ContactUsRequest submission) async {
    final response = await _dio.post('/contact', data: submission.toJson());

    return response.data;
  }
}
