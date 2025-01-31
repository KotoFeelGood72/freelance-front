import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 70),
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
                  const SizedBox(height: 6),
                  Text(
                    'Разнорабочий.ру',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Btn(
                      text: 'Найти исполнителя',
                      theme: 'violet',
                      onPressed: () {
                        authNotifier.setRole('Customer');
                        AutoRouter.of(context).push(const AuthRoute());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Btn(
                      text: 'Стать исполнителем',
                      theme: 'light',
                      onPressed: () {
                        authNotifier.setRole('Executor');
                        AutoRouter.of(context).push(const AuthRoute());
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Btn(
                text: 'Войти в аккаунт',
                theme: 'white',
                onPressed: () {
                  AutoRouter.of(context).push(const AuthRoute());
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
