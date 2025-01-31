import 'package:freelance/config/token_storage.dart';
import 'package:freelance/main.dart';
import 'package:freelance/router/app_router.dart';
import '../router/app_router.gr.dart';

class NavigatorHelper {
  static void redirectToLogin() {
    TokenStorage.deleteTokens();
    getIt<AppRouter>().replaceAll([const WelcomeRoute()]);
  }
}
