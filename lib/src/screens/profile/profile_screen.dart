import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/list/profile_list.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isCustomerSelectedProvider = StateProvider<bool>((ref) => true);

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isCustomerSelected = ref.watch(isCustomerSelectedProvider);
    final authState = ref.watch(authProvider);
    final role = authState.role;
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Аккаунт',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.ulight,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1, color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        ref.read(isCustomerSelectedProvider.notifier).state =
                            false;
                        await authNotifier.updateRole('Executor');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: role == 'Executor'
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Я — исполнитель',
                            style: TextStyle(
                              color: role != 'Customer'
                                  ? AppColors.violet
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        ref.read(isCustomerSelectedProvider.notifier).state =
                            true;
                        await authNotifier.updateRole('Customer');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: role == 'Customer'
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Я — заказчик',
                            style: TextStyle(
                              color: role == 'Customer'
                                  ? AppColors.violet
                                  : AppColors.light,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ProfileList(
              options: [
                ProfileOption(
                  title: 'Личные данные',
                  onTap: () {
                    AutoRouter.of(context).push(const ProfileUserDataRoute());
                  },
                ),
                ProfileOption(
                  title: 'Рейтинг и отзывы',
                  subtitle: 'Супер (Топ-10)',
                  onTap: () {
                    AutoRouter.of(context).push(const ProfileStarsRoute());
                  },
                ),
                ProfileOption(
                  title: 'Уведомления',
                  subtitle: 'Включены',
                  onTap: () {
                    AutoRouter.of(context).push(const ProfileNoteRoute());
                  },
                ),
                ProfileOption(
                  title: 'Подписка',
                  subtitle: 'Истечёт через: 3 мес',
                  onTap: () {
                    AutoRouter.of(context)
                        .push(const ProfileSubscriptionRoute());
                  },
                ),
                ProfileOption(
                  title: 'О приложении',
                  onTap: () {
                    AutoRouter.of(context).push(const ProfileAppRoute());
                  },
                ),
                ProfileOption(
                  title: 'Помощь',
                  onTap: () {
                    AutoRouter.of(context).push(const ProfileHelpRoute());
                  },
                ),
              ],
            ),
          ),
          Btn(
            text: 'Выйти',
            onPressed: () async {
              await authNotifier.onSignOut();
              AutoRouter.of(context).replace(const WelcomeRoute());
            },
            textColor: AppColors.red,
            theme: 'white',
          ),
          const Square(height: 30),
        ],
      ),
    );
  }
}
