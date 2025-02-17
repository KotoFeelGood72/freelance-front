import 'package:freelance/config/dio_config.dart';
import 'package:freelance/src/models/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final bool isLoading;
  final String? errorMessage;
  final Users? user;

  UserState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  UserState copyWith({
    bool? isLoading,
    String? errorMessage,
    Users? user,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final Dio _dio;

  UserNotifier()
      : _dio = DioConfig().dio,
        super(UserState());

  Future<void> loadUser() async {
    print("🔄 Загружаем пользователя...");
    state = state.copyWith(isLoading: true);
    print("📡 Перед запросом: ${state.isLoading}, ${state.user}");

    try {
      final response = await _dio.get('/user');
      print("📡 Ответ от сервера: ${response.statusCode}, ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final user = Users.fromJson(response.data);
        state = state.copyWith(isLoading: false, user: user);
        print("✅ Пользователь загружен: ${state.user}");
      } else {
        state = state.copyWith(
            isLoading: false,
            errorMessage: 'Ошибка: ${response.statusCode}, ${response.data}');
        print("❌ Ошибка при загрузке: ${state.errorMessage}");
      }
    } on DioException catch (e) {
      print("❌ Ошибка запроса: ${e.message}");
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      print("❌ Неизвестная ошибка: $e");
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
    print("📡 После загрузки: ${state.isLoading}, ${state.user}");
  }

  /// Обновление данных пользователя
  Future<void> updateUser(Users updatedUser) async {
    state = state.copyWith(isLoading: true);
    try {
      // Преобразуем объект пользователя в FormData
      final formData = FormData.fromMap({
        'firstName': updatedUser.firstName,
        'lastName': updatedUser.lastName,
        'phoneNumber': updatedUser.phoneNumber,
        'aboutMySelf': updatedUser.aboutMySelf,
        if (updatedUser.photo != null && updatedUser.photo!.isNotEmpty)
          'photo': await MultipartFile.fromFile(updatedUser.photo!),
      });

      print('Отправляемые данные (fields): ${formData.fields}');
      if (formData.files.isNotEmpty) {
        print('Отправляемый файл: ${formData.files.first.value.filename}');
      }
      final response = await _dio.patch(
        '/user',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false, user: updatedUser);
      } else {
        throw Exception("Ошибка обновления: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print('[DioError] Ошибка при обновлении: ${e.message}');
      if (e.response != null) {
        print(
            '[DioError] Ответ сервера: ${e.response?.statusCode}, ${e.response?.data}');
      }
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      print('[Ошибка] Неизвестная ошибка при обновлении: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final notifier = UserNotifier();
  print("🎯 userProvider инициализируется...");
  notifier.loadUser();
  return notifier;
});
