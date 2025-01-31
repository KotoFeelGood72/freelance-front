import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/location_picker.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/src/utils/date_picker_utils.dart';
import 'package:freelance/src/utils/edit_input_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:latlong2/latlong.dart';

@RoutePage()
class NewConfirmTaskScreen extends ConsumerWidget {
  const NewConfirmTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    final taskNotifier = ref.read(taskNotifierProvider.notifier);

    if (taskState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(taskState.errorMessage!)),
        );
        taskNotifier.clearError();
      });
    }

    if (taskState.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(taskState.successMessage!)),
        );
        AutoRouter.of(context).push(const TaskRoute());
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Новое задание",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.bg),
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskState.taskName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Square(height: 8),
                  Text(
                    taskState.taskDescription ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                    ),
                  ),
                  const Square(),
                  _buildEditableField(
                    context,
                    "Стоимость",
                    "${taskState.taskPrice ?? "0"} ₽",
                    () {
                      showEditInput(
                        context: context,
                        initialValue: taskState.taskPrice.toString(),
                        backgroundColor: AppColors.ulight,
                        textColor: AppColors.black,
                        onSubmitted: (newPrice) {
                          taskNotifier
                              .updateTaskPrice(int.tryParse(newPrice) ?? 0);
                        },
                      );
                    },
                    borderTop: true,
                  ),
                  _buildEditableField(
                    context,
                    "Выполнить до",
                    taskState.taskTerm != null
                        ? "${taskState.taskTerm!.day}.${taskState.taskTerm!.month} ${taskState.taskTerm!.hour}:${taskState.taskTerm!.minute}"
                        : "Укажите дату",
                    () async {
                      DateTime? pickedDate = await pickDate(context,
                          initialDate: taskState.taskTerm);
                      if (pickedDate != null) {
                        taskNotifier.updateTaskTerm(pickedDate);
                      }
                    },
                  ),
                  _buildEditableField(
                    context,
                    "Локация",
                    taskState.taskCity ?? "Укажите город",
                    () {
                      _openLocationPicker(context, taskNotifier);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Btn(
                text: 'Разместить задание',
                onPressed: () {
                  taskNotifier.submitTask(context);
                  AutoRouter.of(context).replaceAll([const TaskRoute()]);
                },
                theme: 'violet',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocationPicker(
      BuildContext context, TaskNotifier taskNotifier) async {
    const LatLng initialLocation =
        LatLng(55.7558, 37.6173); // Москва по умолчанию
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPickerMap(
          initialLocation: initialLocation,
          onLocationSelected: (LatLng location, String address) {
            taskNotifier.updateTaskCity(address);
          },
        ),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    String title,
    String value,
    VoidCallback onEdit, {
    bool borderTop = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(
            width: 1,
            color: AppColors.border,
          ),
          top: borderTop
              ? const BorderSide(
                  width: 1,
                  color: AppColors.border,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEdit,
            child: const Iconify(
              MaterialSymbols.edit_outline_rounded,
              color: AppColors.violet,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
