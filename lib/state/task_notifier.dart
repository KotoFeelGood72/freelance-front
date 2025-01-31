import 'package:freelance/data/models/task_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/task_repository.dart';

class TaskState {
  final List<TaskModels> tasks;
  final bool isLoading;
  final String? errorMessage;

  TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskModels>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository repository;

  TaskNotifier(this.repository) : super(TaskState());

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await repository.fetchTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load tasks: $e',
      );
    }
  }
}
