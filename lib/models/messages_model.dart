import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String messageText;
  final DateTime timestamp;

  Message({required this.senderId, required this.messageText, required this.timestamp});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'] ?? '',
      messageText: data['messageText'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
