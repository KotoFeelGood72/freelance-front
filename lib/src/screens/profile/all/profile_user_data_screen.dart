import 'package:freelance/providers/user_providers.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/ui/Btn.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:freelance/src/constants/app_colors.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileUserDataScreen extends ConsumerWidget {
  const ProfileUserDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Личные данные'),
        ),
        body: userState.when(
          data: (user) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.yellow,
                      foregroundImage: NetworkImage(user.photo.toString()),
                    ),
                  ),
                  const Square(),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    label: 'Телефон',
                    value: user.phoneNumber ?? '',
                    hasBottomBorder: true,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InfoRow(
                      label: 'О себе',
                      value: user.aboutMySelf ??
                          'Для современного мира разбавленное изрядной долей эмпатии, рациональное мышление создаёт предпосылки для кластеризации усилий.',
                      hasBottomBorder: true,
                      isValueBelow: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Btn(
                              text: 'Редактировать',
                              onPressed: () {
                                AutoRouter.of(context)
                                    .push(const ProfileEditRoute());
                              },
                              theme: 'violet')),
                      const Square(),
                      SizedBox(
                          width: double.infinity,
                          child: Btn(
                              text: 'Привязать соцсети',
                              onPressed: () {},
                              theme: 'white')),
                    ],
                  ))
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Ошибка: $error'),
          ),
        ));
  }
}
