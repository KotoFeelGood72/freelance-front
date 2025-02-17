import 'package:freelance/data/models/task_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/task_repository.dart';
import '../state/task_notifier.dart';

final taskRepositoryProvider = Provider((ref) {
  return TaskRepository();
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

final taskByIdProvider =
    FutureProvider.family<TaskModels, String>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.fetchTaskById(id);
});

final taskSendReviewProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.sendTaskReview(id);
});

final assignExecutorProvider =
    FutureProvider.family<void, Map<String, int>>((ref, data) async {
  final repository = ref.watch(taskRepositoryProvider);
  await repository.assignExecutor(data['taskId']!, data['responseId']!);
});
