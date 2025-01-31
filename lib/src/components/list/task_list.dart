import 'package:freelance/src/components/card/card_task.dart';
import 'package:freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskList extends ConsumerWidget {
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>)? onTaskTap;

  const TaskList({
    super.key,
    required this.filters,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsyncValue = ref.watch(fetchTasksProvider(filters));

    return taskListAsyncValue.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 250,
              child: const CustomersNoneTasks(),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CardTask(
                task: task,
                onTap: () {
                  if (onTaskTap != null) {
                    onTaskTap!(task);
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(child: CustomersNoneTasks()),
    );
  }
}
