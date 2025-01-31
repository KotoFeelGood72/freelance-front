import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/src/utils/modal_utils.dart';
import 'package:freelance/src/utils/send_repsponse.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskDetailExecutorScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailExecutorScreen({super.key, required this.taskId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(taskByIdProvider(taskId));
    return Scaffold(
      body: taskAsyncValue.when(
        data: (task) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: AppColors.border,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['taskName'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Square(),
                      Text(
                        task['taskDescription'],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Square(
                        height: 32,
                      ),
                      InfoRow(
                        label: 'Стоимость',
                        value: '${task['taskPrice']} ₽',
                        hasTopBorder: true,
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Срок выполнения',
                        value: task['taskTerm'],
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Размещено',
                        value: task['taskCreated'],
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Статус',
                        value: task['taskStatus'],
                        hasBottomBorder: true,
                      ),
                      const Square(),
                      Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircleAvatar(
                              backgroundImage: task['customer']['photo'] != null
                                  ? NetworkImage(
                                      task['customer']['photo'].toString())
                                  : const AssetImage(
                                      'assets/images/splash.png'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                              '${task['customer']['firstName']} ${task['customer']['lastName']}'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).push(
                                  TaskCustomerProfileRoute(
                                      profileCustomerId: task['customer']
                                          ['id']));
                            },
                            child: const Text(
                              'Подробнее',
                              style: TextStyle(
                                  color: AppColors.violet,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Square(),
                // Btn(
                //     text: 'в чат',
                //     onPressed: () {
                //       AutoRouter.of(context)
                //           .push(ChatsRoute(chatsId: taskId.toString()));
                //     },
                //     theme: 'white',
                //     textColor: AppColors.red),
                const Spacer(),
                if (task['taskStatus'] == 'Поиск исполнителя')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Btn(
                              text: 'Отказаться',
                              theme: 'white',
                              onPressed: () {})),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Btn(
                            text: 'Согласиться',
                            onPressed: () =>
                                openResponseModal(context, ref, taskId),
                            theme: 'violet'),
                      ),
                    ],
                  ),
                if (task['taskStatus'] != 'Поиск исполнителя')
                  SizedBox(
                    width: double.infinity,
                    child: Btn(
                        text: 'Подтвердить выполнение',
                        onPressed: () =>
                            openResponseModal(context, ref, taskId),
                        theme: 'violet'),
                  ),

                const Square(
                  height: 32,
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
