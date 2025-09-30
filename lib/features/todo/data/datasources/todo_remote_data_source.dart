import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/network/dio_provider.dart';

abstract class TodoRemoteDataSource {}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final Dio dio;

  TodoRemoteDataSourceImpl(this.dio);
}

final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TodoRemoteDataSourceImpl(dio);
});
