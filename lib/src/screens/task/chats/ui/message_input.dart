import 'package:freelance/data/models/message_models.dart';
import 'package:freelance/providers/chat_providers.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:freelance/src/provider/UserNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInput extends ConsumerStatefulWidget {
  final String chatId;

  const MessageInput({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).loadUser();
    });
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final userState = ref.watch(userProvider);

    if (userState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Не удалось отправить сообщение: пользователь не загружен'),
        ),
      );
      return;
    }

    final chatService = ref.read(chatServiceProvider);

    final senderId = userState.user!.id ?? 0; // Убедитесь, что это int

    final message = Message(
      id: '',
      content: content,
      senderId: senderId,
      timestamp: DateTime.now(),
    );

    chatService.sendMessage(widget.chatId, message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Inputs(
              backgroundColor: AppColors.bg,
              controller: _controller,
              textColor: AppColors.light,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
