import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String chatId;
  final String senderUserId;
  final String receiverUserId;
  final String content;
  final DateTime time;

  const Message({
    required this.chatId,
    required this.senderUserId,
    required this.receiverUserId,
    required this.content,
    required this.time,
  });

  Message copyWith({
    String? chatId,
    String? senderUserId,
    String? receiverUserId,
    String? content,
    DateTime? time,
  }) {
    return Message(
      chatId: chatId ?? this.chatId,
      senderUserId: senderUserId ?? this.senderUserId,
      receiverUserId: receiverUserId ?? this.receiverUserId,
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  factory Message.fromDocumentSnapshot(DocumentSnapshot result) {
    Map<String, dynamic> data = result.data() as Map<String, dynamic>;

    return Message(
      chatId: data['chatId'] as String,
      senderUserId: data['senderUserId'] as String,
      receiverUserId: data['receiverUserId'] as String,
      content: data['content'] as String,
      time: (data['time'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        senderUserId,
        receiverUserId,
        content,
        time,
      ];
}
