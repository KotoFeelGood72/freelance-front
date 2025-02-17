import 'package:freelance/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';

@RoutePage()
class TaskResponseScreen extends ConsumerWidget {
  final String taskId;

  const TaskResponseScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskResponses = ref.watch(taskResponsesProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отклики', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () => AutoRouter.of(context)
                .push(TaskDetailCustomerRoute(taskId: taskId)),
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.info_outline_rounded,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: taskResponses.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const CustomersNoneTasks(
                title: "Еще никто не откликнулся",
                text: "Как только кто-то проявит интерес к вашему заданию, "
                    "они появятся здесь. Следите за уведомлениями!",
                btn: false);
          }
          return Container(
            decoration: const BoxDecoration(
                color: AppColors.bg,
                border:
                    Border(top: BorderSide(width: 1, color: AppColors.border))),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final response = tasks[index];
                return GestureDetector(
                  onTap: () => AutoRouter.of(context).push(ChatsRoute(
                      chatsId: response['roomUUID'], taskId: taskId)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(response['photo']),
                          radius: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      '${response['firstName']} ${response['lastName']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    response['created_at'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.add,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    response['rating'].toString(),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                response['text'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
