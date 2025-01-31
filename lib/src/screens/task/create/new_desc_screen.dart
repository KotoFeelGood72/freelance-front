import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class NewDescScreen extends ConsumerStatefulWidget {
  const NewDescScreen({super.key});

  @override
  _NewDescScreenState createState() => _NewDescScreenState();
}

class _NewDescScreenState extends ConsumerState<NewDescScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Слушаем изменения текста и отправляем их в TaskNotifier
    _descriptionController.addListener(() {
      ref
          .read(taskNotifierProvider.notifier)
          .updateTaskDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Описание задания",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText:
                      "Опишите ваше задание максимально подробно и понятно...",
                  hintStyle: TextStyle(color: AppColors.light),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            Square(),
            Row(
              children: [
                Expanded(
                  child: Btn(
                    text: 'Продолжить',
                    onPressed: () {
                      if (taskState.taskDescription.isNotEmpty) {
                        AutoRouter.of(context).push(NewConfirmTaskRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Описание не может быть пустым')),
                        );
                      }
                    },
                    theme: 'violet',
                  ),
                ),
              ],
            ),
            Square(),
          ],
        ),
      ),
    );
  }
}
