import 'package:freelance/providers/chat_providers.dart';
import 'package:freelance/providers/user_providers.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/layouts/default_layout.dart';
import 'package:freelance/src/provider/auth/AuthProvider.dart';
import 'package:freelance/src/screens/task/chats/ui/message_bubble.dart';
import 'package:freelance/src/screens/task/chats/ui/message_input.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ChatsScreen extends ConsumerWidget {
  final String chatsId;
  final String taskId;
  const ChatsScreen({super.key, required this.chatsId, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final messagesStream = ref.watch(messagesProvider(chatsId));
    final roomDataAsyncValue = ref.watch(roomDataProvider(chatsId));
    final authState = ref.watch(authProvider);
    final role = authState.role;
    return Scaffold(
      appBar: AppBar(
        title: roomDataAsyncValue.when(
          data: (roomData) => Text(' ${roomData['name']}'),
          loading: () => const Text('Загрузка...'),
          error: (e, _) => const Text('Ошибка'),
        ),
        actions: [
          roomDataAsyncValue.when(
            data: (roomData) {
              final responseId = roomData['response_id'];

              return IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () {
                  if (role == 'Customer') {
                    AutoRouter.of(context).push(
                      TaskDetailCustomerRoute(
                        taskId: taskId,
                        responseId: responseId,
                      ),
                    );
                  } else {
                    AutoRouter.of(context).push(
                      TaskDetailRoute(
                        taskId: taskId,
                      ),
                    );
                  }
                },
              );
            },
            loading: () => const SizedBox(),
            error: (e, _) => const SizedBox(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
        decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(top: BorderSide(width: 1, color: AppColors.border))),
        child: Column(
          children: [
            Expanded(
              child: messagesStream.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('Нет сообщений'),
                    );
                  }
                  print("Messages: \${messages.length}");

                  for (var message in messages) {
                    print(
                        "Message: \${message.content}, Sender: \${message.senderId}");
                  }

                  return userState.when(
                    data: (user) {
                      final currentUserId = user.id;
                      print("👤 Current User ID: ${user.id}");
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          print(
                              "📩 Message: ${message.content}, Sender: ${message.senderId}, isMine: ${message.senderId.toString() == currentUserId.toString()}");

                          return MessageBubble(
                            message: message,
                            isMine: message.senderId == currentUserId,
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                        child: Text('Ошибка загрузки пользователя: \$e')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Ошибка загрузки сообщений: \$e')),
              ),
            ),
            userState.when(
              data: (user) => MessageInput(
                chatId: chatsId,
                senderId: user.id ?? 0,
              ),
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
