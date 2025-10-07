import 'package:cointiply_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:cointiply_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);
}
