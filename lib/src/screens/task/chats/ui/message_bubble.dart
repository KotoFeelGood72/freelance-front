import 'package:freelance/data/models/message_models.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const MessageBubble({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isMine ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
