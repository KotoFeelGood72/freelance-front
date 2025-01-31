import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/card/card_task.dart';
import 'package:freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class OpenTaskScreen extends ConsumerWidget {
  const OpenTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final authState = ref.watch(authProvider);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskState.tasks.isEmpty
              ? const CustomersNoneTasks()
              : ListView.builder(
                  itemCount: taskState.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskState.tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CardTask(
                        task: task,
                        onTap: () {
                          if (authState.role == 'Customer') {
                            AutoRouter.of(context).push(
                              TaskResponseRoute(taskId: task['id'].toString()),
                            );
                          } else {
                            AutoRouter.of(context).push(
                              TaskDetailRoute(taskId: task['id'].toString()),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
