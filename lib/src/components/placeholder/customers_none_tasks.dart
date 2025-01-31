import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomersNoneTasks extends ConsumerWidget {
  final String title;
  final String text;
  final bool btn;

  const CustomersNoneTasks(
      {super.key,
      this.title = 'У вас сейчас нет заданий',
      this.text = 'Открытые задания появятся здесь',
      this.btn = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = authState.role;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            width: 72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Square(),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              )),
          if (role == 'Customer' && btn == true) // Проверка роли
            Btn(
              text: 'Создать задание',
              theme: 'white',
              onPressed: () {
                AutoRouter.of(context).push(const NewTaskCreateRoute());
              },
            ),
        ],
      ),
    );
  }
}
