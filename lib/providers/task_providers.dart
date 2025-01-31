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
