import 'package:freelance/guards/auth_guard.dart';

import 'package:auto_route/auto_route.dart';
import 'package:freelance/router/app_router.gr.dart';

final authGuard = AuthGuard();
final unAuthGuard = UnAuthGuard();

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        // Маршруты для неавторизованных пользователей
        AutoRoute(
            page: WelcomeRoute.page,
            path: '/welcome',
            initial: true,
            guards: [unAuthGuard]),

        // Защищенные маршруты, доступные только авторизованным пользователям
        AutoRoute(page: AuthRoute.page, path: '/auth', guards: [unAuthGuard]),
        AutoRoute(
            page: ConfirmRoute.page, path: '/confirm', guards: [unAuthGuard]),
        AutoRoute(
          page: TaskRoute.page,
          path: '/task',
          guards: [authGuard],
          children: [
            AutoRoute(page: OpenTaskRoute.page, path: 'task/open'),
            AutoRoute(page: HistoryTaskRoute.page, path: 'task/history'),
            AutoRoute(page: NewTaskRoute.page, path: 'task/new'),
          ],
        ),
        AutoRoute(
            page: NewTaskCreateRoute.page,
            path: '/task/new',
            guards: [authGuard]),
        AutoRoute(
            page: NewDescRoute.page,
            path: '/task/new/description',
            guards: [authGuard]),
        AutoRoute(
            page: NewConfirmTaskRoute.page,
            path: '/task/new/confirm',
            guards: [authGuard]),
        AutoRoute(
            page: TaskDetailRoute.page,
            path: '/task/detail/:taskId',
            guards: [authGuard]),
        AutoRoute(
            page: TaskDetailCustomerRoute.page,
            path: '/task/detail/:taskId',
            guards: [authGuard]),
        AutoRoute(
            page: TaskResponseRoute.page,
            path: '/task/response/:taskId',
            guards: [authGuard]),
        AutoRoute(
            page: ChatsRoute.page,
            path: '/task/chats/:chatsId',
            guards: [authGuard]),
        AutoRoute(
            page: TaskCustomerProfileRoute.page,
            path: '/profile/customer/preview/:profileCustomerId',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileStarsRoute.page,
            path: '/profile/stars',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileFeedbackRoute.page,
            path: '/profile/faq/feedback',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileSubscriptionRoute.page,
            path: '/profile/subscription',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileHistoryPriceRoute.page,
            path: '/profile/history',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileHelpRoute.page,
            path: '/profile/help',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileAppRoute.page,
            path: '/profile/app',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileNoteRoute.page,
            path: '/profile/notifications',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileEditRoute.page,
            path: '/profile/edit',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileUserDataRoute.page,
            path: '/profile/user',
            guards: [authGuard]),
        AutoRoute(
            page: ProfileRoute.page, path: '/profile', guards: [authGuard]),
      ];
}
