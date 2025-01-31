import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskPlaceholder extends ConsumerWidget {
  const TaskPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final errorMessage = taskState.errorMessage;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null && !taskState.isErrorShown)
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      // Убираем сообщение об ошибке
                      ref.read(taskNotifierProvider.notifier).clearError();
                    },
                  )
                ],
              ),
            ),
          Expanded(
            child: ListView(
              children: const [
                Text('Список задач будет отображаться здесь.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
