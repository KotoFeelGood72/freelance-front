import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final dynamic senderId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      content: data['content'] as String,
      senderId: data['senderId'] as int,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
