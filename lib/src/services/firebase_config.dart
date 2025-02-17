import 'package:freelance/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseConfig {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeFirebase() async {
    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("Firebase инициализирован");

    // Инициализация обработчика фоновых сообщений
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Инициализация Flutter Local Notifications
    await _initializeLocalNotifications();

    // Запрос разрешения для iOS
    await _requestNotificationPermission();

    // Настройка слушателей для получения сообщений
    _setupForegroundMessageListener();
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
    print("Flutter Local Notifications инициализированы");
  }

  static Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Разрешение на уведомления получено');
    } else {
      print('Разрешение на уведомления не предоставлено');
    }
  }

  static void _setupForegroundMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Получено сообщение на переднем плане');
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title,
          body: message.notification!.body,
        );
      }
    });
  }

  static void setupMessageOpenedAppListener(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] == 'chat') {
        final String messageId = message.data['message_id'] ?? '';
        print('Good');
        // context.router.push(ChatRoute(messageId: messageId)); // Переход с использованием auto_route
      }
    });
  }

  static Future<void> _showLocalNotification(
      {String? title, String? body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      0, // ID уведомления (можно использовать уникальный идентификатор для каждого уведомления)
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Обработка фонового сообщения: ${message.messageId}");
  }

  // Получение FCM токена устройства
  static Future<void> getToken() async {
    await Future.delayed(
        Duration(seconds: 2)); // Добавление задержки для стабильности
    print('Пусто');
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      // Отправьте токен на сервер для хранения
    } catch (e) {
      print("Ошибка при получении FCM токена: $e");
    }
  }
}
