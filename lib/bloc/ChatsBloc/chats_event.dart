part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class CacheChats extends ChatsEvent {
  final List<DocumentSnapshot<Object?>> snapshsot;

  const CacheChats({required this.snapshsot});
}

class FetchChat extends ChatsEvent {
  final User ownerUser;
  final User otherUser;

  const FetchChat({required this.ownerUser, required this.otherUser});
}
