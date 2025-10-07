import 'package:cointiply_app/features/todo/domain/entities/todo.dart';
import 'package:cointiply_app/features/todo/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<Todo>> call(int page) async {
    return []; // await repository.getTodos(page); --- IGNORE ---
  }
}
