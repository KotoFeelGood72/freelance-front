import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void openResponseModal(BuildContext context, WidgetRef ref, String taskId) {
  final TextEditingController responseController = TextEditingController();

  showCustomModalBottomSheet(
    context: context,
    scroll: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Написать отклик',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Inputs(
                backgroundColor: Colors.white,
                textColor: Colors.black,
                controller: responseController,
                label: 'Ваш отклик',
                fieldType: 'text',
                isMultiline: true,
                required: true,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Btn(
                      text: 'Отмена',
                      theme: 'white',
                      textColor: AppColors.red,
                      onPressed: () {
                        Navigator.of(context).pop(); // Закрыть модалку
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Btn(
                      text: 'Отправить',
                      theme: 'violet',
                      onPressed: () {
                        ref
                            .read(sendTaskResponseProvider({
                          'taskId': taskId,
                          'text': responseController.text,
                        }).future)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Отклик успешно отправлен!'),
                            ),
                          );
                          AutoRouter.of(context)
                              .replaceAll([const TaskRoute()]);
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    },
  );
}
