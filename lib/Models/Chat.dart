import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String? chatId;
  final String user1UserId;
  final String user1UserName;
  final String? user1FCMToken;
  final String? user1ProfileLoc;
  final String user2UserId;
  final String user2UserName;
  final String? user2FCMToken;
  final String? user2ProfileLoc;
  final bool user1Seen;
  final bool user2Seen;
  final double compatibility;
  final Map<String, int> user1Emotions;
  final Map<String, int> user2Emotions;
  final String lastMessage;
  final DateTime lastMessageDateTime;

  const Chat({
    required this.lastMessageDateTime,
    required this.chatId,
    required this.user1UserId,
    required this.user1UserName,
    required this.user1FCMToken,
    required this.user1ProfileLoc,
    required this.user2UserId,
    required this.user2UserName,
    required this.user2FCMToken,
    required this.user2ProfileLoc,
    required this.user1Seen,
    required this.user2Seen,
    required this.compatibility,
    required this.user1Emotions,
    required this.user2Emotions,
    required this.lastMessage,
  });

  Chat copyWith({
    String? chatId,
    String? user1UserId,
    String? user1UserName,
    String? user1FCMToken,
    String? user1ProfileLoc,
    String? user2UserId,
    String? user2UserName,
    String? user2FCMToken,
    String? user2ProfileLoc,
    bool? user1Seen,
    bool? user2Seen,
    double? compatibility,
    Map<String, int>? user1Emotions,
    Map<String, int>? user2Emotions,
    String? lastMessage,
    DateTime? lastMessageDateTime,
  }) {
    return Chat(
        chatId: chatId ?? this.chatId,
        user1UserId: user1UserId ?? this.user1UserId,
        user1UserName: user1UserName ?? this.user1UserName,
        user1FCMToken: user1FCMToken ?? this.user1FCMToken,
        user1ProfileLoc: user1ProfileLoc ?? this.user1ProfileLoc,
        user2UserId: user2UserId ?? this.user2UserId,
        user2UserName: user2UserName ?? this.user2UserName,
        user2FCMToken: user2FCMToken ?? this.user2FCMToken,
        user2ProfileLoc: user2ProfileLoc ?? this.user2ProfileLoc,
        user1Seen: user1Seen ?? this.user1Seen,
        user2Seen: user2Seen ?? this.user2Seen,
        compatibility: compatibility ?? this.compatibility,
        user1Emotions: user1Emotions ?? this.user1Emotions,
        user2Emotions: user2Emotions ?? this.user2Emotions,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageDateTime: lastMessageDateTime ?? this.lastMessageDateTime);
  }

  factory Chat.fromDocumentSnapshot(DocumentSnapshot result) {
    Map<String, dynamic> data = result.data() as Map<String, dynamic>;
    num value = data['compatibility'];

    return Chat(
      chatId: result.id,
      user1UserId: data['user1UserId'] as String,
      user1UserName: data['user1UserName'] as String,
      user1FCMToken: data['user1FCMToken'],
      user1ProfileLoc: data['user1ProfileLoc'],
      user2UserId: data['user2UserId'] as String,
      user2UserName: data['user2UserName'] as String,
      user2FCMToken: data['user2FCMToken'],
      user2ProfileLoc: data['user2ProfileLoc'],
      user1Seen: data['user1Seen'] as bool,
      user2Seen: data['user2Seen'] as bool,
      compatibility: value.toDouble(),
      user1Emotions: Map<String, int>.from(data['user1Emotions']),
      user2Emotions: Map<String, int>.from(data['user2Emotions']),
      lastMessage: data['lastMessage'] as String,
      lastMessageDateTime: (data['lastMessageDateTime'] as Timestamp).toDate(),
    );
  }
  factory Chat.fromMap(Map<String, dynamic> data, String id) {
    num value = data['compatibility'];

    return Chat(
      chatId: id,
      user1UserId: data['user1UserId'] as String,
      user1UserName: data['user1UserName'] as String,
      user1FCMToken: data['user1FCMToken'],
      user1ProfileLoc: data['user1ProfileLoc'],
      user2UserId: data['user2UserId'] as String,
      user2UserName: data['user2UserName'] as String,
      user2FCMToken: data['user2FCMToken'],
      user2ProfileLoc: data['user2ProfileLoc'],
      user1Seen: data['user1Seen'] as bool,
      user2Seen: data['user2Seen'] as bool,
      compatibility: value.toDouble(),
      user1Emotions: Map<String, int>.from(data['user1Emotions']),
      user2Emotions: Map<String, int>.from(data['user2Emotions']),
      lastMessage: data['lastMessage'] as String,
      lastMessageDateTime: (data['lastMessageDateTime'] as Timestamp).toDate(),
    );
  }
  String? getUserId(int receiverNumber) {
    if (receiverNumber == 1) {
      return user1UserId;
    } else {
      return user2UserId;
    }
  }

  bool getSeen(String userId) {
    if (user1UserId == userId) {
      return user1Seen;
    } else {
      return user2Seen;
    }
  }

  @override
  List<Object?> get props => [
        chatId,
        user1UserId,
        user1UserName,
        user1FCMToken,
        user1ProfileLoc,
        user2UserId,
        user2UserName,
        user2FCMToken,
        user2ProfileLoc,
        user1Seen,
        user2Seen,
        compatibility,
        user1Emotions,
        user2Emotions,
        lastMessage,
        lastMessageDateTime
      ];
}
