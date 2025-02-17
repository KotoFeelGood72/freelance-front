import 'package:freelance/providers/task_providers.dart';
// import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
// import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:freelance/src/constants/app_colors.dart';
// import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskDetailCustomerScreen extends ConsumerWidget {
  final String taskId;
  final int? responseId;

  const TaskDetailCustomerScreen({
    super.key,
    @PathParam('id') required this.taskId,
    @QueryParam('responseId') this.responseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(taskByIdProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали задачи, $responseId'),
      ),
      body: taskAsyncValue.when(
        data: (task) {
          final bool canAssignExecutor =
              responseId != null && task.taskStatus == "Поиск исполнителя";

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              border: Border(
                top: BorderSide(width: 1, color: AppColors.border),
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
                        task.taskName!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Square(),
                      Text(
                        task.taskDescription!,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Square(height: 32),
                      InfoRow(
                        label: 'Стоимость',
                        value: '${task.taskPrice} ₽',
                        hasTopBorder: true,
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Срок выполнения',
                        value: task.taskTerm.toString(),
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Размещено',
                        value: task.taskCreated.toString(),
                        hasBottomBorder: true,
                      ),
                      InfoRow(
                        label: 'Статус',
                        value: task.taskStatus!,
                        hasBottomBorder: true,
                      ),
                      const Square(),
                    ],
                  ),
                ),
                const Spacer(),

                // Отображаем кнопку только если условия выполняются
                if (canAssignExecutor)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Btn(
                          text: 'Назначить исполнителя',
                          onPressed: () => _confirmAssignExecutor(
                              context, ref, taskId, responseId!),
                          theme: 'violet',
                        ),
                      ),
                    ],
                  ),

                const Square(height: 32),
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

void _confirmAssignExecutor(
    BuildContext context, WidgetRef ref, String taskId, int responseId) {
  showCustomModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: AppColors.bg,
        padding:
            const EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Подтверждение',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Вы уверены, что хотите утвердить исполнителя на задание?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Btn(
                    text: 'Отмена',
                    theme: 'white',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Btn(
                    text: 'Да, утвердить',
                    theme: 'violet',
                    onPressed: () {
                      ref
                          .read(assignExecutorProvider({
                        'taskId': int.parse(taskId),
                        'responseId': responseId,
                      }).future)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Исполнитель успешно назначен!'),
                          ),
                        );
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка: $error'),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const Square(height: 32),
          ],
        ),
      );
    },
  );
}
