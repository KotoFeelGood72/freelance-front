import 'package:freelance/config/dio_config.dart';

class SubscriptionRepository {
  Future<dynamic> fetchHistory() async {
    final response = await DioConfig().dio.get('/subscription/history');
    return response.data;
  }

  Future<dynamic> fetchPlans() async {
    final response = await DioConfig().dio.get('/subscription/plan');
    return response.data;
  }
}
