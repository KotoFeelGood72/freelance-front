import 'package:freelance/data/models/message_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('rooms/$chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<Map<String, dynamic>?> getRoomData(String roomId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        print('Документ с ID $roomId не найден.');
        return null;
      }
    } catch (e) {
      print('Ошибка получения данных комнаты: $e');
      return null;
    }
  }

  Future<void> sendMessage(String chatId, Message message) async {
    await _firestore
        .collection('rooms/$chatId/messages')
        .add(message.toFirestore());
  }
}
