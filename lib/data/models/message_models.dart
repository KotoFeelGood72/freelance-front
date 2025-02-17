import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final dynamic senderId;
  final DateTime created_at;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.created_at,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      content: data['content'] as String,
      senderId: data['senderId'] as int,
      created_at: data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate() // ✅ Если Timestamp
          : DateTime.parse(data['created_at']), // ✅ Если String
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'senderId': senderId,
      'created_at': Timestamp.fromDate(
          created_at), // ✅ Приводим к Timestamp при сохранении
    };
  }
}
