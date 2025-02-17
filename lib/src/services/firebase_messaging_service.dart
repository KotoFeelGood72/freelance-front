import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';
import 'dart:io';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Устанавливаем, как должны отображаться уведомления в foreground (ТОЛЬКО для iOS)
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Обработка сообщений, когда приложение открыто (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Получено сообщение в foreground: ${message.notification?.title}");

      print("Вызов showNotification()");

      // Показываем локальное уведомление
      NotificationService().showNotification(
        id: message.messageId.hashCode, // Генерируем уникальный ID
        title: message.notification?.title ?? "Новое уведомление",
        body: message.notification?.body ?? "Без текста",
      );
    });

    // Обработка сообщений в фоне и когда приложение закрыто
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Открытие уведомления при нажатии (когда приложение было в background или terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Пользователь открыл уведомление: ${message.notification?.title}");
    });
  }
}

// Фоновая обработка сообщений
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Фоновое сообщение: ${message.notification?.title}");
}
