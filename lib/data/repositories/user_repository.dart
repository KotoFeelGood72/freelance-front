import 'package:freelance/config/dio_config.dart';
import 'package:freelance/src/models/UserModel.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio;

  UserRepository() : _dio = DioConfig().dio;

  Future<Users> fetchUser() async {
    try {
      final response = await _dio.get('/user');
      if (response.statusCode == 200 && response.data != null) {
        return Users.fromJson(response.data);
      } else {
        throw Exception('Ошибка: ${response.statusCode}, ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Ошибка загрузки данных');
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }

  Future<void> updateUser(Users updatedUser) async {
    try {
      // Создаём карту данных
      final Map<String, dynamic> data = {
        'firstName': updatedUser.firstName,
        'lastName': updatedUser.lastName,
        'phoneNumber': updatedUser.phoneNumber,
        'aboutMySelf': updatedUser.aboutMySelf,
      };

      // Обрабатываем поле photo отдельно
      if (updatedUser.photo != null && updatedUser.photo!.isNotEmpty) {
        if (!Uri.parse(updatedUser.photo!).isAbsolute) {
          // Если photo - это локальный путь
          data['photo'] = await MultipartFile.fromFile(updatedUser.photo!);
        }
      }

      // Создаём FormData
      final formData = FormData.fromMap(data);

      // Выполняем запрос
      final response = await _dio.patch(
        '/user',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print(response);

      if (response.statusCode != 200) {
        throw Exception('Ошибка обновления: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Ошибка обновления данных');
    } catch (e) {
      throw Exception('Неизвестная ошибка при обновлении: $e');
    }
  }

  Future<Users> fetchUserById(String customerId) async {
    final response = await _dio.get('/user/customer/$customerId');
    if (response.statusCode == 200) {
      return Users.fromJson(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
