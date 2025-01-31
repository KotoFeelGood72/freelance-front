import 'package:freelance/providers/user_providers.dart';
import 'package:freelance/src/components/ui/Divider.dart';
import 'package:freelance/src/components/ui/avatar_img.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskCustomerProfileScreen extends ConsumerWidget {
  final dynamic profileCustomerId;
  const TaskCustomerProfileScreen({
    super.key,
    @PathParam('profileCustomerId') required this.profileCustomerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    final userState = ref.watch(userProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userNotifier.loadUserCustomer(profileCustomerId.toString());
    });

    return Scaffold(
      appBar: AppBar(title: Text('Профиль $profileCustomerId')),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
              color: AppColors.bg,
              border:
                  Border(top: BorderSide(width: 1, color: AppColors.border))),
          child: Column(
            children: [
              const Square(),
              const AvatarImg(
                  firstName: 'firstName',
                  lastName: 'lastName',
                  imageUrl: 'assets/images/splash.png',
                  isLocalImage: true),
              const Square(
                height: 32,
              ),
              const InfoRow(
                label: 'Рейтинг',
                value: 'Супер-заказчик (Топ-10)',
                hasBottomBorder: true,
              ),
              const InfoRow(
                label: 'Создано',
                value: '1000 заданий',
                hasBottomBorder: true,
              ),
              const Square(),
              Container(
                child: const Text(
                  'Для современного мира разбавленное изрядной долей эмпатии, рациональное мышление создаёт предпосылки для кластеризации усилий.',
                  style: TextStyle(color: AppColors.gray),
                ),
              )
            ],
          )),
    );
  }
}
