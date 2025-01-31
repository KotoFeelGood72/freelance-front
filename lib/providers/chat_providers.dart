import 'package:freelance/data/models/message_models.dart';
import 'package:freelance/data/service/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider((ref) => ChatService());

// Поток сообщений для конкретного чата
final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getMessages(chatId);
});

final roomDataProvider = FutureProvider.family<dynamic, String>((ref, roomId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getRoomData(roomId);
});
