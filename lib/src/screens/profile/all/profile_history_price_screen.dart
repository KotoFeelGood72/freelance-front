import 'package:freelance/providers/subscription_providers.dart';
import 'package:freelance/src/components/placeholder/customers_none_tasks.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileHistoryPriceScreen extends ConsumerWidget {
  const ProfileHistoryPriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('История платежей')),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: AppColors.border,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: subscriptionState.when(
          data: (data) {
            if (data['history'] is! List) {
              return const Center(
                child: Text(
                  'Ошибка: некорректный формат данных',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final history = data['history'] as List<dynamic>;
            if (history.isEmpty) {
              return const Center(
                child: Text(
                  'История платежей отсутствует',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index] as Map<String, dynamic>;
                return InfoRow(
                  label: '${item['price']} ₽',
                  value: item['create_date'] ?? '',
                  hasBottomBorder: true,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              'Ошибка: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
