import 'package:freelance/config/dio_config.dart';
import 'package:freelance/data/models/task_models.dart';

class TaskRepository {
  Future<List<TaskModels>> fetchTasks(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await DioConfig().dio.get(
            '/tasks',
            queryParameters: queryParameters,
          );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((taskJson) => TaskModels.fromJson(taskJson))
            .toList();
      } else {
        throw Exception("Ошибка при получении задач: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при выполнении запроса: $e");
    }
  }

  Future<TaskModels> fetchTaskById(String id) async {
    final response = await DioConfig().dio.get('/tasks/$id');
    return TaskModels.fromJson(response.data);
  }

  Future<void> createTask(TaskModels task) async {
    await DioConfig().dio.post('/tasks', data: task.toJson());
  }

  Future<void> sendTaskReview(dynamic taskId) async {
    await DioConfig().dio.post('/tasks/$taskId/review');
  }

  Future<void> assignExecutor(int taskId, int responseId) async {
    try {
      final response = await DioConfig().dio.post(
            '/tasks/$taskId/response/$responseId',
          );

      if (response.statusCode == 200) {
        print('Исполнитель успешно назначен');
      } else {
        throw Exception(
            "Ошибка при назначении исполнителя: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при запросе: $e");
    }
  }
}
