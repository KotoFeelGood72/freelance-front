import 'package:freelance/config/dio_config.dart';
import 'package:freelance/data/repositories/task_repository.dart';
import 'package:freelance/src/provider/consumer/TaskState.dart';
import 'package:freelance/src/utils/go_to_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository;
  TaskNotifier(Ref ref)
      : _taskRepository = ref.read(taskRepositoryProvider),
        super(TaskState());

  void updateTaskName(String taskName) {
    state = state.copyWith(taskName: taskName);
  }

  void updateTaskPrice(int taskPrice) {
    // taskPrice как int
    state = state.copyWith(taskPrice: taskPrice);
  }

  void updateTaskTerm(DateTime? taskTerm) {
    // print("Дата обновлена через updateTaskTerm: $taskTerm");
    state = state.copyWith(taskTerm: taskTerm);
  }

  void updateTaskCity(String taskCity) {
    state = state.copyWith(taskCity: taskCity);
  }

  void updateTaskDescription(String taskDescription) {
    state = state.copyWith(taskDescription: taskDescription);
  }

  void clearTaskForm() {
    state = TaskState();
  }

  void validateTaskForm() {
    if (state.taskName.isEmpty) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Название задачи обязательно.',
        isErrorShown: false, // Сбрасываем флаг для повторного показа ошибки
      );
    } else if (state.taskPrice <= 0) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Стоимость должна быть больше 0.',
        isErrorShown: false,
      );
    } else if (state.taskTerm == null) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Необходимо указать срок.',
        isErrorShown: false,
      );
    } else if (state.taskCity.isEmpty) {
      state = state.copyWith(
        isValid: false,
        errorMessage: 'Необходимо указать город.',
        isErrorShown: false,
      );
    } else {
      state = state.copyWith(
        isValid: true,
        errorMessage: null,
      );
    }
  }

  Future<void> submitTask(BuildContext context) async {
    validateTaskForm();
    if (!state.isValid) {
      return;
    }

    state = state.copyWith(
        isLoading: true, errorMessage: null, isErrorShown: false);

    try {
      final Map<String, dynamic> taskData = {
        "taskName": state.taskName,
        "taskPrice": state.taskPrice,
        "taskTerm": state.taskTerm?.toIso8601String(),
        "taskCity": state.taskCity,
        "taskDescription": state.taskDescription,
      };

      final response = await DioConfig().dio.post(
            '/tasks',
            data: taskData,
          );

      if (response.statusCode == 201) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Задача успешно создана!',
          errorMessage: null,
          isErrorShown: false,
        );
        clearTaskForm();
      } else {
        throw Exception("Ошибка при создании задачи: ${response.statusCode}");
      }
    } catch (e) {
      print('Ошибка при создании задачи: $e');
      showGoToProfile('Для создания задачи необходимо заполнить профиль',
          'Профиль не заполнен');
    }
  }

  Future<void> fetchTaskResponses(String taskId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await DioConfig().dio.get(
            '/tasks/$taskId/response',
          );

      if (response.statusCode == 200) {
        final List<dynamic> responses = response.data; // Список откликов
        state = state.copyWith(
          isLoading: false,
          taskResponses: responses, // Обновляем состояние откликов
          errorMessage: null,
        );
      } else {
        throw Exception(
            "Ошибка при получении откликов: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка при получении откликов: $e',
      );
    }
  }

  // Future<void> fetchTaskById(String id) async {
  //   state = state.copyWith(isLoading: true, errorMessage: null);

  //   try {
  //     // Выполняем GET запрос для получения задачи по ID
  //     final response = await DioConfig().dio.get('/tasks/$id');

  //     if (response.statusCode == 200) {
  //       final task = response.data; // Получаем данные задачи из ответа
  //       state = state.copyWith(
  //         isLoading: false,
  //         currentTask: task, // Обновляем текущее состояние задачи
  //         errorMessage: null,
  //       );
  //     } else {
  //       throw Exception("Ошибка при получении задачи: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: 'Ошибка при получении задачи: $e',
  //     );
  //   }
  // }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      isErrorShown: true, // Помечаем ошибку как обработанную
    );
  }
}

final taskByIdProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, taskId) async {
    final response = await DioConfig().dio.get('/tasks/$taskId');
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("Ошибка при получении задачи: ${response.statusCode}");
    }
  },
);

final taskResponsesProvider = FutureProvider.family<List<dynamic>, String>(
  (ref, taskId) async {
    try {
      // Выполняем GET запрос для получения откликов по taskId
      final response = await DioConfig().dio.get('/tasks/$taskId/response');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>; // Возвращаем список откликов
      } else {
        throw Exception(
            "Ошибка при получении откликов: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при выполнении запроса: $e");
    }
  },
);

final sendTaskResponseProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final String taskId = data['taskId'];
  final String text = data['text'];

  try {
    // Выполняем POST запрос для отправки отклика
    final response = await DioConfig().dio.post(
      '/tasks/$taskId/response',
      data: {
        'text': text,
      },
    );

    if (response.statusCode == 201) {
      // Успешное выполнение запроса
      return;
    } else {
      throw Exception(
          "Ошибка при отправке отклика: ${response.statusCode} ${response.data}");
    }
  } catch (e) {
    throw Exception("Ошибка при выполнении запроса: $e");
  }
});

final fetchTasksProvider =
    FutureProvider.family<List<dynamic>, Map<String, dynamic>>(
        (ref, query) async {
  try {
    final response = await DioConfig().dio.get(
          '/tasks',
          queryParameters: query, // Передаем query параметры
        );

    if (response.statusCode == 200) {
      // Если запрос успешен, возвращаем данные (список задач)
      return response.data as List<dynamic>;
    } else {
      throw Exception("Ошибка при получении задач: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Ошибка при выполнении запроса: $e");
  }
});

// final taskNotifierProvider =
//     StateNotifierProvider<TaskNotifier, TaskState>((ref) {
//   return TaskNotifier();
// });

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});
