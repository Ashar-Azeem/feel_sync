part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class FetchChats extends ChatsEvent {
  final List<DocumentSnapshot<Object?>> snapshsot;

  const FetchChats({required this.snapshsot});
}
