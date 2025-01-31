// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:flutter/material.dart' as _i28;
import 'package:freelance/src/screens/auth/auth_screen.dart' as _i1;
import 'package:freelance/src/screens/auth/confirm_screen.dart' as _i3;
import 'package:freelance/src/screens/profile/all/profile_app_screen.dart'
    as _i10;
import 'package:freelance/src/screens/profile/all/profile_edit_screen.dart'
    as _i11;
import 'package:freelance/src/screens/profile/all/profile_feedback_screen.dart'
    as _i12;
import 'package:freelance/src/screens/profile/all/profile_help_screen.dart'
    as _i13;
import 'package:freelance/src/screens/profile/all/profile_history_price_screen.dart'
    as _i14;
import 'package:freelance/src/screens/profile/all/profile_note_screen.dart'
    as _i15;
import 'package:freelance/src/screens/profile/all/profile_stars_screen.dart'
    as _i17;
import 'package:freelance/src/screens/profile/all/profile_subscription_screen.dart'
    as _i18;
import 'package:freelance/src/screens/profile/all/profile_user_data_screen.dart'
    as _i19;
import 'package:freelance/src/screens/profile/profile_screen.dart' as _i16;
import 'package:freelance/src/screens/task/chats/chats_screen.dart' as _i2;
import 'package:freelance/src/screens/task/create/new_confirm_task_screen.dart'
    as _i5;
import 'package:freelance/src/screens/task/create/new_desc_screen.dart' as _i6;
import 'package:freelance/src/screens/task/create/new_task_create_screen.dart'
    as _i7;
import 'package:freelance/src/screens/task/customers/task_response_screen.dart'
    as _i24;
import 'package:freelance/src/screens/task/details/customer/task_customer_profile_screen.dart'
    as _i20;
import 'package:freelance/src/screens/task/details/customer/task_detail_customer.dart'
    as _i21;
import 'package:freelance/src/screens/task/details/executor/task_detail_executor.dart'
    as _i22;
import 'package:freelance/src/screens/task/details/task_detail_screen.dart'
    as _i23;
import 'package:freelance/src/screens/task/history_task_screen.dart' as _i4;
import 'package:freelance/src/screens/task/new_task_screen.dart' as _i8;
import 'package:freelance/src/screens/task/open_task_screen.dart' as _i9;
import 'package:freelance/src/screens/task/task_screen.dart' as _i25;
import 'package:freelance/src/screens/welcome/welcome_screen.dart' as _i26;

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i27.PageRouteInfo<void> {
  const AuthRoute({List<_i27.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthScreen();
    },
  );
}

/// generated route for
/// [_i2.ChatsScreen]
class ChatsRoute extends _i27.PageRouteInfo<ChatsRouteArgs> {
  ChatsRoute({
    _i28.Key? key,
    required String chatsId,
    required String taskId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         ChatsRoute.name,
         args: ChatsRouteArgs(key: key, chatsId: chatsId, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'ChatsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatsRouteArgs>();
      return _i2.ChatsScreen(
        key: args.key,
        chatsId: args.chatsId,
        taskId: args.taskId,
      );
    },
  );
}

class ChatsRouteArgs {
  const ChatsRouteArgs({this.key, required this.chatsId, required this.taskId});

  final _i28.Key? key;

  final String chatsId;

  final String taskId;

  @override
  String toString() {
    return 'ChatsRouteArgs{key: $key, chatsId: $chatsId, taskId: $taskId}';
  }
}

/// generated route for
/// [_i3.ConfirmScreen]
class ConfirmRoute extends _i27.PageRouteInfo<void> {
  const ConfirmRoute({List<_i27.PageRouteInfo>? children})
    : super(ConfirmRoute.name, initialChildren: children);

  static const String name = 'ConfirmRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i3.ConfirmScreen();
    },
  );
}

/// generated route for
/// [_i4.HistoryTaskScreen]
class HistoryTaskRoute extends _i27.PageRouteInfo<void> {
  const HistoryTaskRoute({List<_i27.PageRouteInfo>? children})
    : super(HistoryTaskRoute.name, initialChildren: children);

  static const String name = 'HistoryTaskRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i4.HistoryTaskScreen();
    },
  );
}

/// generated route for
/// [_i5.NewConfirmTaskScreen]
class NewConfirmTaskRoute extends _i27.PageRouteInfo<void> {
  const NewConfirmTaskRoute({List<_i27.PageRouteInfo>? children})
    : super(NewConfirmTaskRoute.name, initialChildren: children);

  static const String name = 'NewConfirmTaskRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i5.NewConfirmTaskScreen();
    },
  );
}

/// generated route for
/// [_i6.NewDescScreen]
class NewDescRoute extends _i27.PageRouteInfo<void> {
  const NewDescRoute({List<_i27.PageRouteInfo>? children})
    : super(NewDescRoute.name, initialChildren: children);

  static const String name = 'NewDescRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.NewDescScreen();
    },
  );
}

/// generated route for
/// [_i7.NewTaskCreateScreen]
class NewTaskCreateRoute extends _i27.PageRouteInfo<void> {
  const NewTaskCreateRoute({List<_i27.PageRouteInfo>? children})
    : super(NewTaskCreateRoute.name, initialChildren: children);

  static const String name = 'NewTaskCreateRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.NewTaskCreateScreen();
    },
  );
}

/// generated route for
/// [_i8.NewTaskScreen]
class NewTaskRoute extends _i27.PageRouteInfo<void> {
  const NewTaskRoute({List<_i27.PageRouteInfo>? children})
    : super(NewTaskRoute.name, initialChildren: children);

  static const String name = 'NewTaskRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i8.NewTaskScreen();
    },
  );
}

/// generated route for
/// [_i9.OpenTaskScreen]
class OpenTaskRoute extends _i27.PageRouteInfo<void> {
  const OpenTaskRoute({List<_i27.PageRouteInfo>? children})
    : super(OpenTaskRoute.name, initialChildren: children);

  static const String name = 'OpenTaskRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i9.OpenTaskScreen();
    },
  );
}

/// generated route for
/// [_i10.ProfileAppScreen]
class ProfileAppRoute extends _i27.PageRouteInfo<void> {
  const ProfileAppRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileAppRoute.name, initialChildren: children);

  static const String name = 'ProfileAppRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i10.ProfileAppScreen();
    },
  );
}

/// generated route for
/// [_i11.ProfileEditScreen]
class ProfileEditRoute extends _i27.PageRouteInfo<void> {
  const ProfileEditRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileEditRoute.name, initialChildren: children);

  static const String name = 'ProfileEditRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProfileEditScreen();
    },
  );
}

/// generated route for
/// [_i12.ProfileFeedbackScreen]
class ProfileFeedbackRoute extends _i27.PageRouteInfo<void> {
  const ProfileFeedbackRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileFeedbackRoute.name, initialChildren: children);

  static const String name = 'ProfileFeedbackRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.ProfileFeedbackScreen();
    },
  );
}

/// generated route for
/// [_i13.ProfileHelpScreen]
class ProfileHelpRoute extends _i27.PageRouteInfo<void> {
  const ProfileHelpRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileHelpRoute.name, initialChildren: children);

  static const String name = 'ProfileHelpRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfileHelpScreen();
    },
  );
}

/// generated route for
/// [_i14.ProfileHistoryPriceScreen]
class ProfileHistoryPriceRoute extends _i27.PageRouteInfo<void> {
  const ProfileHistoryPriceRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileHistoryPriceRoute.name, initialChildren: children);

  static const String name = 'ProfileHistoryPriceRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i14.ProfileHistoryPriceScreen();
    },
  );
}

/// generated route for
/// [_i15.ProfileNoteScreen]
class ProfileNoteRoute extends _i27.PageRouteInfo<void> {
  const ProfileNoteRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileNoteRoute.name, initialChildren: children);

  static const String name = 'ProfileNoteRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.ProfileNoteScreen();
    },
  );
}

/// generated route for
/// [_i16.ProfileScreen]
class ProfileRoute extends _i27.PageRouteInfo<void> {
  const ProfileRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i16.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i17.ProfileStarsScreen]
class ProfileStarsRoute extends _i27.PageRouteInfo<void> {
  const ProfileStarsRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileStarsRoute.name, initialChildren: children);

  static const String name = 'ProfileStarsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i17.ProfileStarsScreen();
    },
  );
}

/// generated route for
/// [_i18.ProfileSubscriptionScreen]
class ProfileSubscriptionRoute extends _i27.PageRouteInfo<void> {
  const ProfileSubscriptionRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileSubscriptionRoute.name, initialChildren: children);

  static const String name = 'ProfileSubscriptionRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i18.ProfileSubscriptionScreen();
    },
  );
}

/// generated route for
/// [_i19.ProfileUserDataScreen]
class ProfileUserDataRoute extends _i27.PageRouteInfo<void> {
  const ProfileUserDataRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileUserDataRoute.name, initialChildren: children);

  static const String name = 'ProfileUserDataRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.ProfileUserDataScreen();
    },
  );
}

/// generated route for
/// [_i20.TaskCustomerProfileScreen]
class TaskCustomerProfileRoute
    extends _i27.PageRouteInfo<TaskCustomerProfileRouteArgs> {
  TaskCustomerProfileRoute({
    _i28.Key? key,
    required dynamic profileCustomerId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TaskCustomerProfileRoute.name,
         args: TaskCustomerProfileRouteArgs(
           key: key,
           profileCustomerId: profileCustomerId,
         ),
         rawPathParams: {'profileCustomerId': profileCustomerId},
         initialChildren: children,
       );

  static const String name = 'TaskCustomerProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TaskCustomerProfileRouteArgs>(
        orElse:
            () => TaskCustomerProfileRouteArgs(
              profileCustomerId: pathParams.get('profileCustomerId'),
            ),
      );
      return _i20.TaskCustomerProfileScreen(
        key: args.key,
        profileCustomerId: args.profileCustomerId,
      );
    },
  );
}

class TaskCustomerProfileRouteArgs {
  const TaskCustomerProfileRouteArgs({
    this.key,
    required this.profileCustomerId,
  });

  final _i28.Key? key;

  final dynamic profileCustomerId;

  @override
  String toString() {
    return 'TaskCustomerProfileRouteArgs{key: $key, profileCustomerId: $profileCustomerId}';
  }
}

/// generated route for
/// [_i21.TaskDetailCustomerScreen]
class TaskDetailCustomerRoute
    extends _i27.PageRouteInfo<TaskDetailCustomerRouteArgs> {
  TaskDetailCustomerRoute({
    _i28.Key? key,
    required String taskId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TaskDetailCustomerRoute.name,
         args: TaskDetailCustomerRouteArgs(key: key, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'TaskDetailCustomerRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskDetailCustomerRouteArgs>();
      return _i21.TaskDetailCustomerScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class TaskDetailCustomerRouteArgs {
  const TaskDetailCustomerRouteArgs({this.key, required this.taskId});

  final _i28.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskDetailCustomerRouteArgs{key: $key, taskId: $taskId}';
  }
}

/// generated route for
/// [_i22.TaskDetailExecutorScreen]
class TaskDetailExecutorRoute
    extends _i27.PageRouteInfo<TaskDetailExecutorRouteArgs> {
  TaskDetailExecutorRoute({
    _i28.Key? key,
    required String taskId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TaskDetailExecutorRoute.name,
         args: TaskDetailExecutorRouteArgs(key: key, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'TaskDetailExecutorRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskDetailExecutorRouteArgs>();
      return _i22.TaskDetailExecutorScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class TaskDetailExecutorRouteArgs {
  const TaskDetailExecutorRouteArgs({this.key, required this.taskId});

  final _i28.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskDetailExecutorRouteArgs{key: $key, taskId: $taskId}';
  }
}

/// generated route for
/// [_i23.TaskDetailScreen]
class TaskDetailRoute extends _i27.PageRouteInfo<TaskDetailRouteArgs> {
  TaskDetailRoute({
    _i28.Key? key,
    required String taskId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TaskDetailRoute.name,
         args: TaskDetailRouteArgs(key: key, taskId: taskId),
         rawPathParams: {'taskId': taskId},
         initialChildren: children,
       );

  static const String name = 'TaskDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TaskDetailRouteArgs>(
        orElse:
            () => TaskDetailRouteArgs(taskId: pathParams.getString('taskId')),
      );
      return _i23.TaskDetailScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class TaskDetailRouteArgs {
  const TaskDetailRouteArgs({this.key, required this.taskId});

  final _i28.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskDetailRouteArgs{key: $key, taskId: $taskId}';
  }
}

/// generated route for
/// [_i24.TaskResponseScreen]
class TaskResponseRoute extends _i27.PageRouteInfo<TaskResponseRouteArgs> {
  TaskResponseRoute({
    _i28.Key? key,
    required String taskId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TaskResponseRoute.name,
         args: TaskResponseRouteArgs(key: key, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'TaskResponseRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskResponseRouteArgs>();
      return _i24.TaskResponseScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class TaskResponseRouteArgs {
  const TaskResponseRouteArgs({this.key, required this.taskId});

  final _i28.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskResponseRouteArgs{key: $key, taskId: $taskId}';
  }
}

/// generated route for
/// [_i25.TaskScreen]
class TaskRoute extends _i27.PageRouteInfo<void> {
  const TaskRoute({List<_i27.PageRouteInfo>? children})
    : super(TaskRoute.name, initialChildren: children);

  static const String name = 'TaskRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i25.TaskScreen();
    },
  );
}

/// generated route for
/// [_i26.WelcomeScreen]
class WelcomeRoute extends _i27.PageRouteInfo<void> {
  const WelcomeRoute({List<_i27.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.WelcomeScreen();
    },
  );
}
