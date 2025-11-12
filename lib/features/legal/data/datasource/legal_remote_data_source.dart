import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:cointiply_app/features/legal/data/datasource/legal_remote_datasource_lmpl.dart';
import 'package:cointiply_app/features/legal/data/models/request/contact_us_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final legalRemoteDataSourceProvider = Provider<LegalRemoteDataSource>((ref) {
  final contactUsRepository = ref.read(dioClientProvider);
  return LegalRemoteDataSourceImpl(contactUsRepository);
});

abstract class LegalRemoteDataSource {
  Future<Map<String, dynamic>> submitContactForm(ContactUsRequest submission);
}
