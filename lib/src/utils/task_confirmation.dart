import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<bool> showExitConfirmation(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              "Закрыть форму без сохранения данных?",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Square(),
            const Text(
              "Если выйти из формы, введённые данные будут потеряны.",
              style: TextStyle(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
            Square(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: Btn(
                text: 'Продолжить',
                onPressed: () {
                  Navigator.pop(
                      context, false); // Возврат false, остаёмся на экране
                },
                theme: 'violet',
              ),
            ),
            Square(),
            SizedBox(
              width: double.infinity,
              child: Btn(
                text: 'Выйти без сохранения',
                onPressed: () {
                  Navigator.pop(context, true);
                },
                theme: 'white',
              ),
            ),
          ],
        ),
      );
    },
  );

  return result ??
      false; // Возвращаем false, если пользователь ничего не выбрал
}
