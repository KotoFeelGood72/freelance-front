import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _roleKey =
      'user_role'; // Теперь явно задаем ключ для роли

  static const String _executorDeviceTokenKey = 'executor_device_token';
  static const String _customerDeviceTokenKey = 'customer_device_token';

  // 🔹 Сохранение access токена
  static Future<void> saveToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  // 🔹 Сохранение refresh токена
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // 🔹 Получение access токена
  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // 🔹 Получение refresh токена
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // 🔹 Сохранение роли пользователя
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  // 🔹 Получение роли пользователя
  static Future<String?> getRole() async {
    return await _storage.read(key: _roleKey);
  }

  // 🔹 Сохранение `deviceToken` в зависимости от роли
  static Future<void> saveDeviceToken(String role, String deviceToken) async {
    String key =
        role == "Executor" ? _executorDeviceTokenKey : _customerDeviceTokenKey;
    await _storage.write(key: key, value: deviceToken);
  }

  // 🔹 Получение `deviceToken` в зависимости от роли
  static Future<String?> getDeviceToken(String role) async {
    String key =
        role == "Executor" ? _executorDeviceTokenKey : _customerDeviceTokenKey;

    print(role);
    return await _storage.read(key: key);
  }

  // 🔹 Удаление всех токенов (включая `deviceToken`)
  static Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _executorDeviceTokenKey);
    await _storage.delete(key: _customerDeviceTokenKey);
  }
}
