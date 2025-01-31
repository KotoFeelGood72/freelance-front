import 'package:freelance/config/navigatorHelper.dart';
import 'package:freelance/src/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'token_storage.dart';

final talker = TalkerFlutter.init();
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class DioConfig {
  static final DioConfig _instance = DioConfig._internal();
  late Dio dio;

  factory DioConfig() {
    return _instance;
  }

  final talkerDioLogger = TalkerDioLogger(
    talker: talker,
    settings: TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseMessage: true,
      requestPen: AnsiPen()..blue(),
      responsePen: AnsiPen()..green(),
      errorPen: AnsiPen()..red(),
      requestFilter: (options) => options.data is! FormData,
    ),
  );

  DioConfig._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) =>
            status != null &&
            (status >= 200 && status < 300 ||
                status == 401 ||
                status == 404 ||
                status == 400 ||
                status == 500),
      ),
    );

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Добавляем пользовательский заголовок для токен-запросов
          if (options.path.contains('refresh_token')) {
            options.extra['isRefreshTokenRequest'] = true;
          }

          handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401 &&
              response.requestOptions.extra['isRefreshTokenRequest'] != true) {
            // print('[DEBUG] Unauthorized (401) detected');
            final isRefreshed = await _handleTokenRefresh();

            if (isRefreshed) {
              // Повторяем оригинальный запрос
              final dio = DioConfig().dio;
              final retryResponse = await dio.request(
                response.requestOptions.path,
                options: Options(
                  method: response.requestOptions.method,
                  headers: response.requestOptions.headers,
                ),
                data: response.requestOptions.data,
                queryParameters: response.requestOptions.queryParameters,
              );
              return handler.resolve(retryResponse);
            } else {
              NavigatorHelper.redirectToLogin();
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  type: DioExceptionType.badResponse,
                  error: 'Требуется повторный вход',
                ),
              );
            }
          }

          handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              e.requestOptions.extra['isRefreshTokenRequest'] != true) {
            // print('[DEBUG] Unauthorized (401) detected in onError');
            final isRefreshed = await _handleTokenRefresh();

            if (isRefreshed) {
              // Повторяем оригинальный запрос
              final dio = DioConfig().dio;
              final retryResponse = await dio.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );
              return handler.resolve(retryResponse);
            } else {
              NavigatorHelper.redirectToLogin();
              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  type: DioExceptionType.badResponse,
                  error: 'Требуется повторный вход',
                ),
              );
            }
          }

          handler.next(e);
        },
      ),
      talkerDioLogger,
    ]);
  }

  static Future<bool> _handleTokenRefresh() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        NavigatorHelper.redirectToLogin();
        return false;
      }

      final newTokens = await AuthRepository().refreshAccessToken(refreshToken);

      if (newTokens.containsKey('accessToken') &&
          newTokens.containsKey('refreshToken')) {
        await TokenStorage.saveToken(newTokens['accessToken']!);
        await TokenStorage.saveRefreshToken(newTokens['refreshToken']!);
        return true;
      } else {
        TokenStorage.deleteTokens();
        NavigatorHelper.redirectToLogin();
        return false;
      }
    } catch (e) {
      NavigatorHelper.redirectToLogin();
      return false;
    }
  }
}
