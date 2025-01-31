import 'package:freelance/providers/stars_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freelance/src/components/ui/info_row.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileStarsScreen extends ConsumerWidget {
  const ProfileStarsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final starsState = ref.watch(starsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Рейтинг')),
      body: starsState.when(
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow(label: 'Рейтинг', value: data['rating']),
                InfoRow(
                  label: 'Выполнено',
                  value: '${data['tasks_completed']} заданий',
                  hasBottomBorder: true,
                  hasTopBorder: true,
                ),
                InfoRow(
                  label: 'Заработано',
                  value: '${data['total_earnings']} ₽',
                  hasBottomBorder: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Отзывы',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (data['reviews'] != null && data['reviews'].isNotEmpty)
                  ...data['reviews'].map<Widget>((review) {
                    return ReviewCard(
                      username: review['username'],
                      date: review['date'],
                      comment: review['comment'],
                      isPositive: review['isPositive'],
                    );
                  }).toList()
                else
                  const Text('Нет отзывов'),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Ошибка: $error'),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String username;
  final String date;
  final String comment;
  final bool isPositive;

  const ReviewCard({
    super.key,
    required this.username,
    required this.date,
    required this.comment,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.add : Icons.remove,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    comment,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
