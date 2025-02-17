import 'package:freelance/data/models/message_models.dart';
import 'package:freelance/providers/chat_providers.dart';
import 'package:freelance/src/components/ui/Inputs.dart';
import 'package:freelance/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInput extends ConsumerStatefulWidget {
  final String chatId;
  final int senderId;

  const MessageInput({
    super.key,
    required this.chatId,
    required this.senderId,
  });

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> {
  final _controller = TextEditingController();

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final chatService = ref.read(chatServiceProvider);

    final message = Message(
      id: '',
      content: content,
      senderId: widget.senderId,
      created_at: DateTime.now(),
    );

    chatService.sendMessage(widget.chatId, message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Inputs(
              backgroundColor: AppColors.white,
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
