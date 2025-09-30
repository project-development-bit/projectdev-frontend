import 'package:flutter/material.dart';
import 'package:cointiply_app/core/localization/localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoMainPage extends ConsumerStatefulWidget {
  const TodoMainPage({super.key});

  @override
  ConsumerState<TodoMainPage> createState() => _TodoMainPageState();
}

class _TodoMainPageState extends ConsumerState<TodoMainPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text(context.translate('todo_main_page'))));
  }
}
