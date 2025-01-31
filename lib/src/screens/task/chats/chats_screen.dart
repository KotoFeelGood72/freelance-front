import 'package:freelance/providers/chat_providers.dart';
import 'package:freelance/router/app_router.gr.dart';
import 'package:freelance/src/layouts/default_layout.dart';
import 'package:freelance/src/provider/UserNotifier.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: roomDataAsyncValue.when(
          data: (roomData) => Text(' ${roomData['name']}'),
          loading: () => const Text('Загрузка...'),
          error: (e, _) => const Text('Ошибка'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              AutoRouter.of(context)
                  .push(TaskDetailCustomerRoute(taskId: taskId));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
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

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final currentUserId = userState.user!.id;
                      return MessageBubble(
                        message: message,
                        isMine: message.senderId == currentUserId,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка: $e')),
              ),
            ),
            MessageInput(
              chatId: chatsId,
            ),
          ],
        ),
      ),
    );
  }
}
