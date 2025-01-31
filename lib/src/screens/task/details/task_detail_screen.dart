import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:freelance/src/screens/task/customers/task_response_screen.dart';
import 'package:freelance/src/screens/task/details/customer/task_detail_customer.dart';
import 'package:freelance/src/screens/task/details/executor/task_detail_executor.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    @PathParam('taskId') required this.taskId,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider); // Получаем состояние авторизации
    final role = authState.role; // Извлекаем роль пользователя

    // Выбираем экран в зависимости от роли
    Widget screen;
    if (role == 'Executor') {
      screen = TaskDetailExecutorScreen(taskId: widget.taskId);
    } else if (role == 'Customer') {
      screen = TaskResponseScreen(taskId: widget.taskId);
    } else {
      screen = const Center(child: Text('Роль не определена'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали задачи (${role ?? 'Нет роли'})'),
      ),
      body: screen,
    );
  }
}
