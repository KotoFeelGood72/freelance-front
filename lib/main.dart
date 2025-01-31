import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freelance/config/token_storage.dart';
import 'package:freelance/firebase_options.dart';
import 'package:freelance/router/app_router.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/themes/text_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

final talker = Talker();

final getIt = GetIt.instance;

class LoggingRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint(
        'Pushed route: ${route.settings.name}, from: ${previousRoute?.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint(
        'Popped route: ${route.settings.name}, to: ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
        'Replaced route: ${oldRoute?.settings.name}, with: ${newRoute?.settings.name}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<AppRouter>(AppRouter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: 'assets/.env');
  runApp(
    ProviderScope(observers: [
      TalkerRiverpodObserver(
        settings: const TalkerRiverpodLoggerSettings(
          enabled: true,
          printStateFullData: false,
          printProviderAdded: false,
          printProviderUpdated: false,
          printProviderDisposed: false,
          printProviderFailed: false,
        ),
      )
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(
        navigatorObservers: () => [LoggingRouteObserver()],
      ),
      // routerDelegate: appRouter.delegate(), // Используем делегат AutoRoute
      // routeInformationParser:
      //     appRouter.defaultRouteParser(), // Парсер маршрутов AutoRoute
      // navigatorObservers: [
      //   LoggingRouteObserver(), // Для интеграции с GetX
      // ],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            AppColors.violet.value,
            {
              50: AppColors.violet.withOpacity(0.1),
              100: AppColors.violet.withOpacity(0.2),
              200: AppColors.violet.withOpacity(0.3),
              300: AppColors.violet.withOpacity(0.4),
              400: AppColors.violet.withOpacity(0.5),
              500: AppColors.violet,
              600: AppColors.violet.withOpacity(0.7),
              700: AppColors.violet.withOpacity(0.8),
              800: AppColors.violet.withOpacity(0.9),
              900: AppColors.violet,
            },
          ),
        ),
        primarySwatch: Colors.blue,
        textTheme: buildTextTheme(),
      ),
    );
  }
}
