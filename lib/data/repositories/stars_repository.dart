import 'package:freelance/config/dio_config.dart';

class StarsRepository {
  Future<Map<String, dynamic>?> fetchStars({required String role}) async {
    try {
      String endpoint;
      if (role == 'Executor') {
        endpoint = '/user/executor/rating';
      } else if (role == 'Customer') {
        endpoint = '/user/customer/rating';
      } else {
        throw Exception('Неизвестная роль: $role');
      }

      final response = await DioConfig().dio.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Ошибка при запросе для роли $role: $e');
      return null;
    }
  }
}
