import 'dart:io';

import 'package:freelance/config/navigatorHelper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleResponseError(int statusCode, BuildContext? context) {
    switch (statusCode) {
      case HttpStatus.badRequest:
        _showSnackBar('Некорректный запрос. Проверьте данные.', context);
        break;
      case HttpStatus.unauthorized:
        NavigatorHelper.redirectToLogin();
        break;
      case HttpStatus.forbidden:
        _showSnackBar('Доступ запрещен. Проверьте права.', context);
        break;
      case HttpStatus.notFound:
        _showSnackBar('Ресурс не найден.', context);
        break;
      case HttpStatus.conflict:
        _showSnackBar('Конфликт данных. Попробуйте позже.', context);
        break;
      case HttpStatus.internalServerError:
        _showSnackBar(
            'Ошибка сервера. Пожалуйста, повторите попытку позже.', context);
        break;
      case HttpStatus.serviceUnavailable:
        _showSnackBar('Сервис временно недоступен. Попробуйте позже.', context);
        break;
      default:
        _showSnackBar('Произошла ошибка: $statusCode', context);
    }
  }

  static void handleDioError(DioException e, BuildContext? context) {
    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage =
            'Время ожидания соединения истекло. Проверьте подключение.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Время ожидания ответа от сервера истекло.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Время отправки запроса истекло.';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Ошибка сертификата безопасности.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Проблема с подключением. Проверьте интернет.';
        break;
      default:
        errorMessage = 'Произошла неизвестная ошибка. Повторите попытку позже.';
    }
    _showSnackBar(errorMessage, context);
  }

  static void _showSnackBar(String message, BuildContext? context) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
