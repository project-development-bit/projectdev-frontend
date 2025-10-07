import 'package:flutter/material.dart';
import 'package:cointiply_app/features/todo/domain/entities/todo.dart';

class TodoCardWidget extends StatelessWidget {
  final Todo todo;

  const TodoCardWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                todo.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Icon(
                todo.finished
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: todo.finished ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
