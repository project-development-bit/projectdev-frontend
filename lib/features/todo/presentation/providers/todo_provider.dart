import 'package:cointiply_app/core/network/dio_provider.dart';
import 'package:cointiply_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:cointiply_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoRemoteDataSourceProvider = Provider(
  (ref) => TodoRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final todoRepositoryProvider = Provider(
  (ref) => TodoRepositoryImpl(ref.watch(todoRemoteDataSourceProvider)),
);

