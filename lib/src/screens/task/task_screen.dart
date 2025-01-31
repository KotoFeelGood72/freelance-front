import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/components/bar/bottom_nav_bar.dart';
import 'package:freelance/src/components/list/task_list.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:freelance/src/provider/consumer/TaskNotifier.dart';
import 'package:freelance/config/token_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final storedRole = await TokenStorage.getRole();
    setState(() {
      role = storedRole;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = ref.watch(selectedTabIndexProvider);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (role == null) {
      return const Scaffold(
        body: Center(child: Text("Ошибка: роль не найдена")),
      );
    }

    // Заголовки вкладок
    final tabTitles = role == 'Executor'
        ? ['Новые', 'Открытые', 'История']
        : ['Открытые', 'История'];

    // Фильтры задач
    final filters = role == 'Executor'
        ? [
            {'filters': 'tasks'},
            {'filters': 'open'},
            {'filters': 'history'},
          ]
        : [
            {'filters': 'tasks'},
            {'filters': 'history'},
          ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Задания $role',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (role != 'Executor')
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                AutoRouter.of(context).push(const NewTaskCreateRoute());
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.ulight,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: List.generate(tabTitles.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(selectedTabIndexProvider.notifier).state =
                            index;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            tabTitles[index],
                            style: TextStyle(
                              color: selectedTabIndex == index
                                  ? AppColors.violet
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("Refresh triggered");
          final currentFilter = filters[selectedTabIndex];
          ref.invalidate(fetchTasksProvider(currentFilter));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskList(
            filters: filters[selectedTabIndex],
            onTaskTap: (task) {
              if (role == 'Executor') {
                if (selectedTabIndex == 1) {
                  AutoRouter.of(context).push(ChatsRoute(
                      chatsId: task['roomUUID'],
                      taskId: task['id'].toString()));
                } else {
                  AutoRouter.of(context)
                      .push(TaskDetailRoute(taskId: task['id'].toString()));
                }
              } else {
                AutoRouter.of(context).push(
                  TaskResponseRoute(taskId: task['id'].toString()),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// Провайдер для активной вкладки
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
