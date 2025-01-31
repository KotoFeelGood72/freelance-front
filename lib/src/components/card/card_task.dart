import 'package:flutter/material.dart';

class CardTask extends StatelessWidget {
  final VoidCallback onTap;
  final Map<String, dynamic> task;

  const CardTask({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task['taskName'] ?? 'Без названия',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  task['taskCreated'] ?? 'Неизвестно',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Цена и срок выполнения
            Row(
              children: [
                Icon(
                  Icons.currency_ruble,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  task['taskPrice']?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  task['taskTerm'] ?? 'Не указано',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Описание задачи
            Text(
              task['taskDescription'] ?? 'Описание отсутствует',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
